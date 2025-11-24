const Favorito = require('../models/Favorito');
const Cliente = require('../models/Cliente');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');

const getFavoritos = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const favoritos = await Favorito.getByCliente(cliente.id_cliente);
    sendSuccess(res, favoritos);
  } catch (error) { next(error); }
};

const addFavorito = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const { id_servicio } = req.body;
    await Favorito.add(cliente.id_cliente, id_servicio);
    sendSuccess(res, null, 'Added to favorites', 201);
  } catch (error) { next(error); }
};

const removeFavorito = async (req, res, next) => {
  try {
    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    const { id } = req.params;
    await Favorito.remove(cliente.id_cliente, id);
    sendSuccess(res, null, 'Removed from favorites');
  } catch (error) { next(error); }
};

module.exports = { getFavoritos, addFavorito, removeFavorito };
