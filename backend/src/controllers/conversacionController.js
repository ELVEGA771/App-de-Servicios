const Conversacion = require('../models/Conversacion');
const Mensaje = require('../models/Mensaje');
const { sendSuccess, sendPaginated, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

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

const getMensajes = async (req, res, next) => {
  try {
    const { page = 1, limit = 50 } = req.query;
    const mensajes = await Conversacion.getMensajes(req.params.id, page, limit);
    sendSuccess(res, mensajes.data);
  } catch (error) { next(error); }
};

const sendMensaje = async (req, res, next) => {
  try {
    const { id } = req.params;
    const mensajeData = { ...req.body, id_conversacion: id, id_remitente: req.user.id_usuario };
    const mensajeId = await Mensaje.create(mensajeData);
    
    const fullMensaje = await Mensaje.findById(mensajeId);
    
    sendSuccess(res, fullMensaje, 'Message sent', 201);
  } catch (error) { next(error); }
};

const markAsRead = async (req, res, next) => {
  try {
    await Conversacion.markAsRead(req.params.id, req.user.id_usuario);
    sendSuccess(res, null, 'Messages marked as read');
  } catch (error) { next(error); }
};

const getOrCreateByContratacion = async (req, res, next) => {
  try {
    const { id } = req.params; // id_contratacion

    // 1. Check if conversation exists
    let conversacion = await Conversacion.findByContratacionId(id);

    if (conversacion) {
      return sendSuccess(res, conversacion);
    }

    // 2. If not, create it
    const { executeQuery } = require('../config/database');
    const [contratacion] = await executeQuery(
      `SELECT c.id_cliente, s.id_empresa 
       FROM contratacion c
       JOIN servicio s ON c.id_servicio = s.id_servicio
       WHERE c.id_contratacion = ?`,
      [id]
    );

    if (!contratacion) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Contratacion not found', HTTP_STATUS.NOT_FOUND);
    }

    const newConversacionId = await Conversacion.create({
      id_cliente: contratacion.id_cliente,
      id_empresa: contratacion.id_empresa,
      id_contratacion: id,
      estado: 'abierta'
    });

    conversacion = await Conversacion.findById(newConversacionId);
    sendSuccess(res, conversacion, 'Conversation created', 201);

  } catch (error) { next(error); }
};

module.exports = { getConversaciones, getConversacionById, getMensajes, sendMensaje, markAsRead, getOrCreateByContratacion };
