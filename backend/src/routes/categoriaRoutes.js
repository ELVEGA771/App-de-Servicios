const express = require('express');
const router = express.Router();
const categoriaController = require('../controllers/categoriaController');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * @swagger
 * tags:
 *   name: Categorias
 *   description: Service categories
 */

/**
 * @swagger
 * /api/categorias:
 *   get:
 *     summary: Get all categories
 *     tags: [Categorias]
 *     responses:
 *       200:
 *         description: List of categories
 */
router.get('/', asyncHandler(categoriaController.getAllCategorias));

/**
 * @swagger
 * /api/categorias/{id}:
 *   get:
 *     summary: Get category by ID
 *     tags: [Categorias]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Category details
 */
router.get('/:id', asyncHandler(categoriaController.getCategoriaById));

module.exports = router;
