const { executeQuery, executeTransaction } = require('../config/database');

class Mensaje {
  /**
   * Create new mensaje (using stored procedure)
   */
  static async create(mensajeData) {
    return executeTransaction(async (connection) => {
      // 1. Validate conversation exists
      const checkConvQuery = 'SELECT 1 FROM conversacion WHERE id_conversacion = ?';
      const convExists = await executeQuery(checkConvQuery, [mensajeData.id_conversacion], connection);
      if (convExists.length === 0) {
        throw new Error('La conversación no existe');
      }

      // 2. Validate content
      const tipo = mensajeData.tipo_mensaje || 'texto';
      if (tipo === 'texto' && (!mensajeData.contenido || !mensajeData.contenido.trim())) {
        throw new Error('El contenido del mensaje no puede estar vacío');
      }

      // 3. Insert message
      const query = `
        INSERT INTO mensaje (id_conversacion, id_remitente, contenido, tipo_mensaje)
        VALUES (?, ?, ?, ?)
      `;
      const params = [
        mensajeData.id_conversacion,
        mensajeData.id_remitente,
        mensajeData.contenido,
        tipo
      ];

      const result = await executeQuery(query, params, connection);
      const idMensaje = result.insertId;

      // 4. Update conversation
      const updateConvQuery = 'UPDATE conversacion SET fecha_ultimo_mensaje = NOW() WHERE id_conversacion = ?';
      await executeQuery(updateConvQuery, [mensajeData.id_conversacion], connection);

      return idMensaje;
    });
  }

  /**
   * Find mensaje by ID
   */
  static async findById(id) {
    const query = `
      SELECT 
        m.*,
        CONCAT(u.nombre, ' ', u.apellido) as remitente_nombre,
        u.foto_perfil_url as remitente_foto,
        u.tipo_usuario as tipo_remitente
      FROM mensaje m
      INNER JOIN usuario u ON m.id_remitente = u.id_usuario
      WHERE m.id_mensaje = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }
}

module.exports = Mensaje;
