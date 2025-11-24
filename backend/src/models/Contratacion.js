const { executeQuery } = require('../config/database');

class Contratacion {
  /**
   * Find contratacion by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM vista_contrataciones_detalle WHERE id_contratacion = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get contrataciones by cliente
   */
  static async getByCliente(idCliente, page = 1, limit = 20, estado = null) {
    const offset = (page - 1) * limit;
    let query = `
      SELECT * FROM vista_contrataciones_detalle
      WHERE id_contratacion IN (
        SELECT id_contratacion FROM contratacion WHERE id_cliente = ?
      )
    `;
    const params = [idCliente];

    if (estado) {
      query += ' AND estado_contratacion = ?';
      params.push(estado);
    }

    // Count total
    const countQuery = query.replace('SELECT *', 'SELECT COUNT(*) as total');
    const countResult = await executeQuery(countQuery, params);
    const total = countResult[0].total;

    query += ' ORDER BY fecha_solicitud DESC LIMIT ? OFFSET ?';
    params.push(limit, offset);

    const results = await executeQuery(query, params);
    return { data: results, total };
  }

  /**
   * Get contrataciones by empresa
   */
  static async getByEmpresa(idEmpresa, page = 1, limit = 20, estado = null) {
    const offset = (page - 1) * limit;
    let query = `
      SELECT vcd.* FROM vista_contrataciones_detalle vcd
      INNER JOIN contratacion c ON vcd.id_contratacion = c.id_contratacion
      INNER JOIN servicio s ON c.id_servicio = s.id_servicio
      WHERE s.id_empresa = ?
    `;
    const params = [idEmpresa];

    if (estado) {
      query += ' AND vcd.estado_contratacion = ?';
      params.push(estado);
    }

    // Count total
    const countQuery = query.replace('SELECT vcd.*', 'SELECT COUNT(*) as total');
    const countResult = await executeQuery(countQuery, params);
    const total = countResult[0].total;

    query += ' ORDER BY vcd.fecha_solicitud DESC LIMIT ? OFFSET ?';
    params.push(limit, offset);

    const results = await executeQuery(query, params);
    return { data: results, total };
  }

  /**
   * Create new contratacion
   */
  static async create(contratacionData) {
    const query = `
      INSERT INTO contratacion (
        id_cliente, id_servicio, id_sucursal, id_direccion_entrega, id_cupon,
        fecha_programada, precio_subtotal, descuento_aplicado, precio_total,
        estado, notas_cliente
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const params = [
      contratacionData.id_cliente,
      contratacionData.id_servicio,
      contratacionData.id_sucursal,
      contratacionData.id_direccion_entrega,
      contratacionData.id_cupon || null,
      contratacionData.fecha_programada || null,
      contratacionData.precio_subtotal,
      contratacionData.descuento_aplicado || 0,
      contratacionData.precio_total,
      contratacionData.estado || 'pendiente',
      contratacionData.notas_cliente || null
    ];
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Update contratacion estado
   */
  static async updateEstado(id, estado, notasEmpresa = null) {
    const fields = ['estado = ?'];
    const params = [estado];

    if (notasEmpresa !== null) {
      fields.push('notas_empresa = ?');
      params.push(notasEmpresa);
    }

    if (estado === 'completado') {
      fields.push('fecha_completada = NOW()');
    }

    params.push(id);
    const query = `UPDATE contratacion SET ${fields.join(', ')} WHERE id_contratacion = ?`;
    await executeQuery(query, params);
    return this.findById(id);
  }

  /**
   * Cancel contratacion
   */
  static async cancel(id, userId) {
    const query = `
      UPDATE contratacion
      SET estado = 'cancelado'
      WHERE id_contratacion = ? AND estado IN ('pendiente', 'confirmado')
    `;
    await executeQuery(query, [id]);
    return this.findById(id);
  }

  /**
   * Check if contratacion can be rated
   */
  static async canBeRated(idContratacion) {
    const query = `
      SELECT COUNT(*) as count
      FROM contratacion
      WHERE id_contratacion = ? AND estado = 'completado'
    `;
    const results = await executeQuery(query, [idContratacion]);
    return results[0].count > 0;
  }

  /**
   * Check if user participated in contratacion
   */
  static async userParticipated(idContratacion, userId, userType) {
    let query;
    if (userType === 'cliente') {
      query = `
        SELECT COUNT(*) as count
        FROM contratacion con
        INNER JOIN cliente cli ON con.id_cliente = cli.id_cliente
        WHERE con.id_contratacion = ? AND cli.id_usuario = ?
      `;
    } else if (userType === 'empresa') {
      query = `
        SELECT COUNT(*) as count
        FROM contratacion con
        INNER JOIN servicio s ON con.id_servicio = s.id_servicio
        INNER JOIN empresa e ON s.id_empresa = e.id_empresa
        WHERE con.id_contratacion = ? AND e.id_usuario = ?
      `;
    } else {
      return false;
    }

    const results = await executeQuery(query, [idContratacion, userId]);
    return results[0].count > 0;
  }
}

module.exports = Contratacion;
