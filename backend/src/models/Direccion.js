const { executeQuery, executeTransaction } = require('../config/database');

class Direccion {
  /**
   * Find direccion by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM direccion WHERE id_direccion = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Create new direccion
   */
  static async create(direccionData) {
    return executeTransaction(async (connection) => {
      // Construct numero from exterior/interior
      const numero = direccionData.numero || 
        (direccionData.numero_interior 
          ? `${direccionData.numero_exterior} Int. ${direccionData.numero_interior}`
          : direccionData.numero_exterior);

      const query = `
        INSERT INTO direccion (
          calle_principal, calle_secundaria, numero, ciudad, provincia_estado,
          codigo_postal, pais, referencia
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `;
      const params = [
        direccionData.calle_principal,
        direccionData.calle_secundaria || null,
        numero || null,
        direccionData.ciudad,
        direccionData.provincia_estado || direccionData.estado,
        direccionData.codigo_postal || null,
        direccionData.pais || 'Ecuador',
        direccionData.referencia || null
      ];
      const result = await executeQuery(query, params, connection);
      return result.insertId;
    });
  }

  /**
   * Update direccion
   */
  static async update(id, direccionData) {
    return executeTransaction(async (connection) => {
      const fields = [];
      const params = [];

      if (direccionData.calle_principal !== undefined) {
        fields.push('calle_principal = ?');
        params.push(direccionData.calle_principal);
      }
      if (direccionData.calle_secundaria !== undefined) {
        fields.push('calle_secundaria = ?');
        params.push(direccionData.calle_secundaria);
      }
      if (direccionData.numero !== undefined) {
        fields.push('numero = ?');
        params.push(direccionData.numero);
      }
      if (direccionData.ciudad !== undefined) {
        fields.push('ciudad = ?');
        params.push(direccionData.ciudad);
      }
      if (direccionData.provincia_estado !== undefined) {
        fields.push('provincia_estado = ?');
        params.push(direccionData.provincia_estado);
      }
      if (direccionData.codigo_postal !== undefined) {
        fields.push('codigo_postal = ?');
        params.push(direccionData.codigo_postal);
      }
      if (direccionData.pais !== undefined) {
        fields.push('pais = ?');
        params.push(direccionData.pais);
      }
      if (direccionData.referencia !== undefined) {
        fields.push('referencia = ?');
        params.push(direccionData.referencia);
      }

      if (fields.length === 0) return null;

      params.push(id);
      const query = `UPDATE direccion SET ${fields.join(', ')} WHERE id_direccion = ?`;
      await executeQuery(query, params, connection);
      
      const findQuery = 'SELECT * FROM direccion WHERE id_direccion = ?';
      const results = await executeQuery(findQuery, [id], connection);
      return results[0] || null;
    });
  }

  /**
   * Delete direccion
   */
  static async delete(id) {
    return executeTransaction(async (connection) => {
      const query = 'DELETE FROM direccion WHERE id_direccion = ?';
      await executeQuery(query, [id], connection);
      return true;
    });
  }

  /**
   * Check if direccion is in use
   */
  static async isInUse(id) {
    const queries = [
      'SELECT COUNT(*) as count FROM direcciones_del_cliente WHERE id_direccion = ?',
      'SELECT COUNT(*) as count FROM sucursal WHERE id_direccion = ?',
      'SELECT COUNT(*) as count FROM contratacion WHERE id_direccion_entrega = ?'
    ];

    for (const query of queries) {
      const results = await executeQuery(query, [id]);
      if (results[0].count > 0) return true;
    }

    return false;
  }
}

module.exports = Direccion;
