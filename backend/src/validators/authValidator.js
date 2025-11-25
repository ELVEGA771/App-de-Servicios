const { body } = require('express-validator');
const { USER_TYPES } = require('../utils/constants');

const registerValidator = [
  body('email')
    .trim()
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Invalid email format')
    .normalizeEmail(),
  body('password')
    .notEmpty().withMessage('Password is required')
    .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
    .matches(/[A-Z]/).withMessage('Password must contain at least one uppercase letter')
    .matches(/[a-z]/).withMessage('Password must contain at least one lowercase letter')
    .matches(/[0-9]/).withMessage('Password must contain at least one number'),
  body('nombre')
    .trim()
    .notEmpty().withMessage('Name is required')
    .isLength({ max: 100 }).withMessage('Name is too long'),
  body('tipo_usuario')
    .notEmpty().withMessage('User type is required')
    .isIn(Object.values(USER_TYPES)).withMessage('Invalid user type'),
  body('apellido')
    .if(body('tipo_usuario').equals(USER_TYPES.CLIENT))
    .trim()
    .notEmpty().withMessage('Last name is required')
    .isLength({ max: 100 }).withMessage('Last name is too long'),
  body('telefono')
    .optional()
    .trim()
    .isLength({ max: 20 }).withMessage('Phone number is too long'),
  body('razon_social')
    .if(body('tipo_usuario').equals(USER_TYPES.COMPANY))
    .notEmpty().withMessage('Company name (razon_social) is required for empresa'),
  body('ruc_nit')
    .optional()
    .trim()
    .isLength({ max: 50 }).withMessage('RUC/NIT is too long'),
  body('pais')
    .if(body('tipo_usuario').equals(USER_TYPES.COMPANY))
    .optional() // O .notEmpty() si lo hiciste obligatorio en BD
    .trim()
    .isLength({ max: 50 }).withMessage('Country name is too long'),
];

const loginValidator = [
  body('email')
    .trim()
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Invalid email format')
    .normalizeEmail(),
  body('password')
    .notEmpty().withMessage('Password is required')
];

const changePasswordValidator = [
  body('currentPassword')
    .notEmpty().withMessage('Current password is required'),
  body('newPassword')
    .notEmpty().withMessage('New password is required')
    .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
    .matches(/[A-Z]/).withMessage('Password must contain at least one uppercase letter')
    .matches(/[a-z]/).withMessage('Password must contain at least one lowercase letter')
    .matches(/[0-9]/).withMessage('Password must contain at least one number')
];

module.exports = {
  registerValidator,
  loginValidator,
  changePasswordValidator
};
