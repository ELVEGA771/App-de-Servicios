const { RateLimiterMemory } = require('rate-limiter-flexible');
const { sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

// General rate limiter - 100 requests per minute
const generalRateLimiter = new RateLimiterMemory({
  points: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  duration: (parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 60000) / 1000
});

// Strict rate limiter for auth endpoints - 5 requests per minute
const authRateLimiter = new RateLimiterMemory({
  points: 5,
  duration: 60,
  blockDuration: 300 // Block for 5 minutes after exceeding limit
});

/**
 * General rate limiting middleware
 */
const rateLimiterMiddleware = async (req, res, next) => {
  try {
    const key = req.ip;
    await generalRateLimiter.consume(key);
    next();
  } catch (error) {
    return sendError(
      res,
      ERROR_CODES.INTERNAL_ERROR,
      'Too many requests, please try again later',
      HTTP_STATUS.TOO_MANY_REQUESTS
    );
  }
};

/**
 * Strict rate limiting for authentication endpoints
 */
const authRateLimiterMiddleware = async (req, res, next) => {
  try {
    const key = req.ip;
    await authRateLimiter.consume(key);
    next();
  } catch (error) {
    return sendError(
      res,
      ERROR_CODES.INTERNAL_ERROR,
      'Too many login attempts, please try again in 5 minutes',
      HTTP_STATUS.TOO_MANY_REQUESTS
    );
  }
};

module.exports = {
  rateLimiterMiddleware,
  authRateLimiterMiddleware
};
