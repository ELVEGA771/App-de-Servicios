const { executeQuery, executeTransaction } = require('../config/database');

class Favorito {
  /**
   * Get favoritos by cliente
   */
  static async getByCliente(idCliente) {
    const query = `
      SELECT
        sf.*,
        s.*,
        e.razon_social as empresa_nombre,
        e.calificacion_promedio as empresa_calificacion,
        c.nombre as categoria_nombre
      FROM servicio_favorito sf
      INNER JOIN servicio s ON sf.id_servicio = s.id_servicio
      INNER JOIN empresa e ON s.id_empresa = e.id_empresa
      INNER JOIN categoria_servicio c ON s.id_categoria = c.id_categoria
      WHERE sf.id_cliente = ?
      ORDER BY sf.fecha_agregado DESC
    `;
    return executeQuery(query, [idCliente]);
  }

  /**
   * Add to favoritos
   */
  static async add(idCliente, idServicio) {
    return executeTransaction(async (connection) => {
      const query = `
        INSERT INTO servicio_favorito (id_servicio, id_cliente, fecha_agregado)
        VALUES (?, ?, NOW())
        ON DUPLICATE KEY UPDATE fecha_agregado = NOW()
      `;
      await executeQuery(query, [idServicio, idCliente], connection);
      return true;
    });
  }

  /**
   * Remove from favoritos
   */
  static async remove(idCliente, idServicio) {
    return executeTransaction(async (connection) => {
      const query = 'DELETE FROM servicio_favorito WHERE id_cliente = ? AND id_servicio = ?';
      await executeQuery(query, [idCliente, idServicio], connection);
      return true;
    });
  }

  /**
   * Check if servicio is favorito
   */
  static async isFavorite(idCliente, idServicio) {
    const query = `
      SELECT COUNT(*) as count
      FROM servicio_favorito
      WHERE id_cliente = ? AND id_servicio = ?
    `;
    const results = await executeQuery(query, [idCliente, idServicio]);
    return results[0].count > 0;
  }
}

module.exports = Favorito;
