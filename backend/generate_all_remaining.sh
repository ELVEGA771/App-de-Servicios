#!/bin/bash

echo "🚀 Generating all remaining controllers and routes..."

# ========== FAVORITO ==========
cat > src/controllers/favoritoController.js << 'EOF'
const Favorito = require('../models/Favorito');
const Cliente = require('../models/Cliente');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

const getFavoritos = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const favoritos = await Favorito.getByCliente(cliente.id_cliente);
    sendSuccess(res, favoritos);
  } catch (error) { next(error); }
};

const addFavorito = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const { id_servicio } = req.body;
    await Favorito.add(cliente.id_cliente, id_servicio);
    sendSuccess(res, null, 'Added to favorites', 201);
  } catch (error) { next(error); }
};

const removeFavorito = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const { id } = req.params;
    await Favorito.remove(cliente.id_cliente, id);
    sendSuccess(res, null, 'Removed from favorites');
  } catch (error) { next(error); }
};

module.exports = { getFavoritos, addFavorito, removeFavorito };
EOF

cat > src/routes/favoritoRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const favoritoController = require('../controllers/favoritoController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');

router.use(authMiddleware, roleMiddleware(USER_TYPES.CLIENT));
router.get('/', asyncHandler(favoritoController.getFavoritos));
router.post('/', asyncHandler(favoritoController.addFavorito));
router.delete('/:id', asyncHandler(favoritoController.removeFavorito));

module.exports = router;
EOF

# ========== CALIFICACION ==========
cat > src/controllers/calificacionController.js << 'EOF'
const Calificacion = require('../models/Calificacion');
const Contratacion = require('../models/Contratacion');
const { sendSuccess, sendPaginated, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

const createCalificacion = async (req, res, next) => {
  try {
    const { id_contratacion, calificacion, comentario } = req.body;
    const canRate = await Contratacion.canBeRated(id_contratacion);
    if (!canRate) {
      return sendError(res, ERROR_CODES.VALIDATION_ERROR, 'Contratacion must be completed to rate', HTTP_STATUS.BAD_REQUEST);
    }
    const participated = await Contratacion.userParticipated(id_contratacion, req.user.id_usuario, req.user.tipo_usuario);
    if (!participated) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Unauthorized', HTTP_STATUS.FORBIDDEN);
    }
    const tipo = req.user.tipo_usuario === 'cliente' ? 'cliente_a_empresa' : 'empresa_a_cliente';
    const alreadyRated = await Calificacion.isAlreadyRated(id_contratacion, tipo);
    if (alreadyRated) {
      return sendError(res, ERROR_CODES.VALIDATION_ERROR, 'Already rated', HTTP_STATUS.BAD_REQUEST);
    }
    const id = await Calificacion.create({ id_contratacion, calificacion, comentario, tipo });
    sendSuccess(res, { id_calificacion: id }, 'Rating created', 201);
  } catch (error) { next(error); }
};

const getCalificacionesByServicio = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const result = await Calificacion.getByServicio(id, page, limit);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

module.exports = { createCalificacion, getCalificacionesByServicio };
EOF

cat > src/routes/calificacionRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const calificacionController = require('../controllers/calificacionController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

router.get('/servicio/:id', asyncHandler(calificacionController.getCalificacionesByServicio));
router.post('/', authMiddleware, asyncHandler(calificacionController.createCalificacion));

module.exports = router;
EOF

# ========== CATEGORIA ==========
cat > src/controllers/categoriaController.js << 'EOF'
const Categoria = require('../models/Categoria');
const { sendSuccess } = require('../utils/responseFormatter');

const getAllCategorias = async (req, res, next) => {
  try {
    const categorias = await Categoria.getAll();
    sendSuccess(res, categorias);
  } catch (error) { next(error); }
};

const getCategoriaById = async (req, res, next) => {
  try {
    const categoria = await Categoria.findById(req.params.id);
    sendSuccess(res, categoria);
  } catch (error) { next(error); }
};

module.exports = { getAllCategorias, getCategoriaById };
EOF

cat > src/routes/categoriaRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const categoriaController = require('../controllers/categoriaController');
const { asyncHandler } = require('../middleware/errorHandler');

router.get('/', asyncHandler(categoriaController.getAllCategorias));
router.get('/:id', asyncHandler(categoriaController.getCategoriaById));

module.exports = router;
EOF

# ========== EMPRESA ==========
cat > src/controllers/empresaController.js << 'EOF'
const Empresa = require('../models/Empresa');
const { sendSuccess, sendPaginated } = require('../utils/responseFormatter');

const getAllEmpresas = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, ...filters } = req.query;
    const result = await Empresa.getAll(page, limit, filters);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

const getEmpresaById = async (req, res, next) => {
  try {
    const empresa = await Empresa.findById(req.params.id);
    sendSuccess(res, empresa);
  } catch (error) { next(error); }
};

const getEmpresaStats = async (req, res, next) => {
  try {
    const stats = await Empresa.getStatistics(req.params.id);
    sendSuccess(res, stats);
  } catch (error) { next(error); }
};

module.exports = { getAllEmpresas, getEmpresaById, getEmpresaStats };
EOF

cat > src/routes/empresaRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const empresaController = require('../controllers/empresaController');
const { asyncHandler } = require('../middleware/errorHandler');

router.get('/', asyncHandler(empresaController.getAllEmpresas));
router.get('/:id', asyncHandler(empresaController.getEmpresaById));
router.get('/:id/estadisticas', asyncHandler(empresaController.getEmpresaStats));

module.exports = router;
EOF

# ========== DIRECCION ==========
cat > src/controllers/direccionController.js << 'EOF'
const Direccion = require('../models/Direccion');
const Cliente = require('../models/Cliente');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES } = require('../utils/constants');

const getDirecciones = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const direcciones = await Cliente.getAddresses(cliente.id_cliente);
    sendSuccess(res, direcciones);
  } catch (error) { next(error); }
};

const createDireccion = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const dirId = await Direccion.create(req.body);
    await Cliente.addAddress(cliente.id_cliente, dirId, req.body.alias, req.body.es_principal);
    const dir = await Direccion.findById(dirId);
    sendSuccess(res, dir, 'Address created', 201);
  } catch (error) { next(error); }
};

const updateDireccion = async (req, res, next) => {
  try {
    const updated = await Direccion.update(req.params.id, req.body);
    sendSuccess(res, updated);
  } catch (error) { next(error); }
};

const deleteDireccion = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    await Cliente.removeAddress(cliente.id_cliente, req.params.id);
    sendSuccess(res, null, 'Address deleted');
  } catch (error) { next(error); }
};

const setPrincipal = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    await Cliente.setPrincipalAddress(cliente.id_cliente, req.params.id);
    sendSuccess(res, null, 'Principal address updated');
  } catch (error) { next(error); }
};

module.exports = { getDirecciones, createDireccion, updateDireccion, deleteDireccion, setPrincipal };
EOF

cat > src/routes/direccionRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const direccionController = require('../controllers/direccionController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');
const { USER_TYPES } = require('../utils/constants');

router.use(authMiddleware, roleMiddleware(USER_TYPES.CLIENT));
router.get('/', asyncHandler(direccionController.getDirecciones));
router.post('/', asyncHandler(direccionController.createDireccion));
router.put('/:id', asyncHandler(direccionController.updateDireccion));
router.delete('/:id', asyncHandler(direccionController.deleteDireccion));
router.put('/:id/principal', asyncHandler(direccionController.setPrincipal));

module.exports = router;
EOF

# ========== CONVERSACION ==========
cat > src/controllers/conversacionController.js << 'EOF'
const Conversacion = require('../models/Conversacion');
const Mensaje = require('../models/Mensaje');
const { sendSuccess, sendPaginated } = require('../utils/responseFormatter');

const getConversaciones = async (req, res, next) => {
  try {
    const conversaciones = await Conversacion.getByUser(req.user.id_usuario, req.user.tipo_usuario);
    sendSuccess(res, conversaciones);
  } catch (error) { next(error); }
};

const getConversacionById = async (req, res, next) => {
  try {
    const { page = 1, limit = 50 } = req.query;
    const conversacion = await Conversacion.findById(req.params.id);
    const mensajes = await Conversacion.getMensajes(req.params.id, page, limit);
    sendSuccess(res, { ...conversacion, mensajes: mensajes.data });
  } catch (error) { next(error); }
};

const sendMensaje = async (req, res, next) => {
  try {
    const { id } = req.params;
    const mensajeData = { ...req.body, id_conversacion: id, id_remitente: req.user.id_usuario };
    const mensajeId = await Mensaje.create(mensajeData);
    sendSuccess(res, { id_mensaje: mensajeId }, 'Message sent', 201);
  } catch (error) { next(error); }
};

const markAsRead = async (req, res, next) => {
  try {
    await Conversacion.markAsRead(req.params.id, req.user.id_usuario);
    sendSuccess(res, null, 'Messages marked as read');
  } catch (error) { next(error); }
};

module.exports = { getConversaciones, getConversacionById, sendMensaje, markAsRead };
EOF

cat > src/routes/conversacionRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const conversacionController = require('../controllers/conversacionController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

router.use(authMiddleware);
router.get('/', asyncHandler(conversacionController.getConversaciones));
router.get('/:id', asyncHandler(conversacionController.getConversacionById));
router.post('/:id/mensajes', asyncHandler(conversacionController.sendMensaje));
router.put('/:id/leer', asyncHandler(conversacionController.markAsRead));

module.exports = router;
EOF

# ========== NOTIFICACION ==========
cat > src/controllers/notificacionController.js << 'EOF'
const Notificacion = require('../models/Notificacion');
const { sendSuccess, sendPaginated } = require('../utils/responseFormatter');

const getNotificaciones = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, unread } = req.query;
    const result = await Notificacion.getByUser(req.user.id_usuario, unread === 'true', page, limit);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

const markAsRead = async (req, res, next) => {
  try {
    await Notificacion.markAsRead(req.params.id);
    sendSuccess(res, null, 'Notification marked as read');
  } catch (error) { next(error); }
};

const markAllAsRead = async (req, res, next) => {
  try {
    await Notificacion.markAllAsRead(req.user.id_usuario);
    sendSuccess(res, null, 'All notifications marked as read');
  } catch (error) { next(error); }
};

module.exports = { getNotificaciones, markAsRead, markAllAsRead };
EOF

cat > src/routes/notificacionRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const notificacionController = require('../controllers/notificacionController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

router.use(authMiddleware);
router.get('/', asyncHandler(notificacionController.getNotificaciones));
router.put('/:id/leer', asyncHandler(notificacionController.markAsRead));
router.put('/leer-todas', asyncHandler(notificacionController.markAllAsRead));

module.exports = router;
EOF

echo "✅ All controllers and routes created!"
