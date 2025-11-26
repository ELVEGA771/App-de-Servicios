const express = require('express');
const router = express.Router();
const contratacionController = require('../controllers/contratacionController');
const authMiddleware = require('../middleware/authMiddleware');
const validateRequest = require('../middleware/validator');
const { asyncHandler } = require('../middleware/errorHandler');
const {
  createContratacionValidator,
  updateEstadoValidator,
  contratacionIdValidator,
  getContratacionesValidator
} = require('../validators/contratacionValidator');

/**
 * @swagger
 * tags:
 *   name: Contrataciones
 *   description: Service contract management
 */

router.use(authMiddleware); // All routes require authentication

/**
 * @swagger
 * /api/contrataciones:
 *   get:
 *     summary: Get user's contrataciones
 *     tags: [Contrataciones]
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
 *         name: estado
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Contrataciones retrieved
 */
router.get('/',
  getContratacionesValidator,
  validateRequest,
  asyncHandler(contratacionController.getContrataciones)
);

/**
 * @swagger
 * /api/contrataciones:
 *   post:
 *     summary: Create new contratacion (cliente only)
 *     tags: [Contrataciones]
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
 *               - id_sucursal
 *               - id_direccion_entrega
 *     responses:
 *       201:
 *         description: Contratacion created
 */
router.post('/',
  createContratacionValidator,
  validateRequest,
  asyncHandler(contratacionController.createContratacion)
);

/**
 * @swagger
 * /api/contrataciones/{id}:
 *   get:
 *     summary: Get contratacion details
 *     tags: [Contrataciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Contratacion details
 */
router.get('/:id',
  contratacionIdValidator,
  validateRequest,
  asyncHandler(contratacionController.getContratacionById)
);

/**
 * @swagger
 * /api/contrataciones/{id}/estado:
 *   put:
 *     summary: Update contratacion status (empresa only)
 *     tags: [Contrataciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - estado
 *     responses:
 *       200:
 *         description: Status updated
 */
router.put('/:id/estado',
  updateEstadoValidator,
  validateRequest,
  asyncHandler(contratacionController.updateEstado)
);

/**
 * @swagger
 * /api/contrataciones/{id}/cancelar:
 *   put:
 *     summary: Cancel contratacion
 *     tags: [Contrataciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Contratacion cancelled
 */
router.put('/:id/cancelar',
  contratacionIdValidator,
  validateRequest,
  asyncHandler(contratacionController.cancelContratacion)
);

/**
 * @swagger
 * /api/contrataciones/empresa/historial:
 *   get:
 *     summary: Get historial de contrataciones (empresa only)
 *     tags: [Contrataciones]
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
 *         description: Historial retrieved
 */
router.get('/empresa/historial',
  validateRequest,
  asyncHandler(contratacionController.getHistorialEmpresa)
);

module.exports = router;
