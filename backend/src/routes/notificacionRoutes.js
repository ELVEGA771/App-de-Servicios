const express = require('express');
const router = express.Router();
const notificacionController = require('../controllers/notificacionController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * @swagger
 * tags:
 *   name: Notificaciones
 *   description: User notifications
 */

router.use(authMiddleware);

/**
 * @swagger
 * /api/notificaciones:
 *   get:
 *     summary: Get my notifications
 *     tags: [Notificaciones]
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
 *       - in: query
 *         name: unread
 *         schema:
 *           type: boolean
 *         description: Filter unread notifications
 *     responses:
 *       200:
 *         description: List of notifications
 */
router.get('/', asyncHandler(notificacionController.getNotificaciones));

/**
 * @swagger
 * /api/notificaciones/no-leidas/count:
 *   get:
 *     summary: Get count of unread notifications
 *     tags: [Notificaciones]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Count of unread notifications
 */
router.get('/no-leidas/count', asyncHandler(notificacionController.getUnreadCount));

/**
 * @swagger
 * /api/notificaciones/{id}/leer:
 *   put:
 *     summary: Mark notification as read
 *     tags: [Notificaciones]
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
 *         description: Notification marked as read
 */
router.put('/:id/leer', asyncHandler(notificacionController.markAsRead));

/**
 * @swagger
 * /api/notificaciones/{id}/toggle:
 *   put:
 *     summary: Toggle notification read status
 *     tags: [Notificaciones]
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
 *         description: Notification read status toggled
 */
router.put('/:id/toggle', asyncHandler(notificacionController.toggleRead));

/**
 * @swagger
 * /api/notificaciones/leer-todas:
 *   put:
 *     summary: Mark all notifications as read
 *     tags: [Notificaciones]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: All notifications marked as read
 */
router.put('/leer-todas', asyncHandler(notificacionController.markAllAsRead));

module.exports = router;
