#!/bin/bash

echo "🔧 Adding Swagger documentation to all routes..."

# ========== DIRECCION ==========
cat > src/routes/direccionRoutes.js << 'EOF'
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
EOF

# ========== FAVORITO ==========
cat > src/routes/favoritoRoutes.js << 'EOF'
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
EOF

# ========== CALIFICACION ==========
cat > src/routes/calificacionRoutes.js << 'EOF'
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
EOF

# ========== CATEGORIA ==========
cat > src/routes/categoriaRoutes.js << 'EOF'
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
EOF

# ========== EMPRESA ==========
cat > src/routes/empresaRoutes.js << 'EOF'
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

module.exports = router;
EOF

# ========== CONVERSACION ==========
cat > src/routes/conversacionRoutes.js << 'EOF'
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
EOF

# ========== NOTIFICACION ==========
cat > src/routes/notificacionRoutes.js << 'EOF'
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
EOF

echo "✅ Swagger documentation added to all routes!"
echo "🔄 Restart your server (npm run dev) to see all endpoints in Swagger"
