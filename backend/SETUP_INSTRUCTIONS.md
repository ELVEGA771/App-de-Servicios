# 🚀 Instrucciones de Configuración - Backend Servicios App

## ✅ Estado Actual del Proyecto

### Archivos Generados (Backend Funcional Básico)

#### 1. Configuración Base ✅
- `package.json` - Dependencias y scripts
- `.env.example` - Template de variables de entorno
- `.gitignore` - Archivos a ignorar en Git
- `server.js` - Punto de entrada del servidor
- `src/app.js` - Configuración de Express

#### 2. Configuración del Sistema ✅
- `src/config/database.js` - Pool de conexiones MySQL
- `src/config/jwt.js` - Manejo de JWT tokens
- `src/config/swagger.js` - Documentación Swagger

#### 3. Utilidades ✅
- `src/utils/constants.js` - Constantes del sistema
- `src/utils/logger.js` - Sistema de logs con Winston
- `src/utils/responseFormatter.js` - Formato estandarizado de respuestas

#### 4. Modelos de Datos (13 Modelos) ✅
- `src/models/Usuario.js`
- `src/models/Cliente.js`
- `src/models/Empresa.js`
- `src/models/Servicio.js`
- `src/models/Categoria.js`
- `src/models/Contratacion.js`
- `src/models/Cupon.js`
- `src/models/Direccion.js`
- `src/models/Calificacion.js`
- `src/models/Favorito.js`
- `src/models/Conversacion.js`
- `src/models/Mensaje.js`
- `src/models/Notificacion.js`

#### 5. Middleware ✅
- `src/middleware/authMiddleware.js` - Autenticación JWT
- `src/middleware/roleMiddleware.js` - Verificación de roles
- `src/middleware/errorHandler.js` - Manejo de errores
- `src/middleware/rateLimiter.js` - Rate limiting
- `src/middleware/validator.js` - Validación de requests

#### 6. Controladores y Rutas ✅ (Autenticación)
- `src/controllers/authController.js` - Controlador de autenticación
- `src/validators/authValidator.js` - Validaciones de auth
- `src/routes/authRoutes.js` - Rutas de autenticación

#### 7. Documentación ✅
- `README.md` - Documentación completa
- `Servicios_App.postman_collection.json` - Colección de Postman

---

## 📋 Pasos para Poner en Marcha el Backend

### Paso 1: Instalar Dependencias

```bash
cd backend
npm install
```

### Paso 2: Configurar MySQL

1. **Iniciar MySQL:**
   ```bash
   mysql.server start  # macOS
   # O iniciar desde tu gestor de MySQL
   ```

2. **Crear la base de datos:**
   ```bash
   mysql -u root -p < ../BASEVERSIONFINAL1.sql
   ```

### Paso 3: Configurar Variables de Entorno

1. **Copiar el archivo de ejemplo:**
   ```bash
   cp .env.example .env
   ```

2. **Editar `.env` con tus credenciales:**
   ```env
   # Asegúrate de cambiar estos valores:
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=TU_PASSWORD_MYSQL
   DB_NAME=app_servicios

   # Genera secretos seguros para JWT:
   JWT_SECRET=$(openssl rand -base64 32)
   JWT_REFRESH_SECRET=$(openssl rand -base64 32)
   ```

### Paso 4: Iniciar el Servidor

```bash
# Desarrollo (con auto-reload):
npm run dev

# Producción:
npm start
```

### Paso 5: Verificar que Funciona

1. **Health Check:**
   ```bash
   curl http://localhost:3000/health
   ```

2. **Ver documentación:**
   - Abrir navegador: http://localhost:3000/api-docs

3. **Probar registro:**
   ```bash
   curl -X POST http://localhost:3000/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "Password123",
       "nombre": "Test",
       "apellido": "User",
       "tipo_usuario": "cliente"
     }'
   ```

---

## 📝 Lo que Falta Implementar

Para tener el backend 100% completo según las especificaciones, faltan:

### Controllers a Crear:
1. `src/controllers/servicioController.js` - CRUD de servicios
2. `src/controllers/contratacionController.js` - Gestión de contrataciones
3. `src/controllers/cuponController.js` - Gestión de cupones
4. `src/controllers/direccionController.js` - Gestión de direcciones
5. `src/controllers/favoritoController.js` - Favoritos del cliente
6. `src/controllers/conversacionController.js` - Chat/mensajería
7. `src/controllers/calificacionController.js` - Calificaciones
8. `src/controllers/empresaController.js` - Información de empresas
9. `src/controllers/categoriaController.js` - Categorías de servicios
10. `src/controllers/notificacionController.js` - Notificaciones

### Routes a Crear:
1. `src/routes/servicioRoutes.js`
2. `src/routes/contratacionRoutes.js`
3. `src/routes/cuponRoutes.js`
4. `src/routes/direccionRoutes.js`
5. `src/routes/favoritoRoutes.js`
6. `src/routes/conversacionRoutes.js`
7. `src/routes/calificacionRoutes.js`
8. `src/routes/empresaRoutes.js`
9. `src/routes/categoriaRoutes.js`
10. `src/routes/notificacionRoutes.js`

### Validators a Crear:
- Validadores para cada uno de los controladores anteriores

### Services (Opcional pero Recomendado):
1. `src/services/cuponService.js` - Lógica de validación de cupones
2. `src/services/notificacionService.js` - Lógica de notificaciones
3. `src/services/emailService.js` - Envío de emails

### Tests:
- Tests unitarios para cada controlador y modelo

---

## 🎯 ¿Cómo Completar el Backend?

### Opción 1: Manual
Usar los modelos ya creados como referencia y crear los controladores siguiendo el patrón de `authController.js`

### Opción 2: Automatizada
Puedo generar un script que cree todos los archivos restantes con implementaciones básicas

### Opción 3: Incremental
Ir creando los endpoints uno por uno según prioridad:
1. Servicios (más importante)
2. Contrataciones
3. Cupones
4. Resto de endpoints

---

## 💡 Ejemplo: Cómo Crear un Nuevo Endpoint

### 1. Crear el Controller

```javascript
// src/controllers/servicioController.js
const Servicio = require('../models/Servicio');
const { sendSuccess, sendError } = require('../utils/responseFormatter');

const getAllServicios = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, ...filters } = req.query;
    const result = await Servicio.getAll(page, limit, filters);
    sendSuccess(res, result.data, 'Servicios retrieved successfully');
  } catch (error) {
    next(error);
  }
};

module.exports = { getAllServicios };
```

### 2. Crear el Validator

```javascript
// src/validators/servicioValidator.js
const { body, query } = require('express-validator');

const createServicioValidator = [
  body('nombre').notEmpty().withMessage('Nombre is required'),
  body('precio_base').isFloat({ min: 0 }).withMessage('Invalid price')
];

module.exports = { createServicioValidator };
```

### 3. Crear la Ruta

```javascript
// src/routes/servicioRoutes.js
const express = require('express');
const router = express.Router();
const servicioController = require('../controllers/servicioController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const { asyncHandler } = require('../middleware/errorHandler');

router.get('/', asyncHandler(servicioController.getAllServicios));

module.exports = router;
```

### 4. Registrar en app.js

```javascript
// En src/app.js, agregar:
const servicioRoutes = require('./routes/servicioRoutes');
app.use('/api/servicios', servicioRoutes);
```

---

## 🔧 Troubleshooting

### Error: Cannot connect to MySQL

**Solución:**
1. Verificar que MySQL esté corriendo
2. Revisar credenciales en `.env`
3. Verificar que la base de datos exista

### Error: JWT secret not defined

**Solución:**
- Asegúrate de tener `JWT_SECRET` en tu archivo `.env`

### Error: Port 3000 already in use

**Solución:**
```bash
# Encontrar proceso usando el puerto
lsof -ti:3000

# Matar el proceso
kill -9 $(lsof -ti:3000)

# O cambiar el puerto en .env
PORT=3001
```

---

## 📞 Próximos Pasos

¿Quieres que:

**A)** Genere todos los controladores y rutas restantes automáticamente

**B)** Te explique cómo crear cada endpoint paso a paso

**C)** Te ayude solo con endpoints específicos que necesites primero

**D)** Continúe con el backend tal como está y tú completes el resto

Dime qué prefieres y continúo con lo que necesites.
