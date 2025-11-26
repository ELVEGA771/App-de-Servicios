const bcrypt = require('bcrypt');
const { generateAccessToken, generateRefreshToken } = require('../config/jwt');
const { executeTransaction } = require('../config/database');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES } = require('../utils/constants');
const Usuario = require('../models/Usuario');
const Cliente = require('../models/Cliente');
const Empresa = require('../models/Empresa');
const logger = require('../utils/logger');

/**
 * Register new user (cliente or empresa)
 * POST /api/auth/register
 */
const register = async (req, res, next) => {
  try {
    const { email, password, nombre, apellido, telefono, tipo_usuario, razon_social, ruc_nit, pais } = req.body;

    // Hash password (ALWAYS done in backend for security)
    const bcryptRounds = parseInt(process.env.BCRYPT_ROUNDS) || 10;
    const password_hash = await bcrypt.hash(password, bcryptRounds);

    // Call stored procedure
    const { executeQuery } = require('../config/database');

    const query = `
      CALL sp_registrar_usuario(
        ?, ?, ?, ?, ?, ?, ?, ?, ?,
        @out_id_usuario, @out_id_entidad, @out_mensaje
      )
    `;
    const params = [
      email,
      password_hash,
      nombre,
      apellido || null,
      telefono || null,
      tipo_usuario,
      razon_social || null,
      ruc_nit || null,
      pais || null
    ];

    await executeQuery(query, params);

    // Get output parameters
    const resultQuery = 'SELECT @out_id_usuario as userId, @out_id_entidad as entityId, @out_mensaje as mensaje';
    const results = await executeQuery(resultQuery);

    if (!results[0].userId) {
      return sendError(res, ERROR_CODES.DUPLICATE_ENTRY, results[0].mensaje || 'Error al registrar usuario', HTTP_STATUS.CONFLICT);
    }

    const result = { userId: results[0].userId, entityId: results[0].entityId };

    logger.info(`New user registered: ${email} (${tipo_usuario})`);

    // Generate tokens
    const tokenPayload = {
      id_usuario: result.userId,
      email,
      tipo_usuario
    };
    const accessToken = generateAccessToken(tokenPayload);
    const refreshToken = generateRefreshToken(tokenPayload);

    let additionalData = {};
    if (tipo_usuario === USER_TYPES.COMPANY) {
        // Buscamos la empresa recién creada para devolver su ID
        const empresa = await Empresa.findByUserId(result.userId);
        if (empresa) {
            additionalData.empresa = {
                id_empresa: empresa.id_empresa,
                id_usuario: result.userId,
                nombre: nombre,
                razon_social: empresa.razon_social,
                ruc_nit: empresa.ruc_nit,
                pais: empresa.pais,
                descripcion: empresa.descripcion || '',
                logo: empresa.logo_url
            };
        }
    } else if (tipo_usuario === USER_TYPES.CLIENT) {
        const cliente = await Cliente.findByUserId(result.userId);
        if (cliente) {
            additionalData.cliente = cliente;
        }
    }
    sendSuccess(
      res,
      {
        user: { id_usuario: result.userId, email, nombre, apellido, tipo_usuario },
        ...additionalData,
        accessToken,
        refreshToken
      },
      'User registered successfully',
      HTTP_STATUS.CREATED
    );
  } catch (error) {
    next(error);
  }
};

// ... resto del archivo (login, getMe, etc) se mantiene igual ...
// Solo asegúrate de copiar el resto de las funciones que ya tenías en el archivo original.
// Aquí te incluyo login, getMe, updateMe, changePassword y logout para que el archivo esté completo si copias todo.

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    const user = await Usuario.findByEmail(email);
    if (!user) {
      return sendError(res, ERROR_CODES.AUTHENTICATION_ERROR, 'Invalid credentials', HTTP_STATUS.UNAUTHORIZED);
    }

    // Check if user is active
    if (user.estado !== 'activo') {
      return sendError(res, ERROR_CODES.AUTHENTICATION_ERROR, 'Account is not active', HTTP_STATUS.UNAUTHORIZED);
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      logger.warn(`Failed login attempt for email: ${email}`);
      return sendError(res, ERROR_CODES.AUTHENTICATION_ERROR, 'Invalid credentials', HTTP_STATUS.UNAUTHORIZED);
    }

    logger.info(`User logged in: ${email}`);

    // Get additional data based on user type
    let additionalData = {};
    if (user.tipo_usuario === USER_TYPES.CLIENT) {
      const cliente = await Cliente.findByUserId(user.id_usuario);
      if (cliente) {
        additionalData.cliente = {
          id_cliente: cliente.id_cliente,
          fecha_nacimiento: cliente.fecha_nacimiento,
          calificacion_promedio: cliente.calificacion_promedio
        };
      }
    } else if (user.tipo_usuario === USER_TYPES.COMPANY) {
      const empresa = await Empresa.findByUserId(user.id_usuario);
      if (empresa) {
        additionalData.empresa = {
          id_empresa: empresa.id_empresa,
          id_usuario: empresa.id_usuario,
          nombre: user.nombre,
          razon_social: empresa.razon_social,
          ruc_nit: empresa.ruc_nit,
          descripcion: empresa.descripcion,
          logo_url: empresa.logo_url,
          calificacion_promedio: empresa.calificacion_promedio
        };
      }
    }

    // Generate tokens
    const tokenPayload = {
      id_usuario: user.id_usuario,
      email: user.email,
      tipo_usuario: user.tipo_usuario
    };
    const accessToken = generateAccessToken(tokenPayload);
    const refreshToken = generateRefreshToken(tokenPayload);

    sendSuccess(res, {
      user: {
        id_usuario: user.id_usuario,
        email: user.email,
        nombre: user.nombre,
        apellido: user.apellido,
        tipo_usuario: user.tipo_usuario,
        foto_perfil_url: user.foto_perfil_url
      },
      ...additionalData,
      accessToken,
      refreshToken
    }, 'Login successful');
  } catch (error) {
    next(error);
  }
};

const getMe = async (req, res, next) => {
  try {
    const user = await Usuario.findById(req.user.id_usuario);
    if (!user) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'User not found', HTTP_STATUS.NOT_FOUND);
    }

    // Remove sensitive data
    delete user.password_hash;

    // Get additional data based on user type
    let additionalData = {};
    if (user.tipo_usuario === USER_TYPES.CLIENT) {
      const cliente = await Cliente.findByUserId(user.id_usuario);
      if (cliente) {
        additionalData = {
          id_cliente: cliente.id_cliente,
          fecha_nacimiento: cliente.fecha_nacimiento,
          calificacion_promedio: cliente.calificacion_promedio
        };
      }
    } else if (user.tipo_usuario === USER_TYPES.COMPANY) {
      const empresa = await Empresa.findByUserId(user.id_usuario);
      if (empresa) {
        additionalData = {
          id_empresa: empresa.id_empresa,
          razon_social: empresa.razon_social,
          ruc_nit: empresa.ruc_nit,
          descripcion: empresa.descripcion,
          logo_url: empresa.logo_url,
          calificacion_promedio: empresa.calificacion_promedio
        };
      }
    }

    sendSuccess(res, { ...user, ...additionalData });
  } catch (error) {
    next(error);
  }
};

const updateMe = async (req, res, next) => {
  try {
    const { nombre, apellido, telefono, foto_perfil_url, razon_social, descripcion, logo_url, fecha_nacimiento } = req.body;

    // Update usuario
    const userData = {};
    if (nombre !== undefined) userData.nombre = nombre;
    if (apellido !== undefined) userData.apellido = apellido;
    if (telefono !== undefined) userData.telefono = telefono;
    if (foto_perfil_url !== undefined) userData.foto_perfil_url = foto_perfil_url;

    if (Object.keys(userData).length > 0) {
      await Usuario.update(req.user.id_usuario, userData);
    }

    // Update specific entity
    if (req.user.tipo_usuario === USER_TYPES.COMPANY) {
      const empresa = await Empresa.findByUserId(req.user.id_usuario);
      if (empresa) {
        const empresaData = {};
        if (razon_social !== undefined) empresaData.razon_social = razon_social;
        if (descripcion !== undefined) empresaData.descripcion = descripcion;
        if (logo_url !== undefined) empresaData.logo_url = logo_url;

        if (Object.keys(empresaData).length > 0) {
          await Empresa.update(empresa.id_empresa, empresaData);
        }
      }
    } else if (req.user.tipo_usuario === USER_TYPES.CLIENT) {
      const cliente = await Cliente.findByUserId(req.user.id_usuario);
      if (cliente && fecha_nacimiento !== undefined) {
        await Cliente.update(cliente.id_cliente, { fecha_nacimiento });
      }
    }

    // Get updated user
    const updatedUser = await Usuario.findById(req.user.id_usuario);
    delete updatedUser.password_hash;

    sendSuccess(res, updatedUser, 'Profile updated successfully');
  } catch (error) {
    next(error);
  }
};

const changePassword = async (req, res, next) => {
  try {
    const { currentPassword, newPassword } = req.body;

    // Get user with password
    const user = await Usuario.findById(req.user.id_usuario);
    if (!user) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'User not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify current password
    const isPasswordValid = await bcrypt.compare(currentPassword, user.password_hash);
    if (!isPasswordValid) {
      return sendError(res, ERROR_CODES.AUTHENTICATION_ERROR, 'Current password is incorrect', HTTP_STATUS.UNAUTHORIZED);
    }

    // Hash new password
    const bcryptRounds = parseInt(process.env.BCRYPT_ROUNDS) || 10;
    const newPasswordHash = await bcrypt.hash(newPassword, bcryptRounds);

    // Update password
    await Usuario.updatePassword(req.user.id_usuario, newPasswordHash);

    logger.info(`Password changed for user: ${user.email}`);

    sendSuccess(res, null, 'Password changed successfully');
  } catch (error) {
    next(error);
  }
};

const logout = async (req, res, next) => {
  try {
    logger.info(`User logged out: ${req.user.email}`);
    sendSuccess(res, null, 'Logout successful');
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  getMe,
  updateMe,
  changePassword,
  logout
};