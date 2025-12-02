const { executeQuery, executeTransaction } = require('../config/database');

class Mensaje {
  /**
   * Create new mensaje (using stored procedure)
   */
  static async create(mensajeData) {
    return executeTransaction(async (connection) => {
      // Call stored procedure
      const query = `
        CALL sp_crear_mensaje(?, ?, ?, ?, ?, @out_id_mensaje, @out_mensaje)
      `;
      const params = [
        mensajeData.id_conversacion,
        mensajeData.id_remitente,
        mensajeData.contenido,
        mensajeData.tipo_mensaje || null,
        mensajeData.archivo_url || null
      ];

      await executeQuery(query, params, connection);

      // Get output parameters
      const resultQuery = 'SELECT @out_id_mensaje as id_mensaje, @out_mensaje as mensaje';
      const results = await executeQuery(resultQuery, [], connection);

      if (!results[0].id_mensaje) {
        throw new Error(results[0].mensaje || 'Error al crear mensaje');
      }

      return results[0].id_mensaje;
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
