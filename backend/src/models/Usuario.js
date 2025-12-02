const { executeQuery } = require('../config/database');

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
    const result = await executeQuery(query, params);
    return result.insertId;
  }

  /**
   * Update user
   */
  static async update(id, userData) {
    const fields = [];
    const params = [];

    params.push(id);

    if (userData.nombre !== undefined) {
      params.push(userData.nombre);
    }else {
      params.push(null);
    }
    if (userData.apellido !== undefined) {
      params.push(userData.apellido);
    }else {
      params.push(null);
    }
    if (userData.telefono !== undefined) {
      params.push(userData.telefono);
    }else {
      params.push(null);
    }
    if (userData.foto_perfil_url !== undefined) {
      params.push(userData.foto_perfil_url);
    }else {
      params.push(null);
    }
    if (userData.estado !== undefined) {
      params.push(userData.estado);
    }else {
      params.push(null);
    }

    const query = `CALL sp_actualizar_usuario(?, ?, ?, ?, ?, ?, @mensaje)`;
    await executeQuery(query, params);
    return this.findById(id);
  }

  /**
   * Update password
   */
  static async updatePassword(id, newPasswordHash) {
    const query = 'UPDATE usuario SET password_hash = ? WHERE id_usuario = ?';
    await executeQuery(query, [newPasswordHash, id]);
    return true;
  }

  /**
   * Delete user
   */
  static async delete(id) {
    const query = 'DELETE FROM usuario WHERE id_usuario = ?';
    await executeQuery(query, [id]);
    return true;
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
