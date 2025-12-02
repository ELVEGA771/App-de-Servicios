const { executeQuery, executeTransaction } = require('../config/database');

class Usuario {
  /**
   * Find user by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM usuario WHERE id_usuario = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Find user by email
   */
  static async findByEmail(email) {
    const query = 'SELECT * FROM usuario WHERE email = ?';
    const results = await executeQuery(query, [email]);
    return results[0] || null;
  }

  /**
   * Create new user
   */
  static async create(userData) {
    return executeTransaction(async (connection) => {
      const query = `
        INSERT INTO usuario (email, password_hash, nombre, apellido, telefono, tipo_usuario, foto_perfil_url)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `;
      const params = [
        userData.email,
        userData.password_hash,
        userData.nombre,
        userData.apellido,
        userData.telefono || null,
        userData.tipo_usuario,
        userData.foto_perfil_url || null
      ];
      const result = await executeQuery(query, params, connection);
      return result.insertId;
    });
  }

  /**
   * Update user
   */
  static async update(id, userData) {
    return executeTransaction(async (connection) => {
      const fields = [];
      const params = [];

      if (userData.nombre !== undefined) {
        fields.push('nombre = ?');
        params.push(userData.nombre);
      }
      if (userData.apellido !== undefined) {
        fields.push('apellido = ?');
        params.push(userData.apellido);
      }
      if (userData.telefono !== undefined) {
        fields.push('telefono = ?');
        params.push(userData.telefono);
      }
      if (userData.foto_perfil_url !== undefined) {
        fields.push('foto_perfil_url = ?');
        params.push(userData.foto_perfil_url);
      }
      if (userData.estado !== undefined) {
        fields.push('estado = ?');
        params.push(userData.estado);
      }

      if (fields.length === 0) return null;

      params.push(id);
      const query = `UPDATE usuario SET ${fields.join(', ')} WHERE id_usuario = ?`;
      await executeQuery(query, params, connection);
      
      // Para devolver el usuario actualizado, necesitamos hacer la consulta dentro de la transacción
      // o fuera. Si es dentro, usamos la conexión.
      const findQuery = 'SELECT * FROM usuario WHERE id_usuario = ?';
      const results = await executeQuery(findQuery, [id], connection);
      return results[0] || null;
    });
  }

  /**
   * Update password
   */
  static async updatePassword(id, newPasswordHash) {
    return executeTransaction(async (connection) => {
      const query = 'UPDATE usuario SET password_hash = ? WHERE id_usuario = ?';
      await executeQuery(query, [newPasswordHash, id], connection);
      return true;
    });
  }

  /**
   * Delete user
   */
  static async delete(id) {
    return executeTransaction(async (connection) => {
      const query = 'DELETE FROM usuario WHERE id_usuario = ?';
      await executeQuery(query, [id], connection);
      return true;
    });
  }

  /**
   * Check if email exists
   */
  static async emailExists(email, excludeId = null) {
    let query = 'SELECT COUNT(*) as count FROM usuario WHERE email = ?';
    const params = [email];

    if (excludeId) {
      query += ' AND id_usuario != ?';
      params.push(excludeId);
    }

    const results = await executeQuery(query, params);
    return results[0].count > 0;
  }
}

module.exports = Usuario;
