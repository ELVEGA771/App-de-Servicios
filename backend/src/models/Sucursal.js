const { executeQuery, executeTransaction } = require('../config/database');
const Direccion = require('./Direccion');

class Sucursal {
  /**
   * Find sucursal by ID with direccion details
   */
  static async findById(id) {
    const query = `
      SELECT
        s.*,
        d.calle_principal,
        d.calle_secundaria,
        d.numero,
        d.ciudad,
        d.provincia_estado,
        d.codigo_postal,
        d.pais,
        d.latitud,
        d.longitud,
        d.referencia
      FROM sucursal s
      INNER JOIN direccion d ON s.id_direccion = d.id_direccion
      WHERE s.id_sucursal = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get all sucursales for an empresa
   */
  static async getByEmpresa(idEmpresa, page = 1, limit = 20) {
    const offset = (page - 1) * limit;
    const query = `
      SELECT
        s.*,
        d.calle_principal,
        d.calle_secundaria,
        d.numero,
        d.ciudad,
        d.provincia_estado,
        d.codigo_postal,
        d.pais,
        d.latitud,
        d.longitud,
        d.referencia
      FROM sucursal s
      INNER JOIN direccion d ON s.id_direccion = d.id_direccion
      WHERE s.id_empresa = ?
      ORDER BY s.id_sucursal DESC
      LIMIT ? OFFSET ?
    `;
    const results = await executeQuery(query, [idEmpresa, limit, offset]);

    // Count total
    const countQuery = 'SELECT COUNT(*) as total FROM sucursal WHERE id_empresa = ?';
    const countResult = await executeQuery(countQuery, [idEmpresa]);
    const total = countResult[0].total;

    return { data: results, total };
  }

  /**
   * Get all active sucursales for an empresa
   */
  static async getActiveSucursalesByEmpresa(idEmpresa) {
    const query = `
      SELECT
        s.id_sucursal,
        s.nombre_sucursal,
        s.telefono,
        s.estado,
        d.ciudad,
        d.calle_principal,
        d.provincia_estado
      FROM sucursal s
      INNER JOIN direccion d ON s.id_direccion = d.id_direccion
      WHERE s.id_empresa = ? AND s.estado = 'activa'
      ORDER BY s.nombre_sucursal ASC
    `;
    return executeQuery(query, [idEmpresa]);
  }

  /**
   * Create new sucursal with direccion
   */
  static async create(sucursalData) {
    return executeTransaction(async (connection) => {
      // First, create the direccion
      const direccionQuery = `
        INSERT INTO direccion (
          calle_principal, calle_secundaria, numero, ciudad, provincia_estado,
          codigo_postal, pais, latitud, longitud, referencia
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      const direccionParams = [
        sucursalData.calle_principal,
        sucursalData.calle_secundaria || null,
        sucursalData.numero || null,
        sucursalData.ciudad,
        sucursalData.provincia_estado,
        sucursalData.codigo_postal || null,
        sucursalData.pais || 'Ecuador',
        sucursalData.latitud || null,
        sucursalData.longitud || null,
        sucursalData.referencia || null
      ];
      const [direccionResult] = await connection.query(direccionQuery, direccionParams);
      const idDireccion = direccionResult.insertId;

      // Then, create the sucursal
      const sucursalQuery = `
        INSERT INTO sucursal (
          id_empresa, id_direccion, nombre_sucursal, telefono, estado
        )
        VALUES (?, ?, ?, ?, ?)
      `;
      const sucursalParams = [
        sucursalData.id_empresa,
        idDireccion,
        sucursalData.nombre_sucursal,
        sucursalData.telefono || null,
        sucursalData.estado || 'activa'
      ];
      const [sucursalResult] = await connection.query(sucursalQuery, sucursalParams);

      return sucursalResult.insertId;
    });
  }

  /**
   * Update sucursal
   */
  static async update(id, sucursalData) {
    return executeTransaction(async (connection) => {
      // Update sucursal basic info
      const sucursalFields = [];
      const sucursalParams = [];

      if (sucursalData.nombre_sucursal !== undefined) {
        sucursalFields.push('nombre_sucursal = ?');
        sucursalParams.push(sucursalData.nombre_sucursal);
      }
      if (sucursalData.telefono !== undefined) {
        sucursalFields.push('telefono = ?');
        sucursalParams.push(sucursalData.telefono);
      }
      if (sucursalData.estado !== undefined) {
        sucursalFields.push('estado = ?');
        sucursalParams.push(sucursalData.estado);
      }

      if (sucursalFields.length > 0) {
        sucursalParams.push(id);
        const sucursalQuery = `UPDATE sucursal SET ${sucursalFields.join(', ')} WHERE id_sucursal = ?`;
        await connection.query(sucursalQuery, sucursalParams);
      }

      // Update direccion if direccion data provided
      const direccionFields = [];
      const direccionParams = [];

      if (sucursalData.calle_principal !== undefined) {
        direccionFields.push('calle_principal = ?');
        direccionParams.push(sucursalData.calle_principal);
      }
      if (sucursalData.calle_secundaria !== undefined) {
        direccionFields.push('calle_secundaria = ?');
        direccionParams.push(sucursalData.calle_secundaria);
      }
      if (sucursalData.numero !== undefined) {
        direccionFields.push('numero = ?');
        direccionParams.push(sucursalData.numero);
      }
      if (sucursalData.ciudad !== undefined) {
        direccionFields.push('ciudad = ?');
        direccionParams.push(sucursalData.ciudad);
      }
      if (sucursalData.provincia_estado !== undefined) {
        direccionFields.push('provincia_estado = ?');
        direccionParams.push(sucursalData.provincia_estado);
      }
      if (sucursalData.codigo_postal !== undefined) {
        direccionFields.push('codigo_postal = ?');
        direccionParams.push(sucursalData.codigo_postal);
      }
      if (sucursalData.pais !== undefined) {
        direccionFields.push('pais = ?');
        direccionParams.push(sucursalData.pais);
      }
      if (sucursalData.latitud !== undefined) {
        direccionFields.push('latitud = ?');
        direccionParams.push(sucursalData.latitud);
      }
      if (sucursalData.longitud !== undefined) {
        direccionFields.push('longitud = ?');
        direccionParams.push(sucursalData.longitud);
      }
      if (sucursalData.referencia !== undefined) {
        direccionFields.push('referencia = ?');
        direccionParams.push(sucursalData.referencia);
      }

      if (direccionFields.length > 0) {
        // Get id_direccion for this sucursal
        const [sucursal] = await connection.query('SELECT id_direccion FROM sucursal WHERE id_sucursal = ?', [id]);
        if (sucursal.length > 0) {
          direccionParams.push(sucursal[0].id_direccion);
          const direccionQuery = `UPDATE direccion SET ${direccionFields.join(', ')} WHERE id_direccion = ?`;
          await connection.query(direccionQuery, direccionParams);
        }
      }

      return true;
    });
  }

  /**
   * Delete sucursal (set to inactive)
   */
  static async delete(id) {
    const query = "UPDATE sucursal SET estado = 'inactiva' WHERE id_sucursal = ?";
    await executeQuery(query, [id]);
    return true;
  }

  /**
   * Reactivate sucursal (set to active)
   */
  static async reactivate(id) {
    const query = "UPDATE sucursal SET estado = 'activa' WHERE id_sucursal = ?";
    await executeQuery(query, [id]);
    return true;
  }

  /**
   * Get servicios for a sucursal
   */
  static async getServicios(idSucursal) {
    const query = `
      SELECT
        s.*,
        ss.disponible,
        ss.precio_sucursal,
        c.nombre as categoria_nombre
      FROM servicio_sucursal ss
      INNER JOIN servicio s ON ss.id_servicio = s.id_servicio
      INNER JOIN categoria_servicio c ON s.id_categoria = c.id_categoria
      WHERE ss.id_sucursal = ?
      ORDER BY s.nombre ASC
    `;
    return executeQuery(query, [idSucursal]);
  }
}

module.exports = Sucursal;
