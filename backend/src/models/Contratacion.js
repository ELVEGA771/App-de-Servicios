const { executeQuery, executeTransaction } = require('../config/database');

class Contratacion {
  /**
   * Find contratacion by ID
   */
  static async findById(id) {
    const query = `
      SELECT v.*, p.metodo_pago, p.estado_pago 
      FROM vista_contrataciones_detalle v
      LEFT JOIN pago p ON v.id_contratacion = p.id_contratacion
      WHERE v.id_contratacion = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get contrataciones by cliente
   */
  static async getByCliente(idCliente, page = 1, limit = 20, estado = null) {
    const offset = (page - 1) * limit;
    let query = `
      SELECT v.*, p.metodo_pago, p.estado_pago 
      FROM vista_contrataciones_detalle v
      LEFT JOIN pago p ON v.id_contratacion = p.id_contratacion
      WHERE v.id_contratacion IN (
        SELECT id_contratacion FROM contratacion WHERE id_cliente = ?
      )
    `;
    const params = [idCliente];

    if (estado) {
      query += ' AND v.estado_contratacion = ?';
      params.push(estado);
    }

    // Count total
    const countQuery = `
      SELECT COUNT(*) as total 
      FROM vista_contrataciones_detalle v
      WHERE v.id_contratacion IN (
        SELECT id_contratacion FROM contratacion WHERE id_cliente = ?
      )
      ${estado ? ' AND v.estado_contratacion = ?' : ''}
    `;
    // Re-use params for count, but be careful with limit/offset
    const countParams = [idCliente];
    if (estado) countParams.push(estado);

    const countResult = await executeQuery(countQuery, countParams);
    const total = countResult[0].total;

    query += ' ORDER BY v.fecha_solicitud DESC LIMIT ? OFFSET ?';
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
      SELECT vcd.*, p.metodo_pago, p.estado_pago 
      FROM vista_contrataciones_detalle vcd
      INNER JOIN contratacion c ON vcd.id_contratacion = c.id_contratacion
      INNER JOIN servicio s ON c.id_servicio = s.id_servicio
      LEFT JOIN pago p ON vcd.id_contratacion = p.id_contratacion
      WHERE s.id_empresa = ?
    `;
    const params = [idEmpresa];

    if (estado) {
      query += ' AND vcd.estado_contratacion = ?';
      params.push(estado);
    }

    // Count total
    const countQuery = `
      SELECT COUNT(*) as total 
      FROM vista_contrataciones_detalle vcd
      INNER JOIN contratacion c ON vcd.id_contratacion = c.id_contratacion
      INNER JOIN servicio s ON c.id_servicio = s.id_servicio
      WHERE s.id_empresa = ?
      ${estado ? ' AND vcd.estado_contratacion = ?' : ''}
    `;
    
    const countParams = [idEmpresa];
    if (estado) countParams.push(estado);

    const countResult = await executeQuery(countQuery, countParams);
    const total = countResult[0].total;

    query += ' ORDER BY vcd.fecha_solicitud DESC LIMIT ? OFFSET ?';
    params.push(limit, offset);

    const results = await executeQuery(query, params);
    return { data: results, total };
  }

  /**
   * Create new contratacion (using stored procedure)
   */
  static async create(contratacionData) {
    return executeTransaction(async (connection) => {
      const query = `
        CALL sp_crear_contratacion(
          ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
          @out_id_contratacion, @out_mensaje
        )
      `;

      const params = [
        contratacionData.id_cliente,
        contratacionData.id_servicio,
        contratacionData.id_sucursal,
        contratacionData.id_direccion_entrega || null,
        contratacionData.id_cupon || null,
        contratacionData.fecha_programada,
        contratacionData.precio_subtotal,
        contratacionData.descuento_aplicado,
        contratacionData.precio_total,
        contratacionData.porcentaje_comision || null, // Nuevo campo
        contratacionData.notas_cliente || null
      ];

      try {
        await executeQuery(query, params, connection);
        
        // Obtener resultados del procedimiento
        const output = await executeQuery('SELECT @out_id_contratacion as id, @out_mensaje as mensaje', [], connection);
        
        if (!output[0].id) {
          throw new Error(output[0].mensaje || 'Error al crear la contratación');
        }

        return output[0].id;
      } catch (error) {
        throw error;
      }
    });
  }

  static async updateFinancials(id, comisionPlataforma, gananciaEmpresa) {
    return executeTransaction(async (connection) => {
      const query = `
        UPDATE contratacion 
        SET comision_plataforma = ?, 
            ganancia_empresa = ? 
        WHERE id_contratacion = ?
      `;
      await executeQuery(query, [comisionPlataforma, gananciaEmpresa, id], connection);
    });
  }

  /**
   * Update contratacion estado (using stored procedure)
   */
  static async updateEstado(id, estado, notas = null) {
    return executeTransaction(async (connection) => {
      // Call stored procedure
      const query = 'CALL sp_actualizar_estado_contratacion(?, ?, ?, @out_mensaje)';
      await executeQuery(query, [id, estado, notas], connection);

      // Get output message
      const resultQuery = 'SELECT @out_mensaje as mensaje';
      const results = await executeQuery(resultQuery, [], connection);

      // We can't easily return findById here because it doesn't accept connection
      // But since we are just returning the result, we can fetch it again or return true
      // The original code returned this.findById(id)
      
      // Let's replicate findById logic with connection
      const findQuery = `
        SELECT v.*, p.metodo_pago, p.estado_pago 
        FROM vista_contrataciones_detalle v
        LEFT JOIN pago p ON v.id_contratacion = p.id_contratacion
        WHERE v.id_contratacion = ?
      `;
      const findResults = await executeQuery(findQuery, [id], connection);
      return findResults[0] || null;
    });
  }

  /**
   * Cancel contratacion
   */
  static async cancel(id, userId) {
    return executeTransaction(async (connection) => {
      const query = `
        UPDATE contratacion
        SET estado = 'cancelado'
        WHERE id_contratacion = ? AND estado IN ('pendiente', 'confirmado')
      `;
      await executeQuery(query, [id], connection);
      
      const findQuery = `
        SELECT v.*, p.metodo_pago, p.estado_pago 
        FROM vista_contrataciones_detalle v
        LEFT JOIN pago p ON v.id_contratacion = p.id_contratacion
        WHERE v.id_contratacion = ?
      `;
      const findResults = await executeQuery(findQuery, [id], connection);
      return findResults[0] || null;
    });
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

  /**
   * Update payment status
   */
  static async updatePaymentStatus(idContratacion, status) {
    return executeTransaction(async (connection) => {
      const query = 'UPDATE pago SET estado_pago = ? WHERE id_contratacion = ?';
      await executeQuery(query, [status, idContratacion], connection);
      return true;
    });
  }

  /**
   * Get historial by empresa
   */
  static async getHistorialByEmpresa(idEmpresa, page = 1, limit = 20) {
    const offset = (page - 1) * limit;
    const query = `
      SELECT h.*, c.id_servicio, s.nombre as servicio_nombre, u.nombre as usuario_nombre, u.apellido as usuario_apellido
      FROM historial_estado_contratacion h
      INNER JOIN contratacion c ON h.id_contratacion = c.id_contratacion
      INNER JOIN servicio s ON c.id_servicio = s.id_servicio
      LEFT JOIN usuario u ON h.id_usuario_responsable = u.id_usuario
      WHERE s.id_empresa = ?
      ORDER BY h.fecha_cambio DESC
      LIMIT ? OFFSET ?
    `;
    
    // Count total
    const countQuery = `
      SELECT COUNT(*) as total 
      FROM historial_estado_contratacion h
      INNER JOIN contratacion c ON h.id_contratacion = c.id_contratacion
      INNER JOIN servicio s ON c.id_servicio = s.id_servicio
      WHERE s.id_empresa = ?
    `;

    const countResult = await executeQuery(countQuery, [idEmpresa]);
    const total = countResult[0].total;

    const results = await executeQuery(query, [idEmpresa, limit, offset]);
    return { data: results, total };
  }
}

module.exports = Contratacion;
