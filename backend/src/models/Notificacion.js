const { executeQuery } = require('../config/database');

class Notificacion {
  /**
   * Get notificaciones by user
   */
  static async getByUser(userId, unreadOnly = false, page = 1, limit = 20) {
    const offset = (page - 1) * limit;
    let query = 'SELECT * FROM notificacion WHERE id_usuario = ?';
    const params = [userId];

    if (unreadOnly) {
      query += ' AND leida = 0';
    }

    // Count total
    const countQuery = query.replace('SELECT *', 'SELECT COUNT(*) as total');
    const countResult = await executeQuery(countQuery, params);
    const total = countResult[0].total;

    query += ' ORDER BY fecha_creacion DESC LIMIT ? OFFSET ?';
    params.push(limit, offset);

    const results = await executeQuery(query, params);
    return { data: results, total };
  }

  /**
   * Create new notificacion
   */
  static async create(notificacionData) {
    const query = `
      INSERT INTO notificacion (id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    const params = [
      notificacionData.id_usuario,
      notificacionData.titulo,
      notificacionData.contenido || null,
      notificacionData.tipo,
      notificacionData.referencia_id || null,
      notificacionData.referencia_tipo || null
    ];
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Mark notificacion as read
   */
  static async markAsRead(id) {
    const query = 'UPDATE notificacion SET leida = 1, fecha_lectura = NOW() WHERE id_notificacion = ?';
    await executeQuery(query, [id]);
    return true;
  }

  /**
   * Mark all notificaciones as read for user
   */
  static async markAllAsRead(userId) {
    const query = 'UPDATE notificacion SET leida = 1, fecha_lectura = NOW() WHERE id_usuario = ? AND leida = 0';
    await executeQuery(query, [userId]);
    return true;
  }

  /**
   * Delete notificacion
   */
  static async delete(id) {
    const query = 'DELETE FROM notificacion WHERE id_notificacion = ?';
    await executeQuery(query, [id]);
    return true;
  }

  /**
   * Get unread count
   */
  static async getUnreadCount(userId) {
    const query = 'SELECT COUNT(*) as count FROM notificacion WHERE id_usuario = ? AND leida = 0';
    const results = await executeQuery(query, [userId]);
    return results[0].count;
  }
}

module.exports = Notificacion;
