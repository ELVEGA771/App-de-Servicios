const Cupon = require('../models/Cupon');
const Empresa = require('../models/Empresa');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES } = require('../utils/constants');

const getCuponesByEmpresa = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can access this', HTTP_STATUS.FORBIDDEN);
    }
    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    const cupones = await Cupon.getByEmpresa(empresa.id_empresa);
    sendSuccess(res, cupones);
  } catch (error) {
    next(error);
  }
};

const getActiveCupones = async (req, res, next) => {
  try {
    const cupones = await Cupon.getActive();
    sendSuccess(res, cupones);
  } catch (error) {
    next(error);
  }
};

const createCupon = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can create coupons', HTTP_STATUS.FORBIDDEN);
    }
    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    const cuponData = { ...req.body, id_empresa: empresa.id_empresa };
    const cuponId = await Cupon.create(cuponData);
    const cupon = await Cupon.findById(cuponId);
    sendSuccess(res, cupon, 'Coupon created successfully', HTTP_STATUS.CREATED);
  } catch (error) {
    next(error);
  }
};

const updateCupon = async (req, res, next) => {
  try {
    const { id } = req.params;
    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    const cupon = await Cupon.findById(id);
    if (!cupon || cupon.id_empresa !== empresa.id_empresa) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Unauthorized', HTTP_STATUS.FORBIDDEN);
    }
    const updated = await Cupon.update(id, req.body);
    sendSuccess(res, updated, 'Coupon updated successfully');
  } catch (error) {
    next(error);
  }
};

const validateCupon = async (req, res, next) => {
  try {
    const { codigo, id_servicio, monto_compra } = req.body;
    const result = await Cupon.validate(codigo, id_servicio, monto_compra);
    sendSuccess(res, result);
  } catch (error) {
    next(error);
  }
};

module.exports = { getCuponesByEmpresa, getActiveCupones, createCupon, updateCupon, validateCupon };
