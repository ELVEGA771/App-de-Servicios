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
    const { email, password, nombre, apellido, telefono, tipo_usuario, razon_social, ruc_nit, fecha_nacimiento } = req.body;

    // Check if email already exists
    const existingUser = await Usuario.findByEmail(email);
    if (existingUser) {
      return sendError(res, ERROR_CODES.DUPLICATE_ENTRY, 'Email already registered', HTTP_STATUS.CONFLICT);
    }

    // Hash password
    const bcryptRounds = parseInt(process.env.BCRYPT_ROUNDS) || 10;
    const password_hash = await bcrypt.hash(password, bcryptRounds);

    // Create user and related entity in transaction
    const result = await executeTransaction(async (connection) => {
      // Create usuario
      const [userResult] = await connection.execute(
        'INSERT INTO usuario (email, password_hash, nombre, apellido, telefono, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?)',
        [email, password_hash, nombre, apellido || null, telefono || null, tipo_usuario]
      );
      const userId = userResult.insertId;

      let entityId;

      // Create cliente or empresa based on tipo_usuario
      if (tipo_usuario === USER_TYPES.CLIENT) {
        const [clienteResult] = await connection.execute(
          'INSERT INTO cliente (id_usuario, fecha_nacimiento) VALUES (?, ?)',
          [userId, fecha_nacimiento || null]
        );
        entityId = clienteResult.insertId;
      } else if (tipo_usuario === USER_TYPES.COMPANY) {
        if (!razon_social) {
          throw new Error('razon_social is required for empresa registration');
        }
        const [empresaResult] = await connection.execute(
          'INSERT INTO empresa (id_usuario, razon_social, ruc_nit) VALUES (?, ?, ?)',
          [userId, razon_social, ruc_nit || null]
        );
        entityId = empresaResult.insertId;
      }

      return { userId, entityId };
    });

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
                id_empresa: empresa.id_empresa, // ¡Este es el ID que te falta!
                razon_social: empresa.razon_social,
                ruc_nit: empresa.ruc_nit
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
        ...additionalData, // <-- Importante: Agregar esto aquí
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

/**
 * Login user
 * POST /api/auth/login
 */
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

/**
 * Get current user profile
 * GET /api/auth/me
 */
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

/**
 * Update current user profile
 * PUT /api/auth/me
 */
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

/**
 * Change password
 * PUT /api/auth/change-password
 */
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

/**
 * Logout (client-side token invalidation)
 * POST /api/auth/logout
 */
const logout = async (req, res, next) => {
  try {
    // In a stateless JWT system, logout is handled client-side by removing the token
    // For enhanced security, you could implement token blacklisting here
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
