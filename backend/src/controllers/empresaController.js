const Empresa = require('../models/Empresa');
const { sendSuccess, sendPaginated } = require('../utils/responseFormatter');

const getAllEmpresas = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, ...filters } = req.query;
    const result = await Empresa.getAll(page, limit, filters);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

const getEmpresaById = async (req, res, next) => {
  try {
    const empresa = await Empresa.findById(req.params.id);
    sendSuccess(res, empresa);
  } catch (error) { next(error); }
};

const getEmpresaStats = async (req, res, next) => {
  try {
    const stats = await Empresa.getStatistics(req.params.id);
    sendSuccess(res, stats);
  } catch (error) { next(error); }
};

const getIncomeDetails = async (req, res, next) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const result = await Empresa.getIncomeDetails(req.params.id, page, limit);
    sendPaginated(res, result.data, page, limit, result.total);
  } catch (error) { next(error); }
};

module.exports = { getAllEmpresas, getEmpresaById, getEmpresaStats, getIncomeDetails };
