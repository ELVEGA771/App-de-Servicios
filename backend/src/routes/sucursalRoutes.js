const express = require('express');
const router = express.Router();
const sucursalController = require('../controllers/sucursalController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const validateRequest = require('../middleware/validator');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');
const {
  createSucursalValidator,
  updateSucursalValidator,
  sucursalIdValidator
} = require('../validators/sucursalValidator');

/**
 * @swagger
 * tags:
 *   name: Sucursales
 *   description: Branch/location management
 */

/**
 * @swagger
 * /api/sucursales/active:
 *   get:
 *     summary: Get active sucursales for authenticated empresa
 *     tags: [Sucursales]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Active sucursales retrieved successfully
 */
router.get('/active',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  asyncHandler(sucursalController.getActiveSucursales)
);

/**
 * @swagger
 * /api/sucursales:
 *   get:
 *     summary: Get all sucursales for authenticated empresa
 *     tags: [Sucursales]
 *     security:
 *       - bearerAuth: []
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
 *         description: Sucursales retrieved successfully
 */
router.get('/',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  asyncHandler(sucursalController.getAllSucursales)
);

/**
 * @swagger
 * /api/sucursales:
 *   post:
 *     summary: Create new sucursal with direccion (empresa only)
 *     tags: [Sucursales]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nombre_sucursal
 *               - calle_principal
 *               - ciudad
 *               - provincia_estado
 *     responses:
 *       201:
 *         description: Sucursal created successfully
 */
router.post('/',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  createSucursalValidator,
  validateRequest,
  asyncHandler(sucursalController.createSucursal)
);

/**
 * @swagger
 * /api/sucursales/{id}:
 *   get:
 *     summary: Get sucursal by ID with direccion details
 *     tags: [Sucursales]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Sucursal details retrieved
 */
router.get('/:id',
  sucursalIdValidator,
  validateRequest,
  asyncHandler(sucursalController.getSucursalById)
);

/**
 * @swagger
 * /api/sucursales/{id}:
 *   put:
 *     summary: Update sucursal and direccion (empresa owner only)
 *     tags: [Sucursales]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Sucursal updated successfully
 */
router.put('/:id',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  sucursalIdValidator,
  updateSucursalValidator,
  validateRequest,
  asyncHandler(sucursalController.updateSucursal)
);

/**
 * @swagger
 * /api/sucursales/{id}:
 *   delete:
 *     summary: Delete sucursal (set to inactive) (empresa owner only)
 *     tags: [Sucursales]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Sucursal deleted successfully
 */
router.delete('/:id',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  sucursalIdValidator,
  validateRequest,
  asyncHandler(sucursalController.deleteSucursal)
);

/**
 * @swagger
 * /api/sucursales/{id}/reactivate:
 *   patch:
 *     summary: Reactivate sucursal (set to active) (empresa owner only)
 *     tags: [Sucursales]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Sucursal reactivated successfully
 */
router.patch('/:id/reactivate',
  authMiddleware,
  roleMiddleware(USER_TYPES.COMPANY),
  sucursalIdValidator,
  validateRequest,
  asyncHandler(sucursalController.reactivateSucursal)
);

/**
 * @swagger
 * /api/sucursales/{id}/servicios:
 *   get:
 *     summary: Get all servicios for a sucursal
 *     tags: [Sucursales]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Servicios retrieved successfully
 */
router.get('/:id/servicios',
  sucursalIdValidator,
  validateRequest,
  asyncHandler(sucursalController.getSucursalServicios)
);

module.exports = router;
