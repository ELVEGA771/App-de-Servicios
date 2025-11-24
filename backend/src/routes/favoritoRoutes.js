const express = require('express');
const router = express.Router();
const favoritoController = require('../controllers/favoritoController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');

/**
 * @swagger
 * tags:
 *   name: Favoritos
 *   description: Favorite services (cliente only)
 */

router.use(authMiddleware, roleMiddleware(USER_TYPES.CLIENT));

/**
 * @swagger
 * /api/favoritos:
 *   get:
 *     summary: Get my favorite services
 *     tags: [Favoritos]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of favorite services
 */
router.get('/', asyncHandler(favoritoController.getFavoritos));

/**
 * @swagger
 * /api/favoritos:
 *   post:
 *     summary: Add service to favorites
 *     tags: [Favoritos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - id_servicio
 *             properties:
 *               id_servicio:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Added to favorites
 */
router.post('/', asyncHandler(favoritoController.addFavorito));

/**
 * @swagger
 * /api/favoritos/{id}:
 *   delete:
 *     summary: Remove service from favorites
 *     tags: [Favoritos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Service ID
 *     responses:
 *       200:
 *         description: Removed from favorites
 */
router.delete('/:id', asyncHandler(favoritoController.removeFavorito));

module.exports = router;
