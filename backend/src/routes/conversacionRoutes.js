const express = require('express');
const router = express.Router();
const conversacionController = require('../controllers/conversacionController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * @swagger
 * tags:
 *   name: Conversaciones
 *   description: Chat and messaging
 */

router.use(authMiddleware);

/**
 * @swagger
 * /api/conversaciones:
 *   get:
 *     summary: Get my conversations
 *     tags: [Conversaciones]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of conversations
 */
router.get('/', asyncHandler(conversacionController.getConversaciones));

/**
 * @swagger
 * /api/conversaciones/{id}:
 *   get:
 *     summary: Get conversation with messages
 *     tags: [Conversaciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
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
 *         description: Conversation with messages
 */
router.get('/:id', asyncHandler(conversacionController.getConversacionById));

/**
 * @swagger
 * /api/conversaciones/{id}/mensajes:
 *   post:
 *     summary: Send message in conversation
 *     tags: [Conversaciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - contenido
 *             properties:
 *               contenido:
 *                 type: string
 *               tipo_mensaje:
 *                 type: string
 *                 enum: [texto, imagen, archivo, audio]
 *     responses:
 *       201:
 *         description: Message sent
 */
router.post('/:id/mensajes', asyncHandler(conversacionController.sendMensaje));

/**
 * @swagger
 * /api/conversaciones/{id}/leer:
 *   put:
 *     summary: Mark messages as read
 *     tags: [Conversaciones]
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
 *         description: Messages marked as read
 */
router.put('/:id/leer', asyncHandler(conversacionController.markAsRead));

module.exports = router;
