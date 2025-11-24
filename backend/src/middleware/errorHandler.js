const { errorResponse } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');
const logger = require('../utils/logger');

/**
 * Centralized error handling middleware
 */
const errorHandler = (err, req, res, next) => {
  // Log error
  logger.error('Error occurred:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userId: req.user?.id_usuario
  });

  // Default error
  let statusCode = HTTP_STATUS.INTERNAL_SERVER_ERROR;
  let errorCode = ERROR_CODES.INTERNAL_ERROR;
  let message = 'Internal server error';
  let details = null;

  // Handle specific error types
  if (err.code === 'ER_DUP_ENTRY') {
    statusCode = HTTP_STATUS.CONFLICT;
    errorCode = ERROR_CODES.DUPLICATE_ENTRY;
    message = 'Duplicate entry - resource already exists';

    // Extract field from error message
    const match = err.message.match(/for key '(.+?)'/);
    if (match) {
      details = [{ field: match[1], message: 'This value already exists' }];
    }
  } else if (err.code === 'ER_NO_REFERENCED_ROW_2') {
    statusCode = HTTP_STATUS.BAD_REQUEST;
    errorCode = ERROR_CODES.VALIDATION_ERROR;
    message = 'Referenced resource does not exist';
  } else if (err.code === 'ER_ROW_IS_REFERENCED_2') {
    statusCode = HTTP_STATUS.CONFLICT;
    errorCode = ERROR_CODES.DATABASE_ERROR;
    message = 'Cannot delete resource - it is being referenced';
  } else if (err.name === 'ValidationError') {
    statusCode = HTTP_STATUS.BAD_REQUEST;
    errorCode = ERROR_CODES.VALIDATION_ERROR;
    message = err.message || 'Validation error';
    details = err.details || null;
  } else if (err.statusCode) {
    // Custom error with status code
    statusCode = err.statusCode;
    errorCode = err.code || ERROR_CODES.INTERNAL_ERROR;
    message = err.message;
    details = err.details || null;
  }

  // Don't expose sensitive error details in production
  if (process.env.NODE_ENV === 'production') {
    // Generic message for database errors
    if (err.code && err.code.startsWith('ER_')) {
      message = 'Database operation failed';
    }
  } else {
    // Include error details in development
    if (!details && err.sqlMessage) {
      details = [{ sql: err.sqlMessage }];
    }
  }

  res.status(statusCode).json(errorResponse(errorCode, message, details));
};

/**
 * Handle 404 errors
 */
const notFoundHandler = (req, res) => {
  res.status(HTTP_STATUS.NOT_FOUND).json(
    errorResponse(
      ERROR_CODES.NOT_FOUND,
      `Route ${req.method} ${req.url} not found`
    )
  );
};

/**
 * Async handler wrapper to catch errors in async route handlers
 */
const asyncHandler = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

module.exports = {
  errorHandler,
  notFoundHandler,
  asyncHandler
};
