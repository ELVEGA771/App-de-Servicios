const { executeQuery, executeTransaction } = require('../config/database');

class Categoria {
  /**
   * Get all categorias
   */
  static async getAll() {
    const query = 'SELECT * FROM categoria_servicio ORDER BY nombre ASC';
    return executeQuery(query);
  }

  /**
   * Find categoria by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM categoria_servicio WHERE id_categoria = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Find categoria by nombre
   */
  static async findByNombre(nombre) {
    const query = 'SELECT * FROM categoria_servicio WHERE nombre = ?';
    const results = await executeQuery(query, [nombre]);
    return results[0] || null;
  }

  /**
   * Create new categoria
   */
  static async create(categoriaData) {
    return executeTransaction(async (connection) => {
      const query = `
        INSERT INTO categoria_servicio (nombre, descripcion, icono_url)
        VALUES (?, ?, ?)
      `;
      const params = [
        categoriaData.nombre,
        categoriaData.descripcion || null,
        categoriaData.icono_url || null
      ];
      const result = await executeQuery(query, params, connection);
      return result.insertId;
    });
  }

  /**
   * Update categoria
   */
  static async update(id, categoriaData) {
    return executeTransaction(async (connection) => {
      const fields = [];
      const params = [];

      if (categoriaData.nombre !== undefined) {
        fields.push('nombre = ?');
        params.push(categoriaData.nombre);
      }
      if (categoriaData.descripcion !== undefined) {
        fields.push('descripcion = ?');
        params.push(categoriaData.descripcion);
      }
      if (categoriaData.icono_url !== undefined) {
        fields.push('icono_url = ?');
        params.push(categoriaData.icono_url);
      }

      if (fields.length === 0) return null;

      params.push(id);
      const query = `UPDATE categoria_servicio SET ${fields.join(', ')} WHERE id_categoria = ?`;
      await executeQuery(query, params, connection);
      
      const findQuery = 'SELECT * FROM categoria_servicio WHERE id_categoria = ?';
      const results = await executeQuery(findQuery, [id], connection);
      return results[0] || null;
    });
  }

  /**
   * Get servicios count by categoria
   */
  static async getServiciosCount(id) {
    const query = 'SELECT COUNT(*) as count FROM servicio WHERE id_categoria = ?';
    const results = await executeQuery(query, [id]);
    return results[0].count;
  }
}

module.exports = Categoria;
