const { executeQuery } = require('../config/database');

class Conversacion {
  /**
   * Find conversacion by ID
   */
  static async findById(id) {
    const query = `
      SELECT
        c.*,
        CONCAT(uc.nombre, ' ', uc.apellido) as cliente_nombre,
        e.razon_social as empresa_nombre
      FROM conversacion c
      INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
      INNER JOIN usuario uc ON cli.id_usuario = uc.id_usuario
      INNER JOIN empresa e ON c.id_empresa = e.id_empresa
      WHERE c.id_conversacion = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get conversaciones by user
   */
  static async getByUser(userId, userType) {
    let query;

    if (userType === 'cliente') {
      query = `
        SELECT
          c.*,
          e.razon_social as empresa_nombre,
          ue.foto_perfil_url as empresa_foto,
          (SELECT COUNT(*) FROM mensaje WHERE id_conversacion = c.id_conversacion AND leido = 0 AND id_remitente != ?) as mensajes_no_leidos
        FROM conversacion c
        INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
        INNER JOIN empresa e ON c.id_empresa = e.id_empresa
        INNER JOIN usuario ue ON e.id_usuario = ue.id_usuario
        WHERE cli.id_usuario = ?
        ORDER BY c.fecha_ultimo_mensaje DESC
      `;
      return executeQuery(query, [userId, userId]);
    } else if (userType === 'empresa') {
      query = `
        SELECT
          c.*,
          CONCAT(uc.nombre, ' ', uc.apellido) as cliente_nombre,
          uc.foto_perfil_url as cliente_foto,
          (SELECT COUNT(*) FROM mensaje WHERE id_conversacion = c.id_conversacion AND leido = 0 AND id_remitente != ?) as mensajes_no_leidos
        FROM conversacion c
        INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
        INNER JOIN usuario uc ON cli.id_usuario = uc.id_usuario
        INNER JOIN empresa e ON c.id_empresa = e.id_empresa
        WHERE e.id_usuario = ?
        ORDER BY c.fecha_ultimo_mensaje DESC
      `;
      return executeQuery(query, [userId, userId]);
    }

    return [];
  }

  /**
   * Create new conversacion
   */
  static async create(conversacionData) {
    const query = `
      INSERT INTO conversacion (id_cliente, id_empresa, id_contratacion, estado)
      VALUES (?, ?, ?, ?)
    `;
    const params = [
      conversacionData.id_cliente,
      conversacionData.id_empresa,
      conversacionData.id_contratacion || null,
      conversacionData.estado || 'abierta'
    ];
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Update conversacion estado
   */
  static async updateEstado(id, estado) {
    const query = 'UPDATE conversacion SET estado = ? WHERE id_conversacion = ?';
    await executeQuery(query, [estado, id]);
    return this.findById(id);
  }

  /**
   * Get mensajes from conversacion
   */
  static async getMensajes(idConversacion, page = 1, limit = 50) {
    const offset = (page - 1) * limit;
    const query = `
      SELECT
        m.*,
        CONCAT(u.nombre, ' ', u.apellido) as remitente_nombre,
        u.foto_perfil_url as remitente_foto
      FROM mensaje m
      INNER JOIN usuario u ON m.id_remitente = u.id_usuario
      WHERE m.id_conversacion = ?
      ORDER BY m.fecha_envio DESC
      LIMIT ? OFFSET ?
    `;
    const results = await executeQuery(query, [idConversacion, limit, offset]);

    // Count total
    const countQuery = 'SELECT COUNT(*) as total FROM mensaje WHERE id_conversacion = ?';
    const countResult = await executeQuery(countQuery, [idConversacion]);
    const total = countResult[0].total;

    return { data: results.reverse(), total }; // Reverse to show oldest first
  }

  /**
   * Mark mensajes as read
   */
  static async markAsRead(idConversacion, userId) {
    const query = `
      UPDATE mensaje
      SET leido = 1, fecha_lectura = NOW()
      WHERE id_conversacion = ? AND id_remitente != ? AND leido = 0
    `;
    await executeQuery(query, [idConversacion, userId]);
    return true;
  }
}

module.exports = Conversacion;
