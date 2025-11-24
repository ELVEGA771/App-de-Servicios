const express = require('express');
const router = express.Router();
const direccionController = require('../controllers/direccionController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');

/**
 * @swagger
 * tags:
 *   name: Direcciones
 *   description: Address management (cliente only)
 */

router.use(authMiddleware, roleMiddleware(USER_TYPES.CLIENT));

/**
 * @swagger
 * /api/direcciones:
 *   get:
 *     summary: Get my addresses
 *     tags: [Direcciones]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of addresses
 */
router.get('/', asyncHandler(direccionController.getDirecciones));

/**
 * @swagger
 * /api/direcciones:
 *   post:
 *     summary: Create new address
 *     tags: [Direcciones]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - calle_principal
 *               - ciudad
 *               - provincia_estado
 *             properties:
 *               calle_principal:
 *                 type: string
 *               calle_secundaria:
 *                 type: string
 *               numero:
 *                 type: string
 *               ciudad:
 *                 type: string
 *               provincia_estado:
 *                 type: string
 *               codigo_postal:
 *                 type: string
 *               pais:
 *                 type: string
 *               alias:
 *                 type: string
 *               es_principal:
 *                 type: boolean
 *     responses:
 *       201:
 *         description: Address created
 */
router.post('/', asyncHandler(direccionController.createDireccion));

/**
 * @swagger
 * /api/direcciones/{id}:
 *   put:
 *     summary: Update address
 *     tags: [Direcciones]
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
 *         description: Address updated
 */
router.put('/:id', asyncHandler(direccionController.updateDireccion));

/**
 * @swagger
 * /api/direcciones/{id}:
 *   delete:
 *     summary: Delete address
 *     tags: [Direcciones]
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
 *         description: Address deleted
 */
router.delete('/:id', asyncHandler(direccionController.deleteDireccion));

/**
 * @swagger
 * /api/direcciones/{id}/principal:
 *   put:
 *     summary: Set address as principal
 *     tags: [Direcciones]
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
 *         description: Principal address updated
 */
router.put('/:id/principal', asyncHandler(direccionController.setPrincipal));

module.exports = router;
