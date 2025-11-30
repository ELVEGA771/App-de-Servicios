const express = require('express');
const router = express.Router();
const clienteController = require('../controllers/clienteController');
const { asyncHandler } = require('../middleware/errorHandler');
const { authenticateToken, authorize } = require('../middleware/authMiddleware');
const { USER_TYPES } = require('../utils/constants');

/**
 * @swagger
 * tags:
 *   name: Clientes
 *   description: Client management
 */

/**
 * @swagger
 * /api/clientes:
 *   get:
 *     summary: Get all clients
 *     tags: [Clientes]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of clients
 */
router.get('/', authenticateToken, authorize([USER_TYPES.ADMIN]), asyncHandler(clienteController.getAllClientes));

/**
 * @swagger
 * /api/clientes/{id}:
 *   get:
 *     summary: Get client details
 *     tags: [Clientes]
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
 *         description: Client details
 */
router.get('/:id', authenticateToken, authorize([USER_TYPES.ADMIN]), asyncHandler(clienteController.getClienteById));

module.exports = router;
