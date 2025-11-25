const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const { sendSuccess, sendError } = require('../utils/responseFormatter');

// 1. Configuración de dónde y cómo se guardan los archivos
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

// 2. Filtro para aceptar solo imágenes
const fileFilter = (req, file, cb) => {
  if (file.mimetype.startsWith('image/')) {
    cb(null, true);
  } else {
    cb(new Error('El archivo no es una imagen'), false);
  }
};

const upload = multer({ 
  storage: storage,
  fileFilter: fileFilter,
  limits: { fileSize: 5 * 1024 * 1024 } 
});

// Ruta POST principal
router.post('/', upload.single('imagen'), (req, res) => {
  try {
    if (!req.file) {
      return sendError(res, 'UPLOAD_ERROR', 'No se ha subido ningún archivo', 400);
    }

    const protocol = req.protocol;
    const host = req.get('host');
    const fileUrl = `${protocol}://${host}/uploads/${req.file.filename}`;

    sendSuccess(res, { url: fileUrl }, 'Imagen subida correctamente');
  } catch (error) {
    sendError(res, 'INTERNAL_ERROR', error.message, 500);
  }
});

module.exports = router;