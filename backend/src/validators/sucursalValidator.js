const { body, param } = require('express-validator');
const { BRANCH_STATUS } = require('../utils/constants');

const createSucursalValidator = [
  body('nombre_sucursal')
    .trim()
    .notEmpty().withMessage('Sucursal name is required')
    .isLength({ min: 3 }).withMessage('Sucursal name must be at least 3 characters'),
  body('telefono')
    .optional()
    .trim()
    .matches(/^[0-9\s\-\+\(\)]+$/).withMessage('Invalid phone format'),
  body('email')
    .optional()
    .trim()
    .isEmail().withMessage('Invalid email format'),
  body('calle_principal')
    .trim()
    .notEmpty().withMessage('Main street is required')
    .isLength({ min: 3 }).withMessage('Main street must be at least 3 characters'),
  body('calle_secundaria')
    .optional()
    .trim(),
  body('numero')
    .optional()
    .trim(),
  body('ciudad')
    .trim()
    .notEmpty().withMessage('City is required')
    .isLength({ min: 2 }).withMessage('City must be at least 2 characters'),
  body('provincia_estado')
    .trim()
    .notEmpty().withMessage('Province/state is required'),
  body('codigo_postal')
    .optional()
    .trim(),
  body('pais')
    .optional()
    .trim(),
  body('latitud')
    .optional()
    .isFloat({ min: -90, max: 90 }).withMessage('Latitude must be between -90 and 90'),
  body('longitud')
    .optional()
    .isFloat({ min: -180, max: 180 }).withMessage('Longitude must be between -180 and 180'),
  body('referencia')
    .optional()
    .trim(),
  body('estado')
    .optional()
    .isIn([BRANCH_STATUS.ACTIVE, BRANCH_STATUS.INACTIVE]).withMessage('Invalid status')
];

const updateSucursalValidator = [
  body('nombre_sucursal')
    .optional()
    .trim()
    .isLength({ min: 3 }).withMessage('Sucursal name must be at least 3 characters'),
  body('telefono')
    .optional()
    .trim()
    .matches(/^[0-9\s\-\+\(\)]+$/).withMessage('Invalid phone format'),
  body('email')
    .optional()
    .trim()
    .isEmail().withMessage('Invalid email format'),
  body('calle_principal')
    .optional()
    .trim()
    .isLength({ min: 3 }).withMessage('Main street must be at least 3 characters'),
  body('calle_secundaria')
    .optional()
    .trim(),
  body('numero')
    .optional()
    .trim(),
  body('ciudad')
    .optional()
    .trim()
    .isLength({ min: 2 }).withMessage('City must be at least 2 characters'),
  body('provincia_estado')
    .optional()
    .trim(),
  body('codigo_postal')
    .optional()
    .trim(),
  body('pais')
    .optional()
    .trim(),
  body('latitud')
    .optional()
    .isFloat({ min: -90, max: 90 }).withMessage('Latitude must be between -90 and 90'),
  body('longitud')
    .optional()
    .isFloat({ min: -180, max: 180 }).withMessage('Longitude must be between -180 and 180'),
  body('referencia')
    .optional()
    .trim(),
  body('estado')
    .optional()
    .isIn([BRANCH_STATUS.ACTIVE, BRANCH_STATUS.INACTIVE]).withMessage('Invalid status')
];

const sucursalIdValidator = [
  param('id')
    .isInt({ min: 1 }).withMessage('Invalid sucursal ID')
];

module.exports = {
  createSucursalValidator,
  updateSucursalValidator,
  sucursalIdValidator
};
