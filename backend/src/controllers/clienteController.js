const Cliente = require('../models/Cliente');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

const getAllClientes = async (req, res, next) => {
  try {
    const clientes = await Cliente.findAll();
    sendSuccess(res, clientes, 'Clients retrieved successfully');
  } catch (error) {
    next(error);
  }
};

const getClienteById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const cliente = await Cliente.findById(id);
    
    if (!cliente) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Client not found', HTTP_STATUS.NOT_FOUND);
    }
    
    sendSuccess(res, cliente, 'Client details retrieved successfully');
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllClientes,
  getClienteById
};
