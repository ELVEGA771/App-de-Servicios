const Notificacion = require('../models/Notificacion');
const { sendSuccess, sendPaginated } = require('../utils/responseFormatter');

const getNotificaciones = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, unread } = req.query;
    const result = await Notificacion.getByUser(req.user.id_usuario, unread === 'true', page, limit);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

const getUnreadCount = async (req, res, next) => {
  try {
    const count = await Notificacion.getUnreadCount(req.user.id_usuario);
    sendSuccess(res, { count });
  } catch (error) { next(error); }
};

const markAsRead = async (req, res, next) => {
  try {
    await Notificacion.markAsRead(req.params.id);
    sendSuccess(res, null, 'Notification marked as read');
  } catch (error) { next(error); }
};

const toggleRead = async (req, res, next) => {
  try {
    const result = await Notificacion.toggleRead(req.params.id);
    if (!result) {
      return res.status(404).json({ success: false, message: 'Notification not found' });
    }
    sendSuccess(res, result, 'Notification read status toggled');
  } catch (error) { next(error); }
};

const markAllAsRead = async (req, res, next) => {
  try {
    await Notificacion.markAllAsRead(req.user.id_usuario);
    sendSuccess(res, null, 'All notifications marked as read');
  } catch (error) { next(error); }
};

module.exports = { getNotificaciones, getUnreadCount, markAsRead, toggleRead, markAllAsRead };
