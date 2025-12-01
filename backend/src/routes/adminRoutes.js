const express = require('express');
const router = express.Router();
const { authenticateToken, authorize } = require('../middleware/authMiddleware');
const { USER_TYPES } = require('../utils/constants');
const { 
  getVistaContrataciones, 
  getVistaEstadisticasEmpresa, 
  getVistaServicios,
  getVistaSucursales,
  getVistaTopClientes
} = require('../controllers/adminVistasController');

// All routes require admin privileges
router.use(authenticateToken);
router.use(authorize([USER_TYPES.ADMIN]));

router.get('/vistas/contrataciones', getVistaContrataciones);
router.get('/vistas/estadisticas-empresas', getVistaEstadisticasEmpresa);
router.get('/vistas/servicios', getVistaServicios);
router.get('/vistas/sucursales', getVistaSucursales);
router.get('/vistas/top-clientes', getVistaTopClientes);

module.exports = router;
