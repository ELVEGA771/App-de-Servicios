const { executeQuery } = require('../config/database');

class Cupon {
  /**
   * Find cupon by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM cupon WHERE id_cupon = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Find cupon by codigo
   */
  static async findByCodigo(codigo) {
    const query = 'SELECT * FROM cupon WHERE codigo = ?';
    const results = await executeQuery(query, [codigo]);
    return results[0] || null;
  }

  /**
   * Get cupones by empresa
   */
  static async getByEmpresa(idEmpresa, activeOnly = false) {
    let query = 'SELECT * FROM cupon WHERE id_empresa = ?';
    const params = [idEmpresa];

    if (activeOnly) {
      query += ' AND activo = 1 AND (fecha_expiracion IS NULL OR fecha_expiracion > NOW())';
    }

    query += ' ORDER BY fecha_inicio DESC';
    return executeQuery(query, params);
  }

  /**
   * Get active cupones
   */
  static async getActive() {
    const query = `
      SELECT c.*, e.razon_social
      FROM cupon c
      INNER JOIN empresa e ON c.id_empresa = e.id_empresa
      WHERE c.activo = 1
        AND (c.fecha_expiracion IS NULL OR c.fecha_expiracion > NOW())
        AND (c.cantidad_disponible IS NULL OR c.cantidad_usada < c.cantidad_disponible)
      ORDER BY c.valor_descuento DESC
    `;
    return executeQuery(query);
  }

  /**
   * Create new cupon
   */
  static async create(cuponData) {
    const query = `
      INSERT INTO cupon (
        id_empresa, codigo, descripcion, tipo_descuento, valor_descuento,
        monto_minimo_compra, cantidad_disponible, fecha_inicio, fecha_expiracion,
        activo, aplicable_a
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const params = [
      cuponData.id_empresa,
      cuponData.codigo,
      cuponData.descripcion || null,
      cuponData.tipo_descuento,
      cuponData.valor_descuento,
      cuponData.monto_minimo_compra || 0,
      cuponData.cantidad_disponible || null,
      cuponData.fecha_inicio || null,
      cuponData.fecha_expiracion || null,
      cuponData.activo !== undefined ? cuponData.activo : 1,
      cuponData.aplicable_a || 'todos'
    ];
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Update cupon
   */
  static async update(id, cuponData) {
    const fields = [];
    const params = [];

    if (cuponData.descripcion !== undefined) {
      fields.push('descripcion = ?');
      params.push(cuponData.descripcion);
    }
    if (cuponData.tipo_descuento !== undefined) {
      fields.push('tipo_descuento = ?');
      params.push(cuponData.tipo_descuento);
    }
    if (cuponData.valor_descuento !== undefined) {
      fields.push('valor_descuento = ?');
      params.push(cuponData.valor_descuento);
    }
    if (cuponData.monto_minimo_compra !== undefined) {
      fields.push('monto_minimo_compra = ?');
      params.push(cuponData.monto_minimo_compra);
    }
    if (cuponData.cantidad_disponible !== undefined) {
      fields.push('cantidad_disponible = ?');
      params.push(cuponData.cantidad_disponible);
    }
    if (cuponData.fecha_expiracion !== undefined) {
      fields.push('fecha_expiracion = ?');
      params.push(cuponData.fecha_expiracion);
    }
    if (cuponData.activo !== undefined) {
      fields.push('activo = ?');
      params.push(cuponData.activo);
    }

    if (fields.length === 0) return null;

    params.push(id);
    const query = `UPDATE cupon SET ${fields.join(', ')} WHERE id_cupon = ?`;
    await executeQuery(query, params);
    return this.findById(id);
  }

  /**
   * Delete cupon
   */
  static async delete(id) {
    const query = 'DELETE FROM cupon WHERE id_cupon = ?';
    await executeQuery(query, [id]);
    return true;
  }

  /**
   * Validate cupon (using stored procedure)
   */
  static async validate(codigo, idServicio, montoCompra) {
    try {
      const query = 'CALL sp_validar_cupon(?, ?, ?, @valido, @descuento, @precio_final, @mensaje)';
      await executeQuery(query, [codigo, idServicio, montoCompra]);

      // Get output variables
      const resultQuery = 'SELECT @valido as valido, @descuento as descuento, @precio_final as precio_final, @mensaje as mensaje';
      const results = await executeQuery(resultQuery);

      return {
        valido: results[0].valido === 1,
        descuento: parseFloat(results[0].descuento) || 0,
        precio_final: parseFloat(results[0].precio_final) || montoCompra,
        mensaje: results[0].mensaje
      };
    } catch (error) {
      // If stored procedure doesn't exist, do manual validation
      return this.manualValidate(codigo, idServicio, montoCompra);
    }
  }

  /**
   * Manual cupon validation (fallback if SP not available)
   */
  static async manualValidate(codigo, idServicio, montoCompra) {
    const cupon = await this.findByCodigo(codigo);

    if (!cupon) {
      return { valido: false, descuento: 0, precio_final: montoCompra, mensaje: 'Cupón no encontrado' };
    }

    if (!cupon.activo) {
      return { valido: false, descuento: 0, precio_final: montoCompra, mensaje: 'Cupón inactivo' };
    }

    if (cupon.fecha_expiracion && new Date(cupon.fecha_expiracion) < new Date()) {
      return { valido: false, descuento: 0, precio_final: montoCompra, mensaje: 'Cupón expirado' };
    }

    if (cupon.cantidad_disponible && cupon.cantidad_usada >= cupon.cantidad_disponible) {
      return { valido: false, descuento: 0, precio_final: montoCompra, mensaje: 'Cupón agotado' };
    }

    if (montoCompra < cupon.monto_minimo_compra) {
      return { valido: false, descuento: 0, precio_final: montoCompra, mensaje: `Monto mínimo de compra: $${cupon.monto_minimo_compra}` };
    }

    // Calculate discount
    let descuento = 0;
    if (cupon.tipo_descuento === 'porcentaje') {
      descuento = (montoCompra * cupon.valor_descuento) / 100;
    } else {
      descuento = cupon.valor_descuento;
    }

    const precioFinal = Math.max(0, montoCompra - descuento);

    return {
      valido: true,
      descuento,
      precio_final: precioFinal,
      mensaje: 'Cupón válido'
    };
  }

  /**
   * Add categoria to cupon
   */
  static async addCategoria(idCupon, idCategoria) {
    const query = 'INSERT INTO cupon_categoria (id_cupon, id_categoria) VALUES (?, ?)';
    await executeQuery(query, [idCupon, idCategoria]);
    return true;
  }

  /**
   * Add servicio to cupon
   */
  static async addServicio(idCupon, idServicio) {
    const query = 'INSERT INTO cupon_servicio (id_cupon, id_servicio) VALUES (?, ?)';
    await executeQuery(query, [idCupon, idServicio]);
    return true;
  }
}

module.exports = Cupon;
