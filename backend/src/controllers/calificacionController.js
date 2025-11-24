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
