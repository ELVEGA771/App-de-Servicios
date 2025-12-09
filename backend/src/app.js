const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const dotenv = require('dotenv');
const setupSwagger = require('./config/swagger');
const { rateLimiterMiddleware } = require('./middleware/rateLimiter');
const { errorHandler, notFoundHandler } = require('./middleware/errorHandler');
const logger = require('./utils/logger');
const path = require('path');

// Load environment variables
dotenv.config();

// Create Express app
const app = express();

// Security middleware
app.use(helmet());

// CORS configuration
const corsOptions = {
  origin: true, // Permite todos los orígenes en desarrollo
  credentials: true,
  optionsSuccessStatus: 200
};
app.use(cors(corsOptions));

// Compression middleware
app.use(compression());

// Body parser middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// HTTP request logger
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined', {
    stream: {
      write: (message) => logger.info(message.trim())
    }
  }));
}

// Rate limiting
app.use(rateLimiterMiddleware);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// API Routes
const authRoutes = require('./routes/authRoutes');
const servicioRoutes = require('./routes/servicioRoutes');
const contratacionRoutes = require('./routes/contratacionRoutes');
const cuponRoutes = require('./routes/cuponRoutes');
const direccionRoutes = require('./routes/direccionRoutes');
const favoritoRoutes = require('./routes/favoritoRoutes');
const conversacionRoutes = require('./routes/conversacionRoutes');
const calificacionRoutes = require('./routes/calificacionRoutes');
const empresaRoutes = require('./routes/empresaRoutes');
const categoriaRoutes = require('./routes/categoriaRoutes');
const notificacionRoutes = require('./routes/notificacionRoutes');
const sucursalRoutes = require('./routes/sucursalRoutes');
const clienteRoutes = require('./routes/clienteRoutes');
const adminRoutes = require('./routes/adminRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/servicios', servicioRoutes);
app.use('/api/contrataciones', contratacionRoutes);
app.use('/api/cupones', cuponRoutes);
app.use('/api/direcciones', direccionRoutes);
app.use('/api/favoritos', favoritoRoutes);
app.use('/api/conversaciones', conversacionRoutes);
app.use('/api/calificaciones', calificacionRoutes);
app.use('/api/empresas', empresaRoutes);
app.use('/api/categorias', categoriaRoutes);
app.use('/api/notificaciones', notificacionRoutes);
app.use('/api/sucursales', sucursalRoutes);
app.use('/api/clientes', clienteRoutes);
app.use('/api/admin', adminRoutes);

const chatbotRoutes = require('./routes/chatbotRoutes');
app.use('/api/chatbot', chatbotRoutes);

const uploadRoutes = require('./routes/uploadRoutes'); // Importar
app.use('/api/upload', uploadRoutes);

// Swagger documentation
setupSwagger(app);

// Welcome route
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Servicios App API',
    version: '1.0.0',
    documentation: '/api-docs',
    health: '/health'
  });
});

// 404 handler
app.use(notFoundHandler);

// Error handler (must be last)
app.use(errorHandler);

module.exports = app;
