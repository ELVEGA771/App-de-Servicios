# 🚀 Servicios App - Backend API

Backend completo y robusto para una aplicación de servicios tipo DoorDash, desarrollado con Node.js, Express y MySQL.

## 📋 Tabla de Contenidos

- [Características](#características)
- [Stack Tecnológico](#stack-tecnológico)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Uso](#uso)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [API Endpoints](#api-endpoints)
- [Autenticación](#autenticación)
- [Base de Datos](#base-de-datos)
- [Testing](#testing)
- [Deployment](#deployment)

## ✨ Características

- ✅ **Autenticación JWT** con tokens de acceso y refresh
- ✅ **Sistema de roles** (Cliente, Empresa, Admin)
- ✅ **Pool de conexiones** MySQL optimizado
- ✅ **Validaciones robustas** con express-validator
- ✅ **Manejo centralizado de errores**
- ✅ **Rate limiting** para prevenir abuso
- ✅ **Seguridad** con Helmet.js y CORS
- ✅ **Documentación automática** con Swagger/OpenAPI	
- ✅ **Logging** con Winston
- ✅ **Compresión** de respuestas HTTP
- ✅ **Soporte para transacciones** SQL
- ✅ **Arquitectura MVC** limpia y escalable

## 🛠 Stack Tecnológico

- **Runtime:** Node.js >= 16.0.0
- **Framework:** Express.js 4.18
- **Base de Datos:** MySQL 8.0
- **Autenticación:** JWT (JSON Web Tokens)
- **Validación:** Express Validator
- **Documentación:** Swagger UI
- **Logging:** Winston
- **Seguridad:** Helmet, CORS, bcrypt
- **Testing:** Jest, Supertest

## 📦 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Node.js** v16.0.0 o superior
- **npm** v7.0.0 o superior
- **MySQL** v8.0 o superior
- **Git** (opcional)

## 🔧 Instalación

### 1. Clonar el repositorio (o descargar)

```bash
cd backend
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar base de datos

Ejecuta el script SQL para crear la base de datos:

```bash
mysql -u root -p < ../BASEVERSIONFINAL1.sql
```

Esto creará:
- Base de datos `app_servicios`
- Todas las tablas necesarias
- Triggers automáticos
- Vistas útiles
- Procedimientos almacenados

### 4. Configurar variables de entorno

Copia el archivo de ejemplo y edítalo:

```bash
cp .env.example .env
```

Edita `.env` con tus configuraciones:

```env
NODE_ENV=development
PORT=3000

# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password_mysql
DB_NAME=app_servicios
DB_CONNECTION_LIMIT=10

# JWT
JWT_SECRET=tu_secret_super_seguro_de_al_menos_32_caracteres
JWT_EXPIRES_IN=7d
JWT_REFRESH_SECRET=otro_secret_diferente_para_refresh_tokens
JWT_REFRESH_EXPIRES_IN=30d

# CORS
CORS_ORIGIN=http://localhost:3000,http://localhost:8080

# Rate Limiting
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX_REQUESTS=100

# Security
BCRYPT_ROUNDS=10

# Logging
LOG_LEVEL=info
```

### 5. Iniciar el servidor

**Desarrollo (con auto-reload):**
```bash
npm run dev
```

**Producción:**
```bash
npm start
```

El servidor estará disponible en `http://localhost:3000`

## 📖 Uso

### Acceder a la documentación

Una vez el servidor esté corriendo:

- **Swagger UI:** http://localhost:3000/api-docs
- **Health Check:** http://localhost:3000/health
- **API Base:** http://localhost:3000/

### Probar la API

#### 1. Registrar un nuevo usuario (Cliente)

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "cliente@example.com",
    "password": "Password123",
    "nombre": "Juan",
    "apellido": "Pérez",
    "telefono": "0987654321",
    "tipo_usuario": "cliente",
    "fecha_nacimiento": "1990-01-01"
  }'
```

#### 2. Registrar una Empresa

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "empresa@example.com",
    "password": "Password123",
    "nombre": "María",
    "apellido": "González",
    "telefono": "0987654321",
    "tipo_usuario": "empresa",
    "razon_social": "Servicios González S.A.",
    "ruc_nit": "1234567890001"
  }'
```

#### 3. Iniciar sesión

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "cliente@example.com",
    "password": "Password123"
  }'
```

Respuesta:
```json
{
  "success": true,
  "data": {
    "user": {
      "id_usuario": 1,
      "email": "cliente@example.com",
      "nombre": "Juan",
      "apellido": "Pérez",
      "tipo_usuario": "cliente"
    },
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "Login successful"
}
```

#### 4. Obtener perfil de usuario (requiere autenticación)

```bash
curl -X GET http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer TU_ACCESS_TOKEN"
```

## 📁 Estructura del Proyecto

```
backend/
├── src/
│   ├── config/
│   │   ├── database.js          # Configuración MySQL + pool
│   │   ├── jwt.js                # Configuración JWT
│   │   └── swagger.js            # Configuración Swagger
│   ├── controllers/
│   │   ├── authController.js     # Autenticación
│   │   ├── servicioController.js # Servicios (a implementar)
│   │   └── ...                   # Otros controladores
│   ├── models/
│   │   ├── Usuario.js            # Modelo de usuarios
│   │   ├── Cliente.js            # Modelo de clientes
│   │   ├── Empresa.js            # Modelo de empresas
│   │   ├── Servicio.js           # Modelo de servicios
│   │   ├── Contratacion.js       # Modelo de contrataciones
│   │   ├── Cupon.js              # Modelo de cupones
│   │   ├── Direccion.js          # Modelo de direcciones
│   │   ├── Calificacion.js       # Modelo de calificaciones
│   │   ├── Favorito.js           # Modelo de favoritos
│   │   ├── Conversacion.js       # Modelo de conversaciones
│   │   ├── Mensaje.js            # Modelo de mensajes
│   │   └── Notificacion.js       # Modelo de notificaciones
│   ├── routes/
│   │   ├── authRoutes.js         # Rutas de autenticación
│   │   └── ...                   # Otras rutas
│   ├── middleware/
│   │   ├── authMiddleware.js     # Verificación JWT
│   │   ├── roleMiddleware.js     # Verificación de roles
│   │   ├── errorHandler.js       # Manejo de errores
│   │   ├── rateLimiter.js        # Rate limiting
│   │   └── validator.js          # Validación de requests
│   ├── validators/
│   │   ├── authValidator.js      # Validaciones de auth
│   │   └── ...                   # Otras validaciones
│   ├── utils/
│   │   ├── constants.js          # Constantes del sistema
│   │   ├── logger.js             # Logger (Winston)
│   │   └── responseFormatter.js  # Formato de respuestas
│   └── app.js                     # Configuración Express
├── tests/
│   └── ...                        # Tests unitarios
├── .env                           # Variables de entorno
├── .env.example                   # Ejemplo de .env
├── .gitignore
├── package.json
├── README.md
└── server.js                      # Punto de entrada
```

## 🔌 API Endpoints

### Autenticación (`/api/auth`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Registrar usuario | No |
| POST | `/api/auth/login` | Iniciar sesión | No |
| POST | `/api/auth/logout` | Cerrar sesión | Sí |
| GET | `/api/auth/me` | Obtener perfil | Sí |
| PUT | `/api/auth/me` | Actualizar perfil | Sí |
| PUT | `/api/auth/change-password` | Cambiar contraseña | Sí |

### Servicios (`/api/servicios`) - A implementar

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| GET | `/api/servicios` | Listar servicios | No |
| GET | `/api/servicios/:id` | Obtener servicio | No |
| POST | `/api/servicios` | Crear servicio | Sí (Empresa) |
| PUT | `/api/servicios/:id` | Actualizar servicio | Sí (Empresa) |
| DELETE | `/api/servicios/:id` | Eliminar servicio | Sí (Empresa) |
| GET | `/api/servicios/buscar` | Buscar servicios | No |

### Otros Endpoints

Ver documentación Swagger completa en `/api-docs`

## 🔐 Autenticación

### JWT (JSON Web Tokens)

La API utiliza JWT para autenticación. Después de login/register, recibirás:

- **accessToken:** Token de corta duración (7 días por defecto)
- **refreshToken:** Token de larga duración (30 días por defecto)

### Usar el token

Incluye el access token en el header de tus requests:

```
Authorization: Bearer {tu_access_token}
```

### Ejemplo con cURL

```bash
curl -X GET http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### Ejemplo con JavaScript (fetch)

```javascript
const response = await fetch('http://localhost:3000/api/auth/me', {
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json'
  }
});
```

## 🗄 Base de Datos

### Diagrama ER

La base de datos incluye las siguientes tablas principales:

- **usuario** - Usuarios del sistema
- **cliente** - Datos específicos de clientes (1:1 con usuario)
- **empresa** - Datos específicos de empresas (1:1 con usuario)
- **servicio** - Servicios ofrecidos
- **categoria_servicio** - Categorías de servicios
- **contratacion** - Pedidos/contrataciones
- **cupon** - Cupones de descuento
- **direccion** - Direcciones físicas
- **sucursal** - Sucursales de empresas
- **calificacion** - Calificaciones
- **conversacion** - Chats
- **mensaje** - Mensajes de chat
- **notificacion** - Notificaciones
- **servicio_favorito** - Favoritos

### Triggers Automáticos

- ✅ Incrementar uso de cupón al crear contratación
- ✅ Actualizar calificación promedio de empresa
- ✅ Actualizar último mensaje en conversación

### Vistas Útiles

- `vista_servicios_completos` - Servicios con todos los detalles
- `vista_contrataciones_detalle` - Contrataciones detalladas
- `vista_estadisticas_empresa` - Estadísticas por empresa
- `vista_sucursales_direccion_completa` - Sucursales con direcciones

## 🧪 Testing

### Ejecutar tests

```bash
# Run all tests
npm test

# Run tests with coverage
npm test -- --coverage

# Run tests in watch mode
npm run test:watch
```

### Ejemplo de test

```javascript
const request = require('supertest');
const app = require('../src/app');

describe('Auth API', () => {
  it('should register a new user', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'Password123',
        nombre: 'Test',
        apellido: 'User',
        tipo_usuario: 'cliente'
      });

    expect(res.statusCode).toBe(201);
    expect(res.body.success).toBe(true);
    expect(res.body.data).toHaveProperty('accessToken');
  });
});
```

## 🚀 Deployment

### Variables de Entorno en Producción

Asegúrate de configurar:

```env
NODE_ENV=production
PORT=3000
DB_HOST=tu_db_host
DB_USER=tu_db_user
DB_PASSWORD=tu_db_password_seguro
JWT_SECRET=un_secret_muy_seguro_y_aleatorio
```

### Proceso de Deployment

1. **Instalar dependencias de producción:**
   ```bash
   npm install --production
   ```

2. **Ejecutar migraciones de BD:**
   ```bash
   mysql -u user -p < database_schema.sql
   ```

3. **Iniciar servidor:**
   ```bash
   npm start
   ```

### Recomendaciones de Seguridad

- ✅ Usar HTTPS en producción
- ✅ Configurar firewall para MySQL
- ✅ Usar secretos JWT fuertes y aleatorios
- ✅ Habilitar logs de seguridad
- ✅ Configurar rate limiting apropiado
- ✅ Revisar dependencias con `npm audit`
- ✅ Usar variables de entorno, nunca hardcodear secrets

## 📝 Scripts Disponibles

```bash
npm start        # Iniciar en producción
npm run dev      # Iniciar con nodemon (desarrollo)
npm test         # Ejecutar tests
npm run test:watch  # Tests en modo watch
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 📧 Soporte

Si tienes preguntas o problemas:

- 📖 Revisa la documentación en `/api-docs`
- 🐛 Reporta bugs en Issues
- 💬 Contacta al equipo de desarrollo

---

**Desarrollado con ❤️ usando Node.js + Express + MySQL**
