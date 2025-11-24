const { executeQuery } = require('../config/database');

class Mensaje {
  /**
   * Create new mensaje
   */
  static async create(mensajeData) {
    const query = `
      INSERT INTO mensaje (id_conversacion, id_remitente, contenido, tipo_mensaje, archivo_url)
      VALUES (?, ?, ?, ?, ?)
    `;
    const params = [
      mensajeData.id_conversacion,
      mensajeData.id_remitente,
      mensajeData.contenido,
      mensajeData.tipo_mensaje || 'texto',
      mensajeData.archivo_url || null
    ];
    const result = await executeQuery(query, params);
    // Note: Trigger will automatically update conversacion.fecha_ultimo_mensaje
    return result.insertId;
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
