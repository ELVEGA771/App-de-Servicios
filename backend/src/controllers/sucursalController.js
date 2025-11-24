const Sucursal = require('../models/Sucursal');
const Empresa = require('../models/Empresa');
const { sendSuccess, sendPaginated, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES } = require('../utils/constants');
const logger = require('../utils/logger');

/**
 * Get all sucursales for the authenticated empresa
 * GET /api/sucursales
 */
const getAllSucursales = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can access this endpoint', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    const { page = 1, limit = 20 } = req.query;
    const result = await Sucursal.getByEmpresa(empresa.id_empresa, parseInt(page), parseInt(limit));

    sendPaginated(
      res,
      result.data,
      page,
      limit,
      result.total,
      'Sucursales retrieved successfully'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get only active sucursales for the authenticated empresa
 * GET /api/sucursales/active
 */
const getActiveSucursales = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can access this endpoint', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    const sucursales = await Sucursal.getActiveSucursalesByEmpresa(empresa.id_empresa);
    sendSuccess(res, sucursales, 'Active sucursales retrieved successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Get sucursal by ID with direccion details
 * GET /api/sucursales/:id
 */
const getSucursalById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const sucursal = await Sucursal.findById(id);

    if (!sucursal) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Sucursal not found', HTTP_STATUS.NOT_FOUND);
    }

    sendSuccess(res, sucursal);
  } catch (error) {
    next(error);
  }
};

/**
 * Create new sucursal with direccion (empresa only)
 * POST /api/sucursales
 */
const createSucursal = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can create sucursales', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    const sucursalData = {
      ...req.body,
      id_empresa: empresa.id_empresa
    };

    const sucursalId = await Sucursal.create(sucursalData);
    const sucursal = await Sucursal.findById(sucursalId);

    logger.info(`Sucursal created: ${sucursal.nombre_sucursal} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, sucursal, 'Sucursal created successfully', HTTP_STATUS.CREATED);
  } catch (error) {
    next(error);
  }
};

/**
 * Update sucursal and direccion (empresa owner only)
 * PUT /api/sucursales/:id
 */
const updateSucursal = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can update sucursales', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Check if sucursal exists and belongs to empresa
    const { executeQuery } = require('../config/database');
    const [rawSucursal] = await executeQuery('SELECT id_empresa FROM sucursal WHERE id_sucursal = ?', [id]);

    if (!rawSucursal) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Sucursal not found', HTTP_STATUS.NOT_FOUND);
    }

    if (rawSucursal.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You can only update your own sucursales', HTTP_STATUS.FORBIDDEN);
    }

    await Sucursal.update(id, req.body);
    const updatedSucursal = await Sucursal.findById(id);

    logger.info(`Sucursal updated: ${id} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, updatedSucursal, 'Sucursal updated successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Delete sucursal (set to inactive) (empresa owner only)
 * DELETE /api/sucursales/:id
 */
const deleteSucursal = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can delete sucursales', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify ownership
    const { executeQuery } = require('../config/database');
    const [rawSucursal] = await executeQuery('SELECT id_empresa FROM sucursal WHERE id_sucursal = ?', [id]);

    if (!rawSucursal) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Sucursal not found', HTTP_STATUS.NOT_FOUND);
    }

    if (rawSucursal.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You can only delete your own sucursales', HTTP_STATUS.FORBIDDEN);
    }

    await Sucursal.delete(id);
    logger.info(`Sucursal deleted (set to inactive): ${id} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, null, 'Sucursal deleted successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Reactivate sucursal (set to active) (empresa owner only)
 * PATCH /api/sucursales/:id/reactivate
 */
const reactivateSucursal = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can reactivate sucursales', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify ownership
    const { executeQuery } = require('../config/database');
    const [rawSucursal] = await executeQuery('SELECT id_empresa FROM sucursal WHERE id_sucursal = ?', [id]);

    if (!rawSucursal) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Sucursal not found', HTTP_STATUS.NOT_FOUND);
    }

    if (rawSucursal.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You can only reactivate your own sucursales', HTTP_STATUS.FORBIDDEN);
    }

    await Sucursal.reactivate(id);
    logger.info(`Sucursal reactivated: ${id} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, null, 'Sucursal reactivated successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Get all servicios for a sucursal
 * GET /api/sucursales/:id/servicios
 */
const getSucursalServicios = async (req, res, next) => {
  try {
    const { id } = req.params;

    // Check if sucursal exists
    const sucursal = await Sucursal.findById(id);
    if (!sucursal) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Sucursal not found', HTTP_STATUS.NOT_FOUND);
    }

    const servicios = await Sucursal.getServicios(id);
    sendSuccess(res, servicios, 'Servicios retrieved successfully');
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllSucursales,
  getActiveSucursales,
  getSucursalById,
  createSucursal,
  updateSucursal,
  deleteSucursal,
  reactivateSucursal,
  getSucursalServicios
};
