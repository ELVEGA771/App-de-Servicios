const express = require('express');
const router = express.Router();
const upload = require('../middleware/uploadMiddleware');
const { uploadImage } = require('../controllers/uploadController');
const authMiddleware = require('../middleware/authMiddleware');

// Endpoint: POST /api/upload
// 'imagen' is the field name expected in FormData
router.post('/', authMiddleware, upload.single('imagen'), uploadImage);

module.exports = router;