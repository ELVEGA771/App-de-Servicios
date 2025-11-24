const Servicio = require('../models/Servicio');
const Empresa = require('../models/Empresa');
const { sendSuccess, sendPaginated, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES } = require('../utils/constants');
const logger = require('../utils/logger');

/**
 * Get all servicios with filters
 * GET /api/servicios
 */
const getAllServicios = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, ...filters } = req.query;
    const result = await Servicio.getAll(parseInt(page), parseInt(limit), filters);

    sendPaginated(
      res,
      result.data,
      page,
      limit,
      result.total,
      'Servicios retrieved successfully'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get servicio by ID
 * GET /api/servicios/:id
 */
const getServicioById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const servicio = await Servicio.findById(id);

    if (!servicio) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Service not found', HTTP_STATUS.NOT_FOUND);
    }

    // Get sucursales
    const sucursales = await Servicio.getSucursales(id);

    sendSuccess(res, { ...servicio, sucursales });
  } catch (error) {
    next(error);
  }
};

/**
 * Get servicios by empresa
 * GET /api/servicios/empresa/:id
 */
const getServiciosByEmpresa = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;

    const result = await Servicio.getByEmpresa(id, parseInt(page), parseInt(limit));

    sendPaginated(
      res,
      result.data,
      page,
      limit,
      result.total,
      'Servicios retrieved successfully'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get my servicios (empresa only)
 * GET /api/servicios/mis-servicios
 */
const getMisServicios = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can access this endpoint', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    const { page = 1, limit = 20 } = req.query;
    const result = await Servicio.getByEmpresa(empresa.id_empresa, parseInt(page), parseInt(limit));

    sendPaginated(
      res,
      result.data,
      page,
      limit,
      result.total,
      'Your services retrieved successfully'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Create new servicio (empresa only)
 * POST /api/servicios
 */
const createServicio = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can create services', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    const servicioData = {
      ...req.body,
      id_empresa: empresa.id_empresa
    };

    const servicioId = await Servicio.create(servicioData);
    const servicio = await Servicio.findByIdRaw(servicioId);

    logger.info(`Service created: ${servicio.nombre} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, servicio, 'Service created successfully', HTTP_STATUS.CREATED);
  } catch (error) {
    next(error);
  }
};

/**
 * Update servicio (empresa owner only)
 * PUT /api/servicios/:id
 */
const updateServicio = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can update services', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Check if servicio exists and belongs to empresa
    const servicio = await Servicio.findById(id);
    if (!servicio) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Service not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify ownership (need to get id_empresa from raw servicio table)
    const { executeQuery } = require('../config/database');
    const [rawServicio] = await executeQuery('SELECT id_empresa FROM servicio WHERE id_servicio = ?', [id]);

    if (!rawServicio || rawServicio.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You can only update your own services', HTTP_STATUS.FORBIDDEN);
    }

    const updatedServicio = await Servicio.update(id, req.body);
    logger.info(`Service updated: ${id} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, updatedServicio, 'Service updated successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Delete servicio (empresa owner only)
 * DELETE /api/servicios/:id
 */
const deleteServicio = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can delete services', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify ownership
    const { executeQuery } = require('../config/database');
    const [rawServicio] = await executeQuery('SELECT id_empresa FROM servicio WHERE id_servicio = ?', [id]);

    if (!rawServicio) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Service not found', HTTP_STATUS.NOT_FOUND);
    }

    if (rawServicio.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You can only delete your own services', HTTP_STATUS.FORBIDDEN);
    }

    await Servicio.delete(id);
    logger.info(`Service deleted: ${id} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, null, 'Service deleted successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Associate servicio with sucursal
 * POST /api/servicios/:id/sucursales
 */
const addServicioToSucursal = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { id_sucursal, precio_sucursal } = req.body;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can manage service locations', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify servicio ownership
    const { executeQuery } = require('../config/database');
    const [rawServicio] = await executeQuery('SELECT id_empresa FROM servicio WHERE id_servicio = ?', [id]);

    if (!rawServicio || rawServicio.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You can only manage your own services', HTTP_STATUS.FORBIDDEN);
    }

    await Servicio.addToSucursal(id, id_sucursal, precio_sucursal || null);
    sendSuccess(res, null, 'Service added to sucursal successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Search servicios
 * GET /api/servicios/buscar
 */
const searchServicios = async (req, res, next) => {
  try {
    const { q, page = 1, limit = 20, ...filters } = req.query;

    const searchFilters = {
      ...filters,
      busqueda: q
    };

    const result = await Servicio.getAll(parseInt(page), parseInt(limit), searchFilters);

    sendPaginated(
      res,
      result.data,
      page,
      limit,
      result.total,
      'Search results retrieved successfully'
    );
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllServicios,
  getServicioById,
  getServiciosByEmpresa,
  getMisServicios,
  createServicio,
  updateServicio,
  deleteServicio,
  addServicioToSucursal,
  searchServicios
};
