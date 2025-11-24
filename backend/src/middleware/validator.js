const { validationResult } = require('express-validator');
const { validationErrorResponse } = require('../utils/responseFormatter');
const { HTTP_STATUS } = require('../utils/constants');

/**
 * Middleware to handle validation errors from express-validator
 */
const validateRequest = (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res
      .status(HTTP_STATUS.UNPROCESSABLE_ENTITY)
      .json(validationErrorResponse(errors.array()));
  }

  next();
};

module.exports = validateRequest;
