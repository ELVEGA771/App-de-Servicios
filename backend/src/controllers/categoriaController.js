const Categoria = require('../models/Categoria');
const { sendSuccess } = require('../utils/responseFormatter');

const getAllCategorias = async (req, res, next) => {
  try {
    const categorias = await Categoria.getAll();
    sendSuccess(res, categorias);
  } catch (error) { next(error); }
};

const getCategoriaById = async (req, res, next) => {
  try {
    const categoria = await Categoria.findById(req.params.id);
    sendSuccess(res, categoria);
  } catch (error) { next(error); }
};

module.exports = { getAllCategorias, getCategoriaById };
