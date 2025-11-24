const { HTTP_STATUS } = require('./constants');

/**
 * Format success response
 * @param {Object} data - Response data
 * @param {String} message - Success message
 * @returns {Object} Formatted response
 */
const successResponse = (data, message = 'Operation successful') => {
  return {
    success: true,
    data,
    message
  };
};

/**
 * Format paginated response
 * @param {Array} data - Response data array
 * @param {Number} page - Current page
 * @param {Number} limit - Items per page
 * @param {Number} total - Total items count
 * @param {String} message - Success message
 * @returns {Object} Formatted paginated response
 */
const paginatedResponse = (data, page, limit, total, message = 'Data retrieved successfully') => {
  const totalPages = Math.ceil(total / limit);

  return {
    success: true,
    data,
    pagination: {
      page: parseInt(page),
      limit: parseInt(limit),
      total,
      totalPages,
      hasNextPage: page < totalPages,
      hasPrevPage: page > 1
    },
    message
  };
};

/**
 * Format error response
 * @param {String} code - Error code
 * @param {String} message - Error message
 * @param {Array} details - Error details array
 * @returns {Object} Formatted error response
 */
const errorResponse = (code, message, details = null) => {
  const response = {
    success: false,
    error: {
      code,
      message
    }
  };

  if (details && details.length > 0) {
    response.error.details = details;
  }

  return response;
};

/**
 * Format validation error response
 * @param {Array} errors - Validation errors from express-validator
 * @returns {Object} Formatted validation error response
 */
const validationErrorResponse = (errors) => {
  const details = errors.map(err => ({
    field: err.path || err.param,
    message: err.msg,
    value: err.value
  }));

  return errorResponse(
    'VALIDATION_ERROR',
    'Invalid input data',
    details
  );
};

/**
 * Send success response
 * @param {Object} res - Express response object
 * @param {Object} data - Response data
 * @param {String} message - Success message
 * @param {Number} statusCode - HTTP status code
 */
const sendSuccess = (res, data, message = 'Operation successful', statusCode = HTTP_STATUS.OK) => {
  res.status(statusCode).json(successResponse(data, message));
};

/**
 * Send paginated response
 * @param {Object} res - Express response object
 * @param {Array} data - Response data array
 * @param {Number} page - Current page
 * @param {Number} limit - Items per page
 * @param {Number} total - Total items count
 * @param {String} message - Success message
 */
const sendPaginated = (res, data, page, limit, total, message = 'Data retrieved successfully') => {
  res.status(HTTP_STATUS.OK).json(paginatedResponse(data, page, limit, total, message));
};

/**
 * Send error response
 * @param {Object} res - Express response object
 * @param {String} code - Error code
 * @param {String} message - Error message
 * @param {Number} statusCode - HTTP status code
 * @param {Array} details - Error details
 */
const sendError = (res, code, message, statusCode = HTTP_STATUS.BAD_REQUEST, details = null) => {
  res.status(statusCode).json(errorResponse(code, message, details));
};

module.exports = {
  successResponse,
  paginatedResponse,
  errorResponse,
  validationErrorResponse,
  sendSuccess,
  sendPaginated,
  sendError
};
