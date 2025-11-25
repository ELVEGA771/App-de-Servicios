const { body, query, param } = require('express-validator');
const { SERVICE_STATUS } = require('../utils/constants');

const createServicioValidator = [
  body('nombre')
    .trim()
    .notEmpty().withMessage('Service name is required')
    .isLength({ max: 200 }).withMessage('Name is too long'),
  body('descripcion')
    .optional()
    .trim(),
  body('precio_base')
    .notEmpty().withMessage('Base price is required')
    .isFloat({ min: 0 }).withMessage('Price must be a positive number'),
  body('id_categoria')
    .notEmpty().withMessage('Category is required')
    .isInt({ min: 1 }).withMessage('Invalid category ID'),
  body('duracion_estimada')
    .optional()
    .isInt({ min: 1 }).withMessage('Duration must be a positive number'),
  body('imagen_url')
    .optional()
    .trim()
    // CAMBIO AQUÍ: require_tld: false permite 'localhost'
    .isURL({ require_tld: false }).withMessage('Invalid image URL'), 
  body('estado')
    .optional()
    .isIn(Object.values(SERVICE_STATUS)).withMessage('Invalid service status')
];

const updateServicioValidator = [
  body('nombre')
    .optional()
    .trim()
    .isLength({ max: 200 }).withMessage('Name is too long'),
  body('descripcion')
    .optional()
    .trim(),
  body('precio_base')
    .optional()
    .isFloat({ min: 0 }).withMessage('Price must be a positive number'),
  body('id_categoria')
    .optional()
    .isInt({ min: 1 }).withMessage('Invalid category ID'),
  body('duracion_estimada')
    .optional()
    .isInt({ min: 1 }).withMessage('Duration must be a positive number'),
  body('imagen_url')
    .optional()
    .trim()
    // CAMBIO AQUÍ TAMBIÉN
    .isURL({ require_tld: false }).withMessage('Invalid image URL'),
  body('estado')
    .optional()
    .isIn(Object.values(SERVICE_STATUS)).withMessage('Invalid service status')
];

const servicioIdValidator = [
  param('id')
    .isInt({ min: 1 }).withMessage('Invalid service ID')
];

const searchServiciosValidator = [
  query('q')
    .optional()
    .trim()
    .isLength({ min: 2 }).withMessage('Search query must be at least 2 characters'),
  query('ciudad')
    .optional()
    .trim(),
  query('categoria')
    .optional()
    .trim(),
  query('id_categoria')
    .optional()
    .isInt({ min: 1 }).withMessage('Invalid category ID'),
  query('precio_min')
    .optional()
    .isFloat({ min: 0 }).withMessage('Invalid minimum price'),
  query('precio_max')
    .optional()
    .isFloat({ min: 0 }).withMessage('Invalid maximum price'),
  query('calificacion_min')
    .optional()
    .isFloat({ min: 0, max: 5 }).withMessage('Rating must be between 0 and 5'),
  query('ordenar')
    .optional()
    .isIn(['precio_asc', 'precio_desc', 'calificacion', 'recientes']).withMessage('Invalid sort option'),
  query('page')
    .optional()
    .isInt({ min: 1 }).withMessage('Invalid page number'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100')
];

const addToSucursalValidator = [
  param('id')
    .isInt({ min: 1 }).withMessage('Invalid service ID'),
  body('id_sucursal')
    .notEmpty().withMessage('Sucursal ID is required')
    .isInt({ min: 1 }).withMessage('Invalid sucursal ID'),
  body('precio_sucursal')
    .optional()
    .isFloat({ min: 0 }).withMessage('Price must be a positive number')
];

module.exports = {
  createServicioValidator,
  updateServicioValidator,
  servicioIdValidator,
  searchServiciosValidator,
  addToSucursalValidator
};