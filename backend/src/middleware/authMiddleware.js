const { verifyAccessToken } = require('../config/jwt');
const { sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');
const Usuario = require('../models/Usuario');

/**
 * Middleware to verify JWT token and authenticate user
 */
const authMiddleware = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return sendError(
        res,
        ERROR_CODES.AUTHENTICATION_ERROR,
        'No token provided',
        HTTP_STATUS.UNAUTHORIZED
      );
    }

    // Extract token
    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token
    let decoded;
    try {
      decoded = verifyAccessToken(token);
    } catch (error) {
      return sendError(
        res,
        ERROR_CODES.AUTHENTICATION_ERROR,
        'Invalid or expired token',
        HTTP_STATUS.UNAUTHORIZED
      );
    }

    // Check if user still exists
    const user = await Usuario.findById(decoded.id_usuario);
    if (!user) {
      return sendError(
        res,
        ERROR_CODES.AUTHENTICATION_ERROR,
        'User no longer exists',
        HTTP_STATUS.UNAUTHORIZED
      );
    }

    // Check if user is active
    if (user.estado !== 'activo') {
      return sendError(
        res,
        ERROR_CODES.AUTHENTICATION_ERROR,
        'User account is not active',
        HTTP_STATUS.UNAUTHORIZED
      );
    }

    // Attach user to request
    req.user = {
      id_usuario: user.id_usuario,
      email: user.email,
      tipo_usuario: user.tipo_usuario,
      nombre: user.nombre,
      apellido: user.apellido
    };

    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    return sendError(
      res,
      ERROR_CODES.INTERNAL_ERROR,
      'Authentication failed',
      HTTP_STATUS.INTERNAL_SERVER_ERROR
    );
  }
};

module.exports = authMiddleware;
