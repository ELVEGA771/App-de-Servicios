const OpenAI = require('openai');
const Servicio = require('../models/Servicio');
const { sendSuccess, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS } = require('../utils/constants');
const logger = require('../utils/logger');

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

/**
 * Chat with the AI assistant to find services
 * POST /api/chatbot/chat
 */
const chat = async (req, res, next) => {
  try {
    const { message, history = [] } = req.body;

    if (!message) {
      return sendError(res, ERROR_CODES.VALIDATION_ERROR, 'Message is required', HTTP_STATUS.BAD_REQUEST);
    }

    if (!process.env.OPENAI_API_KEY) {
      return sendError(res, ERROR_CODES.SERVER_ERROR, 'OpenAI API key is not configured', HTTP_STATUS.INTERNAL_SERVER_ERROR);
    }

    // Fetch available services to provide context
    // We'll fetch a larger number of services to ensure we have good coverage
    // In a production app with thousands of services, we would use a vector database (RAG)
    // instead of passing all services in the context.
    const servicesResult = await Servicio.getAll(1, 100, { estado: 'disponible' });
    const services = servicesResult.data.map(s => ({
      id: s.id_servicio,
      nombre: s.servicio_nombre,
      descripcion: s.descripcion,
      categoria: s.categoria_nombre,
      precio: s.precio_base,
      empresa: s.empresa_nombre
    }));

    const systemPrompt = `
      You are a helpful and knowledgeable assistant for a service marketplace app called "App de Servicios".
      Your goal is to help users find the best service for their specific needs based on the available services.
      
      Here is the list of currently available services in JSON format:
      ${JSON.stringify(services)}

      Instructions:
      1. Analyze the user's request carefully.
      2. Search through the available services to find matches based on keywords, categories, and descriptions.
      3. If you find relevant services, recommend them.
      4. If the user's request is vague, ask clarifying questions.
      5. If no services match, politely inform the user and suggest alternatives if possible.
      6. Your response MUST be a valid JSON object with the following structure:
      {
        "message": "Your conversational response to the user here. Be friendly and helpful. Use emojis if appropriate.",
        "recommended_services": [1, 2] // Array of service IDs that match the request. Empty if none.
      }
      7. Do not include any text outside the JSON object.
    `;

    // Construct messages array with history
    const messages = [
      { role: "system", content: systemPrompt },
      ...history.map(msg => ({ role: msg.role, content: msg.content })), // Sanitize history
      { role: "user", content: message }
    ];

    const completion = await openai.chat.completions.create({
      messages: messages,
      model: "gpt-3.5-turbo", // Or gpt-4 if available and preferred
      response_format: { type: "json_object" },
    });

    const aiResponse = JSON.parse(completion.choices[0].message.content);

    // If we have recommended services, let's fetch their full details to return to the frontend
    let recommendedServicesDetails = [];
    if (aiResponse.recommended_services && aiResponse.recommended_services.length > 0) {
      // We can filter from the already fetched services to save a DB call
      recommendedServicesDetails = servicesResult.data.filter(s => 
        aiResponse.recommended_services.includes(s.id_servicio)
      );
    }

    sendSuccess(res, {
      message: aiResponse.message,
      services: recommendedServicesDetails
    });

  } catch (error) {
    logger.error('Chatbot error:', error);
    next(error);
  }
};

module.exports = {
  chat
};
