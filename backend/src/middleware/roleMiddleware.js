const { sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

/**
 * Middleware to check if user has required role
 * @param {...String} allowedRoles - Allowed user types (cliente, empresa, admin, etc.)
 */
const roleMiddleware = (...allowedRoles) => {
  return (req, res, next) => {
    // Check if user is authenticated (should be added by authMiddleware)
    if (!req.user) {
      return sendError(
        res,
        ERROR_CODES.AUTHENTICATION_ERROR,
        'User not authenticated',
        HTTP_STATUS.UNAUTHORIZED
      );
    }

    // Check if user's role is in allowed roles
    if (!allowedRoles.includes(req.user.tipo_usuario)) {
      return sendError(
        res,
        ERROR_CODES.AUTHORIZATION_ERROR,
        'You do not have permission to access this resource',
        HTTP_STATUS.FORBIDDEN
      );
    }

    next();
  };
};

module.exports = roleMiddleware;
