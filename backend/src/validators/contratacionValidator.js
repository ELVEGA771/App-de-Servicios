const { body, param, query } = require('express-validator');
const { CONTRACT_STATUS } = require('../utils/constants');

const createContratacionValidator = [
  body('id_servicio')
    .notEmpty().withMessage('Service ID is required')
    .isInt({ min: 1 }).withMessage('Invalid service ID'),
  body('id_sucursal')
    .notEmpty().withMessage('Sucursal ID is required')
    .isInt({ min: 1 }).withMessage('Invalid sucursal ID'),
  body('id_direccion_entrega')
    .notEmpty().withMessage('Delivery address ID is required')
    .isInt({ min: 1 }).withMessage('Invalid address ID'),
  body('codigo_cupon')
    .optional()
    .trim()
    .isLength({ max: 50 }).withMessage('Coupon code is too long'),
  body('fecha_programada')
    .optional()
    .isISO8601().withMessage('Invalid date format'),
  body('notas_cliente')
    .optional()
    .trim()
];

const updateEstadoValidator = [
  param('id')
    .isInt({ min: 1 }).withMessage('Invalid contratacion ID'),
  body('estado')
    .notEmpty().withMessage('Status is required')
    .isIn(Object.values(CONTRACT_STATUS)).withMessage('Invalid status'),
  body('notas_empresa')
    .optional()
    .trim()
];

const contratacionIdValidator = [
  param('id')
    .isInt({ min: 1 }).withMessage('Invalid contratacion ID')
];

const getContratacionesValidator = [
  query('page')
    .optional()
    .isInt({ min: 1 }).withMessage('Invalid page number'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('estado')
    .optional()
    .isIn(Object.values(CONTRACT_STATUS)).withMessage('Invalid status')
];

module.exports = {
  createContratacionValidator,
  updateEstadoValidator,
  contratacionIdValidator,
  getContratacionesValidator
};
