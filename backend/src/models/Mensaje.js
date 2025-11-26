const { executeQuery } = require('../config/database');

class Mensaje {
  /**
   * Create new mensaje (using stored procedure)
   */
  static async create(mensajeData) {
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

    await executeQuery(query, params);

    // Get output parameters
    const resultQuery = 'SELECT @out_id_mensaje as id_mensaje, @out_mensaje as mensaje';
    const results = await executeQuery(resultQuery);

    if (!results[0].id_mensaje) {
      throw new Error(results[0].mensaje || 'Error al crear mensaje');
    }

    return results[0].id_mensaje;
  }

  /**
   * Find mensaje by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM mensaje WHERE id_mensaje = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }
}

module.exports = Mensaje;
