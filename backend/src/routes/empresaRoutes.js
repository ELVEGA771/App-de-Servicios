const express = require('express');
const router = express.Router();
const empresaController = require('../controllers/empresaController');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * @swagger
 * tags:
 *   name: Empresas
 *   description: Company information
 */

/**
 * @swagger
 * /api/empresas:
 *   get:
 *     summary: Get all companies
 *     tags: [Empresas]
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
 *         name: search
 *         schema:
 *           type: string
 *       - in: query
 *         name: calificacion_min
 *         schema:
 *           type: number
 *     responses:
 *       200:
 *         description: List of companies
 */
router.get('/', asyncHandler(empresaController.getAllEmpresas));

/**
 * @swagger
 * /api/empresas/{id}:
 *   get:
 *     summary: Get company details
 *     tags: [Empresas]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Company details
 */
router.get('/:id', asyncHandler(empresaController.getEmpresaById));

/**
 * @swagger
 * /api/empresas/{id}/estadisticas:
 *   get:
 *     summary: Get company statistics
 *     tags: [Empresas]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Company statistics
 */
router.get('/:id/estadisticas', asyncHandler(empresaController.getEmpresaStats));

/**
 * @swagger
 * /api/empresas/{id}/ingresos-detalles:
 *   get:
 *     summary: Get detailed income report
 *     tags: [Empresas]
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
 *         description: List of completed transactions with details
 */
router.get('/:id/ingresos-detalles', asyncHandler(empresaController.getIncomeDetails));

module.exports = router;
