const express = require('express');
const router = express.Router();
const chatbotController = require('../controllers/chatbotController');
const authMiddleware = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

/**
 * @swagger
 * tags:
 *   name: Chatbot
 *   description: AI Assistant for service recommendations
 */

/**
 * @swagger
 * /api/chatbot/chat:
 *   post:
 *     summary: Chat with the AI assistant
 *     tags: [Chatbot]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - message
 *             properties:
 *               message:
 *                 type: string
 *                 description: The user's message or query
 *               history:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     role:
 *                       type: string
 *                       enum: [user, assistant]
 *                     content:
 *                       type: string
 *                 description: Previous chat history for context
 *     responses:
 *       200:
 *         description: AI response with recommendations
 */
router.post('/chat',
  authMiddleware, // Optional: Require login to use the chatbot? Usually yes for rate limiting/tracking.
  asyncHandler(chatbotController.chat)
);

module.exports = router;
