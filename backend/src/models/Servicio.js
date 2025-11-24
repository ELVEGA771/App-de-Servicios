const { executeQuery } = require('../config/database');

class Servicio {
  /**
   * Find servicio by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM vista_servicios_completos WHERE id_servicio = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Find servicio by ID from raw table (for creation response)
   */
  static async findByIdRaw(id) {
    const query = `
      SELECT
        s.*,
        c.nombre as categoria_nombre
      FROM servicio s
      LEFT JOIN categoria_servicio c ON s.id_categoria = c.id_categoria
      WHERE s.id_servicio = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get all servicios with filters and pagination
   */
  static async getAll(page = 1, limit = 20, filters = {}) {
    const offset = (page - 1) * limit;
    let query = 'SELECT vsc.* FROM vista_servicios_completos vsc WHERE 1=1';
    const params = [];

    // Apply filters
    if (filters.ciudad) {
      // Join with sucursal to filter by city
      query = 'SELECT DISTINCT vsc.* FROM vista_servicios_completos vsc INNER JOIN servicio_sucursal ss ON vsc.id_servicio = ss.id_servicio INNER JOIN sucursal suc ON ss.id_sucursal = suc.id_sucursal INNER JOIN direccion d ON suc.id_direccion = d.id_direccion WHERE d.ciudad = ?';
      params.push(filters.ciudad);
    }

    if (filters.categoria) {
      query += ' AND vsc.categoria_nombre = ?';
      params.push(filters.categoria);
    }

    if (filters.id_categoria) {
      query = query.replace('FROM vista_servicios_completos vsc', 'FROM vista_servicios_completos vsc INNER JOIN servicio s ON vsc.id_servicio = s.id_servicio');
      query += ' AND s.id_categoria = ?';
      params.push(filters.id_categoria);
    }

    if (filters.precio_min) {
      query += ' AND vsc.precio_base >= ?';
      params.push(filters.precio_min);
    }

    if (filters.precio_max) {
      query += ' AND vsc.precio_base <= ?';
      params.push(filters.precio_max);
    }

    if (filters.calificacion_min) {
      query += ' AND vsc.empresa_calificacion >= ?';
      params.push(filters.calificacion_min);
    }

    if (filters.busqueda) {
      query += ' AND (vsc.servicio_nombre LIKE ? OR vsc.descripcion LIKE ? OR vsc.empresa_nombre LIKE ?)';
      const searchTerm = `%${filters.busqueda}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    if (filters.estado) {
      query += ' AND vsc.servicio_estado = ?';
      params.push(filters.estado);
    } else {
      // Default: only show available services
      query += ' AND vsc.servicio_estado = ?';
      params.push('disponible');
    }

    // Count total - Build a proper count query by replacing SELECT vsc.* with COUNT(*)
    let countQuery = query.replace(/SELECT\s+DISTINCT\s+vsc\.\*/i, 'SELECT COUNT(*) as total');
    countQuery = countQuery.replace(/SELECT\s+vsc\.\*/i, 'SELECT COUNT(*) as total');
    // Use a copy of params for the count query to avoid corruption
    const countResult = await executeQuery(countQuery, [...params]);
    const total = countResult[0].total;

    // Add ordering
    let orderBy = 'vsc.id_servicio DESC';
    if (filters.ordenar === 'precio_asc') {
      orderBy = 'vsc.precio_base ASC';
    } else if (filters.ordenar === 'precio_desc') {
      orderBy = 'vsc.precio_base DESC';
    } else if (filters.ordenar === 'calificacion') {
      orderBy = 'vsc.empresa_calificacion DESC, vsc.id_servicio DESC';
    } else if (filters.ordenar === 'recientes') {
      orderBy = 'vsc.id_servicio DESC';
    }

    query += ` ORDER BY ${orderBy}`;
    query += ' LIMIT ? OFFSET ?';
    params.push(Number(limit), Number(offset));

    const results = await executeQuery(query, params);
    return { data: results, total };
  }

  /**
   * Get servicios by empresa
   */
  static async getByEmpresa(idEmpresa, page = 1, limit = 20) {
    const offset = (page - 1) * limit;
    const query = `
      SELECT s.*, c.nombre as categoria_nombre
      FROM servicio s
      INNER JOIN categoria_servicio c ON s.id_categoria = c.id_categoria
      WHERE s.id_empresa = ?
      ORDER BY s.fecha_creacion DESC
      LIMIT ? OFFSET ?
    `;
    const results = await executeQuery(query, [idEmpresa, limit, offset]);

    // Count total
    const countQuery = 'SELECT COUNT(*) as total FROM servicio WHERE id_empresa = ?';
    const countResult = await executeQuery(countQuery, [idEmpresa]);
    const total = countResult[0].total;

    return { data: results, total };
  }

  /**
   * Create new servicio
   */
  static async create(servicioData) {
    const query = `
      INSERT INTO servicio (id_empresa, id_categoria, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const params = [
      servicioData.id_empresa,
      servicioData.id_categoria,
      servicioData.nombre,
      servicioData.descripcion || null,
      servicioData.precio_base,
      servicioData.duracion_estimada || null,
      servicioData.imagen_url || null,
      servicioData.estado || 'disponible'
    ];
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Update servicio
   */
  static async update(id, servicioData) {
    const fields = [];
    const params = [];

    if (servicioData.nombre !== undefined) {
      fields.push('nombre = ?');
      params.push(servicioData.nombre);
    }
    if (servicioData.descripcion !== undefined) {
      fields.push('descripcion = ?');
      params.push(servicioData.descripcion);
    }
    if (servicioData.precio_base !== undefined) {
      fields.push('precio_base = ?');
      params.push(servicioData.precio_base);
    }
    if (servicioData.duracion_estimada !== undefined) {
      fields.push('duracion_estimada = ?');
      params.push(servicioData.duracion_estimada);
    }
    if (servicioData.imagen_url !== undefined) {
      fields.push('imagen_url = ?');
      params.push(servicioData.imagen_url);
    }
    if (servicioData.estado !== undefined) {
      fields.push('estado = ?');
      params.push(servicioData.estado);
    }
    if (servicioData.id_categoria !== undefined) {
      fields.push('id_categoria = ?');
      params.push(servicioData.id_categoria);
    }

    if (fields.length === 0) return null;

    params.push(id);
    const query = `UPDATE servicio SET ${fields.join(', ')} WHERE id_servicio = ?`;
    await executeQuery(query, params);
    return this.findById(id);
  }

  /**
   * Delete servicio
   */
  static async delete(id) {
    const query = 'DELETE FROM servicio WHERE id_servicio = ?';
    await executeQuery(query, [id]);
    return true;
  }

  /**
   * Get servicio sucursales
   */
  static async getSucursales(idServicio) {
    const query = `
      SELECT
        ss.*,
        s.nombre_sucursal,
        s.telefono,
        s.estado,
        d.ciudad,
        d.calle_principal
      FROM servicio_sucursal ss
      INNER JOIN sucursal s ON ss.id_sucursal = s.id_sucursal
      INNER JOIN direccion d ON s.id_direccion = d.id_direccion
      WHERE ss.id_servicio = ? AND ss.disponible = 1 AND s.estado = 'activa'
    `;
    return executeQuery(query, [idServicio]);
  }

  /**
   * Associate servicio with sucursal
   */
  static async addToSucursal(idServicio, idSucursal, precioSucursal = null) {
    const query = `
      INSERT INTO servicio_sucursal (id_servicio, id_sucursal, disponible, precio_sucursal)
      VALUES (?, ?, 1, ?)
      ON DUPLICATE KEY UPDATE disponible = 1, precio_sucursal = ?
    `;
    await executeQuery(query, [idServicio, idSucursal, precioSucursal, precioSucursal]);
    return true;
  }

  /**
   * Remove servicio from sucursal
   */
  static async removeFromSucursal(idServicio, idSucursal) {
    const query = 'DELETE FROM servicio_sucursal WHERE id_servicio = ? AND id_sucursal = ?';
    await executeQuery(query, [idServicio, idSucursal]);
    return true;
  }
}

module.exports = Servicio;
