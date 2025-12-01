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
    
    // Only clients can rate
    if (req.user.tipo_usuario !== 'cliente') {
       return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only clients can rate services', HTTP_STATUS.FORBIDDEN);
    }

    const alreadyRated = await Calificacion.isAlreadyRated(id_contratacion);
    if (alreadyRated) {
      return sendError(res, ERROR_CODES.VALIDATION_ERROR, 'Already rated', HTTP_STATUS.BAD_REQUEST);
    }
    
    await Calificacion.create({ 
      id_contratacion, 
      calificacion, 
      comentario
    });
    
    sendSuccess(res, { success: true }, 'Rating created', 201);
  } catch (error) { next(error); }
};

const getPendingCalificaciones = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== 'cliente') {
      return sendSuccess(res, []); // Only clients rate companies for now
    }
    console.log(`Checking pending ratings for user ${req.user.id_usuario}`);
    const pending = await Calificacion.getPendingByUsuario(req.user.id_usuario);
    console.log(`Found ${pending.length} pending ratings`);
    sendSuccess(res, pending);
  } catch (error) { 
    console.error('Error getting pending ratings:', error);
    next(error); 
  }
};

const getCalificacionesByServicio = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const result = await Calificacion.getByServicio(id, page, limit);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

module.exports = { createCalificacion, getCalificacionesByServicio, getPendingCalificaciones };
