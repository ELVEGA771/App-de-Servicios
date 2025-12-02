const { executeQuery, executeTransaction } = require('../config/database');

class Empresa {
  /**
   * Find empresa by ID
   */
  static async findById(id) {
    const query = `
      SELECT e.*, u.*
      FROM empresa e
      INNER JOIN usuario u ON e.id_usuario = u.id_usuario
      WHERE e.id_empresa = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Find empresa by user ID
   */
  static async findByUserId(userId) {
    const query = `
      SELECT e.*, u.*
      FROM empresa e
      INNER JOIN usuario u ON e.id_usuario = u.id_usuario
      WHERE e.id_usuario = ?
    `;
    const results = await executeQuery(query, [userId]);
    return results[0] || null;
  }

  /**
   * Get all empresas with pagination
   */
  static async getAll(page = 1, limit = 20, filters = {}) {
    const offset = (page - 1) * limit;
    let query = `
      SELECT e.*, u.email, u.telefono, u.estado
      FROM empresa e
      INNER JOIN usuario u ON e.id_usuario = u.id_usuario
      WHERE 1=1
    `;
    const params = [];

    // Apply filters
    if (filters.search) {
      query += ' AND (e.razon_social LIKE ? OR u.email LIKE ?)';
      const searchTerm = `%${filters.search}%`;
      params.push(searchTerm, searchTerm);
    }

    if (filters.estado) {
      query += ' AND u.estado = ?';
      params.push(filters.estado);
    }

    if (filters.calificacion_min) {
      query += ' AND e.calificacion_promedio >= ?';
      params.push(filters.calificacion_min);
    }

    // Count total
    const countQuery = query.replace('SELECT e.*, u.email, u.telefono, u.estado', 'SELECT COUNT(*) as total');
    const countResult = await executeQuery(countQuery, params);
    const total = countResult[0].total;

    // Add ordering and pagination
    query += ' ORDER BY e.calificacion_promedio DESC, e.id_empresa DESC';
    query += ' LIMIT ? OFFSET ?';
    params.push(limit, offset);

    const results = await executeQuery(query, params);
    return { data: results, total };
  }

  /**
   * Create new empresa
   */
  static async create(empresaData) {
    return executeTransaction(async (connection) => {
      const query = `
        INSERT INTO empresa (id_usuario, razon_social, ruc_nit, descripcion, logo_url)
        VALUES (?, ?, ?, ?, ?)
      `;
      const params = [
        empresaData.id_usuario,
        empresaData.razon_social,
        empresaData.ruc_nit || null,
        empresaData.descripcion || null,
        empresaData.logo_url || null
      ];
      const result = await executeQuery(query, params, connection);
      return result.insertId;
    });
  }

  /**
   * Update empresa
   */
  static async update(id, empresaData) {
    return executeTransaction(async (connection) => {
      const fields = [];
      const params = [];

      if (empresaData.razon_social !== undefined) {
        fields.push('razon_social = ?');
        params.push(empresaData.razon_social);
      }
      if (empresaData.ruc_nit !== undefined) {
        fields.push('ruc_nit = ?');
        params.push(empresaData.ruc_nit);
      }
      if (empresaData.descripcion !== undefined) {
        fields.push('descripcion = ?');
        params.push(empresaData.descripcion);
      }
      if (empresaData.logo_url !== undefined) {
        fields.push('logo_url = ?');
        params.push(empresaData.logo_url);
      }

      if (fields.length === 0) return null;

      params.push(id);
      const query = `UPDATE empresa SET ${fields.join(', ')} WHERE id_empresa = ?`;
      await executeQuery(query, params, connection);
      
      // Para devolver la empresa actualizada, necesitamos hacer la consulta dentro de la transacción
      // o fuera. Si es dentro, usamos la conexión.
      const findQuery = `
        SELECT e.*, u.*
        FROM empresa e
        INNER JOIN usuario u ON e.id_usuario = u.id_usuario
        WHERE e.id_empresa = ?
      `;
      const results = await executeQuery(findQuery, [id], connection);
      return results[0] || null;
    });
  }

  /**
   * Get empresa statistics
   */
  static async getStatistics(id) {
    const query = `
      SELECT * FROM vista_estadisticas_empresa WHERE id_empresa = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get income details (contrataciones completadas)
   */
  static async getIncomeDetails(idEmpresa, page = 1, limit = 20) {
    const limitNum = parseInt(limit, 10);
    const pageNum = parseInt(page, 10);
    const offset = (pageNum - 1) * limitNum;
    
    const query = `
      SELECT 
        id_contratacion,
        fecha_completada,
        servicio_nombre,
        cliente_nombre,
        cliente_foto,
        metodo_pago,
        precio_total,
        calificacion,
        calificacion_comentario
      FROM vista_contrataciones_detalle
      WHERE id_empresa = ? 
        AND estado_contratacion = 'completado'
      ORDER BY fecha_completada DESC
      LIMIT ? OFFSET ?
    `;
    
    const countQuery = `
      SELECT COUNT(*) as total
      FROM vista_contrataciones_detalle
      WHERE id_empresa = ? 
        AND estado_contratacion = 'completado'
    `;

    const countResult = await executeQuery(countQuery, [idEmpresa]);
    const total = countResult[0].total;

    const results = await executeQuery(query, [idEmpresa, limitNum, offset]);
    return { data: results, total };
  }

  /**
   * Check if RUC/NIT exists
   */
  static async rucExists(rucNit, excludeId = null) {
    let query = 'SELECT COUNT(*) as count FROM empresa WHERE ruc_nit = ?';
    const params = [rucNit];

    if (excludeId) {
      query += ' AND id_empresa != ?';
      params.push(excludeId);
    }

    const results = await executeQuery(query, params);
    return results[0].count > 0;
  }
}

module.exports = Empresa;
