const { executeQuery, executeTransaction } = require('../config/database');

class Cliente {
  /**
   * Find all clients
   */
  static async findAll() {
    const query = `
      SELECT c.*, u.email, u.nombre, u.apellido, u.telefono, u.foto_perfil_url, u.estado, u.fecha_registro
      FROM cliente c
      INNER JOIN usuario u ON c.id_usuario = u.id_usuario
      ORDER BY u.fecha_registro DESC
    `;
    return executeQuery(query);
  }

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
    return executeTransaction(async (connection) => {
      const query = `
        INSERT INTO cliente (id_usuario)
        VALUES (?)
      `;
      const params = [
        clienteData.id_usuario
      ];
      const result = await executeQuery(query, params, connection);
      return result.insertId;
    });
  }

  /**
   * Update cliente
   */
  static async update(id, clienteData) {
    return executeTransaction(async (connection) => {
      const fields = [];
      const params = [];

      if (clienteData.foto_perfil_url !== undefined) {
        fields.push('foto_perfil_url = ?');
        params.push(clienteData.foto_perfil_url);
      }

      if (fields.length === 0) {
        // Reuse findById logic but inside transaction if needed, or just call it.
        // Since findById is read-only, we can call it directly or replicate query.
        // To be safe and consistent, let's replicate the query or call findById (which uses a new connection if not passed).
        // But executeTransaction passes a connection. findById doesn't accept connection param currently.
        // Let's just return null or fetch fresh data.
        const query = `
          SELECT c.*, u.*
          FROM cliente c
          INNER JOIN usuario u ON c.id_usuario = u.id_usuario
          WHERE c.id_cliente = ?
        `;
        const results = await executeQuery(query, [id], connection);
        return results[0] || null;
      }

      params.push(id);
      const query = `UPDATE cliente SET ${fields.join(', ')} WHERE id_cliente = ?`;
      await executeQuery(query, params, connection);
      
      const findQuery = `
        SELECT c.*, u.*
        FROM cliente c
        INNER JOIN usuario u ON c.id_usuario = u.id_usuario
        WHERE c.id_cliente = ?
      `;
      const results = await executeQuery(findQuery, [id], connection);
      return results[0] || null;
    });
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
    return executeTransaction(async (connection) => {
      // If setting as principal, unset other principal addresses first
      if (esPrincipal) {
        await executeQuery(
          'UPDATE direcciones_del_cliente SET es_principal = 0 WHERE id_cliente = ?',
          [idCliente],
          connection
        );
      }

      const query = `
        INSERT INTO direcciones_del_cliente (id_cliente, id_direccion, alias, es_principal)
        VALUES (?, ?, ?, ?)
      `;
      await executeQuery(query, [idCliente, idDireccion, alias, esPrincipal ? 1 : 0], connection);
      return true;
    });
  }

  /**
   * Remove address from cliente
   */
  static async removeAddress(idCliente, idDireccion) {
    return executeTransaction(async (connection) => {
      const query = `
        DELETE FROM direcciones_del_cliente
        WHERE id_cliente = ? AND id_direccion = ?
      `;
      await executeQuery(query, [idCliente, idDireccion], connection);
      return true;
    });
  }

  /**
   * Set principal address (using stored procedure)
   */
  static async setPrincipalAddress(idCliente, idDireccion) {
    // Call stored procedure
    // SPs are usually atomic, but we can wrap it if we want consistent interface
    return executeTransaction(async (connection) => {
        const query = 'CALL sp_establecer_direccion_principal(?, ?, @out_mensaje)';
        await executeQuery(query, [idCliente, idDireccion], connection);

        // Get output message
        const resultQuery = 'SELECT @out_mensaje as mensaje';
        const results = await executeQuery(resultQuery, [], connection);
        return true;
    });
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
    return executeTransaction(async (connection) => {
      const fields = [];
      const params = [];

      if (alias !== undefined) {
        fields.push('alias = ?');
        params.push(alias);
      }
      
      if (fields.length > 0) {
        params.push(idCliente);
        params.push(idDireccion);
        const query = `UPDATE direcciones_del_cliente SET ${fields.join(', ')} WHERE id_cliente = ? AND id_direccion = ?`;
        await executeQuery(query, params, connection);
      }
      
      if (esPrincipal === true) {
          // We can call the SP inside the transaction too
          const query = 'CALL sp_establecer_direccion_principal(?, ?, @out_mensaje)';
          await executeQuery(query, [idCliente, idDireccion], connection);
      }
      
      return true;
    });
  }
}

module.exports = Cliente;
