const express = require('express');
const router = express.Router();
const cuponController = require('../controllers/cuponController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');

/**
 * @swagger
 * tags:
 *   name: Cupones
 *   description: Coupon management
 */

/**
 * @swagger
 * /api/cupones/activos:
 *   get:
 *     summary: Get active coupons
 *     tags: [Cupones]
 *     responses:
 *       200:
 *         description: List of active coupons
 */
router.get('/activos', asyncHandler(cuponController.getActiveCupones));

/**
 * @swagger
 * /api/cupones/validar:
 *   post:
 *     summary: Validate a coupon
 *     tags: [Cupones]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - codigo
 *               - id_servicio
 *               - monto_compra
 *             properties:
 *               codigo:
 *                 type: string
 *               id_servicio:
 *                 type: integer
 *               monto_compra:
 *                 type: number
 *     responses:
 *       200:
 *         description: Coupon validation result
 */
router.post('/validar', asyncHandler(cuponController.validateCupon));

router.use(authMiddleware);

/**
 * @swagger
 * /api/cupones:
 *   get:
 *     summary: Get my company coupons (empresa only)
 *     tags: [Cupones]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of company coupons
 */
router.get('/', roleMiddleware(USER_TYPES.COMPANY), asyncHandler(cuponController.getCuponesByEmpresa));

/**
 * @swagger
 * /api/cupones:
 *   post:
 *     summary: Create new coupon (empresa only)
 *     tags: [Cupones]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - codigo
 *               - tipo_descuento
 *               - valor_descuento
 *             properties:
 *               codigo:
 *                 type: string
 *               tipo_descuento:
 *                 type: string
 *                 enum: [porcentaje, monto_fijo]
 *               valor_descuento:
 *                 type: number
 *               monto_minimo_compra:
 *                 type: number
 *               cantidad_disponible:
 *                 type: integer
 *               fecha_expiracion:
 *                 type: string
 *                 format: date-time
 *     responses:
 *       201:
 *         description: Coupon created
 */
router.post('/', roleMiddleware(USER_TYPES.COMPANY), asyncHandler(cuponController.createCupon));

/**
 * @swagger
 * /api/cupones/{id}:
 *   put:
 *     summary: Update coupon (empresa only)
 *     tags: [Cupones]
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
 *         description: Coupon updated
 */
router.put('/:id', authMiddleware, roleMiddleware(USER_TYPES.COMPANY), asyncHandler(cuponController.updateCupon));

router.delete('/:id', authMiddleware, roleMiddleware(USER_TYPES.COMPANY), asyncHandler(cuponController.deleteCupon));

module.exports = router;
