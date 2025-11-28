const { executeQuery } = require('../config/database');

class Calificacion {
  /**
   * Find calificacion by ID
   */
  static async findById(id) {
    const query = 'SELECT * FROM calificacion WHERE id_calificacion = ?';
    const results = await executeQuery(query, [id]);
    return results[0] || null;
  }

  /**
   * Get calificaciones by servicio
   */
  static async getByServicio(idServicio, page = 1, limit = 20) {
    const offset = (page - 1) * limit;
    const query = `
      SELECT
        cal.*,
        CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
        u.foto_perfil_url
      FROM calificacion cal
      INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
      INNER JOIN cliente cli ON con.id_cliente = cli.id_cliente
      INNER JOIN usuario u ON cli.id_usuario = u.id_usuario
      WHERE con.id_servicio = ? AND cal.tipo = 'cliente_a_empresa'
      ORDER BY cal.fecha_calificacion DESC
      LIMIT ? OFFSET ?
    `;
    const results = await executeQuery(query, [idServicio, limit, offset]);

    // Count total
    const countQuery = `
      SELECT COUNT(*) as total
      FROM calificacion cal
      INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
      WHERE con.id_servicio = ? AND cal.tipo = 'cliente_a_empresa'
    `;
    const countResult = await executeQuery(countQuery, [idServicio]);
    const total = countResult[0].total;

    return { data: results, total };
  }

  /**
   * Get calificaciones by empresa
   */
  static async getByEmpresa(idEmpresa, page = 1, limit = 20) {
    const offset = (page - 1) * limit;
    const query = `
      SELECT
        cal.*,
        CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
        u.foto_perfil_url,
        s.nombre as servicio_nombre
      FROM calificacion cal
      INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
      INNER JOIN cliente cli ON con.id_cliente = cli.id_cliente
      INNER JOIN usuario u ON cli.id_usuario = u.id_usuario
      INNER JOIN servicio s ON con.id_servicio = s.id_servicio
      WHERE s.id_empresa = ? AND cal.tipo = 'cliente_a_empresa'
      ORDER BY cal.fecha_calificacion DESC
      LIMIT ? OFFSET ?
    `;
    const results = await executeQuery(query, [idEmpresa, limit, offset]);

    // Count total
    const countQuery = `
      SELECT COUNT(*) as total
      FROM calificacion cal
      INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
      INNER JOIN servicio s ON con.id_servicio = s.id_servicio
      WHERE s.id_empresa = ? AND cal.tipo = 'cliente_a_empresa'
    `;
    const countResult = await executeQuery(countQuery, [idEmpresa]);
    const total = countResult[0].total;

    return { data: results, total };
  }

  /**
   * Create new calificacion (using stored procedure)
   */
  static async create(calificacionData) {
    // Call stored procedure
    // sp_crear_calificacion(p_id_contratacion, p_calificacion, p_comentario, p_id_usuario)
    const query = `
      CALL sp_crear_calificacion(?, ?, ?, ?)
    `;
    const params = [
      calificacionData.id_contratacion,
      calificacionData.calificacion,
      calificacionData.comentario || null
    ];

    await executeQuery(query, params);
    
    // Since the new SP doesn't return the ID via OUT param, we return a success indicator
    return true;
  }

  /**
   * Check if contratacion already rated
   */
  static async isAlreadyRated(idContratacion, tipo) {
    const query = `
      SELECT COUNT(*) as count
      FROM calificacion
      WHERE id_contratacion = ?
    `;
    const results = await executeQuery(query, [idContratacion, tipo]);
    return results[0].count > 0;
  }

  /**
   * Get calificacion promedio by empresa
   */
  static async getPromedioEmpresa(idEmpresa) {
    const query = `
      SELECT AVG(cal.calificacion) as promedio
      FROM calificacion cal
      INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
      INNER JOIN servicio s ON con.id_servicio = s.id_servicio
      WHERE s.id_empresa = ?'
    `;
    const results = await executeQuery(query, [idEmpresa]);
    return parseFloat(results[0].promedio) || 0;
  }

  /**
   * Get pending ratings for a user (cliente)
   */
  static async getPendingByUsuario(idUsuario) {
    const query = `
      SELECT
        c.id_contratacion,
        c.fecha_completada,
        s.nombre as servicio_nombre,
        e.razon_social as empresa_nombre,
        s.imagen_url as imagen_principal
      FROM contratacion c
      INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
      INNER JOIN servicio s ON c.id_servicio = s.id_servicio
      INNER JOIN empresa e ON s.id_empresa = e.id_empresa
      LEFT JOIN calificacion cal ON c.id_contratacion = cal.id_contratacion AND cal.tipo = 'cliente_a_empresa'
      WHERE cli.id_usuario = ?
        AND c.estado = 'completado'
        AND cal.id_calificacion IS NULL
      ORDER BY c.fecha_completada DESC
    `;
    const results = await executeQuery(query, [idUsuario]);
    return results;
  }
}

module.exports = Calificacion;
