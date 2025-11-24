const express = require('express');
const router = express.Router();
const calificacionController = require('../controllers/calificacionController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * @swagger
 * tags:
 *   name: Calificaciones
 *   description: Service ratings
 */

/**
 * @swagger
 * /api/calificaciones/servicio/{id}:
 *   get:
 *     summary: Get ratings for a service
 *     tags: [Calificaciones]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Service ID
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
 *         description: Service ratings
 */
router.get('/servicio/:id', asyncHandler(calificacionController.getCalificacionesByServicio));

/**
 * @swagger
 * /api/calificaciones:
 *   post:
 *     summary: Create a rating (requires completed contratacion)
 *     tags: [Calificaciones]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - id_contratacion
 *               - calificacion
 *             properties:
 *               id_contratacion:
 *                 type: integer
 *               calificacion:
 *                 type: integer
 *                 minimum: 1
 *                 maximum: 5
 *               comentario:
 *                 type: string
 *     responses:
 *       201:
 *         description: Rating created
 */
router.post('/', authMiddleware, asyncHandler(calificacionController.createCalificacion));

module.exports = router;
