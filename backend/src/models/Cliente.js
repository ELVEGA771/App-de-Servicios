const { executeQuery } = require('../config/database');

class Cliente {
  /**
   * Find cliente by ID
   */
  static async findById(id) {
    const query = `
      SELECT c.*, u.*
      FROM cliente c
      INNER JOIN usuario u ON c.id_usuario = u.id_usuario
      WHERE c.id_cliente = ?
    `;
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Find cliente by user ID
   */
  static async findByUserId(userId) {
    const query = `
      SELECT c.*, u.*
      FROM cliente c
      INNER JOIN usuario u ON c.id_usuario = u.id_usuario
      WHERE c.id_usuario = ?
    `;
    const results = await executeQuery(query, [userId]);
    return results[0] || null;
  }

  /**
   * Create new cliente
   */
  static async create(clienteData) {
    const query = `
      INSERT INTO cliente (id_usuario, fecha_nacimiento)
      VALUES (?, ?)
    `;
    const params = [
      clienteData.id_usuario,
      clienteData.fecha_nacimiento || null
    ];
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Update cliente
   */
  static async update(id, clienteData) {
    const query = `
      UPDATE cliente
      SET fecha_nacimiento = ?
      WHERE id_cliente = ?
    `;
    await executeQuery(query, [clienteData.fecha_nacimiento, id]);
    return this.findById(id);
  }

  /**
   * Get cliente addresses
   */
  static async getAddresses(idCliente) {
    const query = `
      SELECT
        d.*,
        dc.alias,
        dc.es_principal
      FROM direcciones_del_cliente dc
      INNER JOIN direccion d ON dc.id_direccion = d.id_direccion
      WHERE dc.id_cliente = ?
      ORDER BY dc.es_principal DESC, d.id_direccion DESC
    `;
    return executeQuery(query, [idCliente]);
  }

  /**
   * Add address to cliente
   */
  static async addAddress(idCliente, idDireccion, alias, esPrincipal = false) {
    // If setting as principal, unset other principal addresses first
    if (esPrincipal) {
      await executeQuery(
        'UPDATE direcciones_del_cliente SET es_principal = 0 WHERE id_cliente = ?',
        [idCliente]
      );
    }

    const query = `
      INSERT INTO direcciones_del_cliente (id_cliente, id_direccion, alias, es_principal)
      VALUES (?, ?, ?, ?)
    `;
    await executeQuery(query, [idCliente, idDireccion, alias, esPrincipal ? 1 : 0]);
    return true;
  }

  /**
   * Remove address from cliente
   */
  static async removeAddress(idCliente, idDireccion) {
    const query = `
      DELETE FROM direcciones_del_cliente
      WHERE id_cliente = ? AND id_direccion = ?
    `;
    await executeQuery(query, [idCliente, idDireccion]);
    return true;
  }

  /**
   * Set principal address (using stored procedure)
   */
  static async setPrincipalAddress(idCliente, idDireccion) {
    // Call stored procedure
    const query = 'CALL sp_establecer_direccion_principal(?, ?, @out_mensaje)';
    await executeQuery(query, [idCliente, idDireccion]);

    // Get output message
    const resultQuery = 'SELECT @out_mensaje as mensaje';
    const results = await executeQuery(resultQuery);

    return true;
  }

  /**
   * Get principal address
   */
  static async getPrincipalAddress(idCliente) {
    const query = `
      SELECT d.*, dc.alias
      FROM direcciones_del_cliente dc
      INNER JOIN direccion d ON dc.id_direccion = d.id_direccion
      WHERE dc.id_cliente = ? AND dc.es_principal = 1
    `;
    const results = await executeQuery(query, [idCliente]);
    return results[0] || null;
  }

  /**
   * Update address relation (alias, es_principal)
   */
  static async updateAddressRelation(idCliente, idDireccion, alias, esPrincipal) {
    const fields = [];
    const params = [];

    if (alias !== undefined) {
      fields.push('alias = ?');
      params.push(alias);
    }
    
    // es_principal is usually handled by setPrincipalAddress to ensure only one is principal
    // but if we are just updating the alias, we might not touch es_principal
    // If es_principal is passed and is true, we should probably call setPrincipalAddress instead or as well.

    if (fields.length > 0) {
      params.push(idCliente);
      params.push(idDireccion);
      const query = `UPDATE direcciones_del_cliente SET ${fields.join(', ')} WHERE id_cliente = ? AND id_direccion = ?`;
      await executeQuery(query, params);
    }
    
    if (esPrincipal === true) {
        await this.setPrincipalAddress(idCliente, idDireccion);
    }
    
    return true;
  }
}

module.exports = Cliente;
