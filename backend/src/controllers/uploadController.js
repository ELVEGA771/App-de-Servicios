const { sendSuccess, sendError } = require('../utils/responseFormatter');

const uploadImage = (req, res) => {
    if (!req.file) {
        return sendError(res, 'UPLOAD_ERROR', 'No image provided', 400);
    }

    // Cloudinary returns the URL in req.file.path
    sendSuccess(res, {
        url: req.file.path,
        public_id: req.file.filename
    }, 'Image uploaded successfully');
};

module.exports = { uploadImage };
