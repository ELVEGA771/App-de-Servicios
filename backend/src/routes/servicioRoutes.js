const express = require('express');
const router = express.Router();
const servicioController = require('../controllers/servicioController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const validateRequest = require('../middleware/validator');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');
const {
  createServicioValidator,
  updateServicioValidator,
  servicioIdValidator,
  searchServiciosValidator,
  addToSucursalValidator
} = require('../validators/servicioValidator');

/**
 * @swagger
 * tags:
 *   name: Servicios
 *   description: Service management
 */

/**
 * @swagger
 * /api/servicios/buscar:
 *   get:
 *     summary: Search services
 *     tags: [Servicios]
 *     parameters:
 *       - in: query
 *         name: q
 *         schema:
 *           type: string
 *         description: Search query
 *       - in: query
 *         name: ciudad
 *         schema:
 *           type: string
 *       - in: query
 *         name: categoria
 *         schema:
 *           type: string
 *       - in: query
 *         name: precio_min
 *         schema:
 *           type: number
 *       - in: query
 *         name: precio_max
 *         schema:
 *           type: number
 *     responses:
 *       200:
 *         description: Search results retrieved
 */
router.get('/buscar',
  searchServiciosValidator,
  validateRequest,
  asyncHandler(servicioController.searchServicios)
);

/**
 * @swagger
 * /api/servicios/mis-servicios:
 *   get:
 *     summary: Get my services (empresa only)
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Services retrieved successfully
 */
router.get('/mis-servicios',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  asyncHandler(servicioController.getMisServicios)
);

/**
 * @swagger
 * /api/servicios:
 *   get:
 *     summary: Get all services
 *     tags: [Servicios]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: List of services
 */
router.get('/',
  asyncHandler(servicioController.getAllServicios)
);

/**
 * @swagger
 * /api/servicios:
 *   post:
 *     summary: Create new service (empresa only)
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nombre
 *               - precio_base
 *               - id_categoria
 *     responses:
 *       201:
 *         description: Service created
 */
router.post('/',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  createServicioValidator,
  validateRequest,
  asyncHandler(servicioController.createServicio)
);

/**
 * @swagger
 * /api/servicios/empresa/{id}:
 *   get:
 *     summary: Get services by empresa
 *     tags: [Servicios]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Services retrieved
 */
router.get('/empresa/:id',
  servicioIdValidator,
  validateRequest,
  asyncHandler(servicioController.getServiciosByEmpresa)
);

/**
 * @swagger
 * /api/servicios/{id}/sucursales/{idSucursal}/disponibilidad:
 *   patch:
 *     summary: Toggle service availability in sucursal
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *       - in: path
 *         name: idSucursal
 *         required: true
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               disponible:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: Service availability updated
 */
router.patch('/:id/sucursales/:idSucursal/disponibilidad',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  asyncHandler(servicioController.toggleDisponibilidadSucursal)
);

/**
 * @swagger
 * /api/servicios/{id}/sucursales/{idSucursal}:
 *   delete:
 *     summary: Remove service from sucursal
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *       - in: path
 *         name: idSucursal
 *         required: true
 *     responses:
 *       200:
 *         description: Service removed from sucursal
 */
router.delete('/:id/sucursales/:idSucursal',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  asyncHandler(servicioController.removeServicioFromSucursal)
);

/**
 * @swagger
 * /api/servicios/{id}/sucursales:
 *   post:
 *     summary: Add service to sucursal
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Service added to sucursal
 */
router.post('/:id/sucursales',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  addToSucursalValidator,
  validateRequest,
  asyncHandler(servicioController.addServicioToSucursal)
);

/**
 * @swagger
 * /api/servicios/{id}/sucursales:
 *   put:
 *     summary: Update service sucursales
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Service sucursales updated
 */
router.put('/:id/sucursales',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  asyncHandler(servicioController.updateServicioSucursales)
);

/**
 * @swagger
 * /api/servicios/{id}:
 *   get:
 *     summary: Get service by ID
 *     tags: [Servicios]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Service details
 */
router.get('/:id',
  servicioIdValidator,
  validateRequest,
  asyncHandler(servicioController.getServicioById)
);

/**
 * @swagger
 * /api/servicios/{id}:
 *   put:
 *     summary: Update service
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Service updated
 */
router.put('/:id',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  servicioIdValidator,
  updateServicioValidator,
  validateRequest,
  asyncHandler(servicioController.updateServicio)
);

/**
 * @swagger
 * /api/servicios/{id}:
 *   delete:
 *     summary: Delete service
 *     tags: [Servicios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Service deleted
 */
router.delete('/:id',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  servicioIdValidator,
  validateRequest,
  asyncHandler(servicioController.deleteServicio)
);

module.exports = router;
