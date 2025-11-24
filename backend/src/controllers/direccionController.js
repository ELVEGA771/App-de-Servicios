const Direccion = require('../models/Direccion');
const Cliente = require('../models/Cliente');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES } = require('../utils/constants');

const getDirecciones = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const direcciones = await Cliente.getAddresses(cliente.id_cliente);
    sendSuccess(res, direcciones);
  } catch (error) { next(error); }
};

const createDireccion = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const dirId = await Direccion.create(req.body);
    await Cliente.addAddress(cliente.id_cliente, dirId, req.body.alias, req.body.es_principal);
    const dir = await Direccion.findById(dirId);
    sendSuccess(res, dir, 'Address created', 201);
  } catch (error) { next(error); }
};

const updateDireccion = async (req, res, next) => {
  try {
    const updated = await Direccion.update(req.params.id, req.body);
    sendSuccess(res, updated);
  } catch (error) { next(error); }
};

const deleteDireccion = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    await Cliente.removeAddress(cliente.id_cliente, req.params.id);
    sendSuccess(res, null, 'Address deleted');
  } catch (error) { next(error); }
};

const setPrincipal = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    await Cliente.setPrincipalAddress(cliente.id_cliente, req.params.id);
    sendSuccess(res, null, 'Principal address updated');
  } catch (error) { next(error); }
};

module.exports = { getDirecciones, createDireccion, updateDireccion, deleteDireccion, setPrincipal };
