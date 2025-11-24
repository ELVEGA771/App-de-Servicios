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
