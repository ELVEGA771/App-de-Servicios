# ⚡ QUICKSTART - Backend Servicios App

## 🚀 Instalación Rápida (5 minutos)

### 1️⃣ Instalar dependencias

```bash
cd backend
npm install
```

### 2️⃣ Configurar base de datos

```bash
# Desde el directorio padre (PROYECTO_DB)
cd ..
mysql -u root -p < BASEVERSIONFINAL1.sql
```

Cuando te pida la contraseña, ingresa tu password de MySQL.

### 3️⃣ Configurar variables de entorno

```bash
cd backend
cp .env.example .env
```

Edita el archivo `.env` y cambia estas líneas:

```env
DB_PASSWORD=TU_PASSWORD_MYSQL_AQUI
JWT_SECRET=cambia_este_secret_por_algo_muy_seguro_y_aleatorio_minimo_32_caracteres
JWT_REFRESH_SECRET=otro_secret_diferente_tambien_muy_seguro_y_aleatorio
```

### 4️⃣ Iniciar servidor

```bash
npm run dev
```

Deberías ver:

```
✅ Database connected successfully
🚀 Server is running on port 3000
📚 API Documentation: http://localhost:3000/api-docs
🏥 Health check: http://localhost:3000/health
```

### 5️⃣ Verificar que funciona

Abre tu navegador y visita:
- http://localhost:3000/health
- http://localhost:3000/api-docs

O desde terminal:

```bash
curl http://localhost:3000/health
```

Deberías ver:
```json
{
  "status": "ok",
  "timestamp": "2025-11-22T...",
  "environment": "development"
}
```

---

## 📝 Probar el API

### Registrar un usuario

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

Si todo funciona, verás algo como:

```json
{
  "success": true,
  "data": {
    "user": {
      "id_usuario": 1,
      "email": "test@example.com",
      "nombre": "Test",
      "apellido": "User",
      "tipo_usuario": "cliente"
    },
    "accessToken": "eyJhbGciOiJIUz...",
    "refreshToken": "eyJhbGciOiJIUz..."
  },
  "message": "User registered successfully"
}
```

---

## 🎯 Siguiente paso

### Importar colección de Postman

1. Abre Postman
2. Click en "Import"
3. Selecciona el archivo `Servicios_App.postman_collection.json`
4. ¡Listo! Tendrás todos los endpoints listos para probar

---

## ❌ Problemas Comunes

### Error: Cannot connect to database

**Solución:**
1. Verifica que MySQL esté corriendo
2. Revisa que el password en `.env` sea correcto
3. Verifica que la base de datos `app_servicios` exista

### Error: Port 3000 already in use

**Solución:**
```bash
# Cambiar puerto en .env
echo "PORT=3001" >> .env
```

### Error: JWT_SECRET is not defined

**Solución:**
- Asegúrate de haber copiado `.env.example` a `.env`
- Verifica que `JWT_SECRET` esté definido en `.env`

---

## 📚 Documentación Completa

- **README.md** - Documentación detallada
- **SETUP_INSTRUCTIONS.md** - Guía de configuración paso a paso
- **SUMMARY.md** - Resumen del proyecto
- **/api-docs** - Documentación Swagger (cuando el servidor está corriendo)

---

¡Listo! Tu backend está funcionando 🎉
