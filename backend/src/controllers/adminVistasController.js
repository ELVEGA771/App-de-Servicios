const { executeQuery } = require('../config/database');
const { sendSuccess } = require('../utils/responseFormatter');

const getVistaContrataciones = async (req, res, next) => {
  try {
    const data = await executeQuery('SELECT * FROM vista_contrataciones_detalle ORDER BY fecha_solicitud DESC');
    sendSuccess(res, data);
  } catch (error) {
    next(error);
  }
};

const getVistaEstadisticasEmpresa = async (req, res, next) => {
  try {
    const data = await executeQuery('SELECT * FROM vista_estadisticas_empresa');
    sendSuccess(res, data);
  } catch (error) {
    next(error);
  }
};

const getVistaServicios = async (req, res, next) => {
  try {
    const data = await executeQuery('SELECT * FROM vista_servicios_completos');
    sendSuccess(res, data);
  } catch (error) {
    next(error);
  }
};

const getVistaSucursales = async (req, res, next) => {
  try {
    const data = await executeQuery('SELECT * FROM vista_sucursales_direccion_completa');
    sendSuccess(res, data);
  } catch (error) {
    next(error);
  }
};

const getVistaTopClientes = async (req, res, next) => {
  try {
    const data = await executeQuery('SELECT * FROM vista_top_clientes');
    sendSuccess(res, data);
  } catch (error) {
    next(error);
  }
};

const getIngresosPlataforma = async (req, res, next) => {
  try {
    const query = `
      SELECT SUM(comision_plataforma) as total_ingresos 
      FROM contratacion 
      WHERE comision_plataforma IS NOT NULL
    `;
    const result = await executeQuery(query);
    // result is an array, we want the first element
    const total = result[0]?.total_ingresos || 0;
    sendSuccess(res, { total_ingresos: total });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getVistaContrataciones,
  getVistaEstadisticasEmpresa,
  getVistaServicios,
  getVistaSucursales,
  getVistaTopClientes,
  getIngresosPlataforma
};
