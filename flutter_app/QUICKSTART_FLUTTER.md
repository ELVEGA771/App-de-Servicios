# Flutter App - Guía Rápida de Inicio

## 🚀 Inicio Rápido (5 minutos)

### Paso 1: Instalar Dependencias
```bash
cd /Users/jarodtierra/Desktop/PROYECTO_DB/flutter_app
flutter pub get
```

### Paso 2: Configurar API URL

Edita `lib/config/constants.dart` y cambia la URL del backend:

```dart
// Si usas emulador Android:
static const String API_BASE_URL = 'http://10.0.2.2:3000/api';

// Si usas dispositivo físico o iOS simulator:
static const String API_BASE_URL = 'http://TU_IP_LOCAL:3000/api';
// Ejemplo: static const String API_BASE_URL = 'http://192.168.1.100:3000/api';
```

**Para encontrar tu IP local:**
```bash
# macOS/Linux
ifconfig | grep "inet "

# Windows
ipconfig
```

### Paso 3: Iniciar el Backend
```bash
cd /Users/jarodtierra/Desktop/PROYECTO_DB
npm run dev
```

Deberías ver:
```
🚀 Server running on port 3000
✅ Database connected successfully
📚 Swagger docs: http://localhost:3000/api-docs
```

### Paso 4: Ejecutar la App
```bash
cd /Users/jarodtierra/Desktop/PROYECTO_DB/flutter_app
flutter run
```

---

## ✅ Verificar que Todo Funciona

### 1. Splash Screen
Al abrir la app, deberías ver:
- Logo de la app
- "Servicios App"
- Indicador de carga

### 2. Login Screen
La app te redirige a Login. Intenta:
- **Email**: `cliente@test.com`
- **Password**: `123456`

O registra una cuenta nueva.

### 3. Home Screen
Una vez autenticado verás:
- Barra de búsqueda
- Categorías horizontales
- Grid de servicios
- Bottom navigation con 4 tabs

---

## 🧪 Cuentas de Prueba

### Cliente
```
Email: cliente@test.com
Password: 123456
```

### Empresa
```
Email: empresa@test.com
Password: 123456
```

**Nota**: Estas cuentas deben existir en tu base de datos. Si no existen, regístralas desde la app.

---

## 📱 Probar en Dispositivo

### Android
1. Habilita "Opciones de desarrollador" en tu teléfono
2. Activa "Depuración USB"
3. Conecta el teléfono a tu computadora
4. Verifica: `flutter devices`
5. Ejecuta: `flutter run`

### iOS (requiere macOS)
1. Conecta tu iPhone
2. Abre Xcode una vez
3. Verifica: `flutter devices`
4. Ejecuta: `flutter run`

---

## 🐛 Troubleshooting Común

### Error: Cannot connect to backend

**Problema**: La app no puede conectarse al backend.

**Solución**:
1. Verifica que el backend está corriendo: `http://localhost:3000/health`
2. Si usas emulador Android, usa `http://10.0.2.2:3000/api`
3. Si usas dispositivo físico:
   - Asegúrate de estar en la misma red WiFi
   - Usa tu IP local (192.168.x.x)
   - Verifica que el backend acepta conexiones externas

### Error: Dio Error - SocketException

**Problema**: Error de conexión de red.

**Solución**:
```dart
// En lib/config/constants.dart
static const String API_BASE_URL = 'http://10.0.2.2:3000/api'; // Android emulator
// o
static const String API_BASE_URL = 'http://TU_IP:3000/api'; // Physical device
```

### Error: 401 Unauthorized

**Problema**: Token expirado o inválido.

**Solución**: Cierra sesión y vuelve a iniciar sesión.

### App se cierra al abrir

**Problema**: Error en tiempo de ejecución.

**Solución**:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔧 Configuración Opcional

### 1. API Keys (Gemini AI - Recomendaciones)

Para habilitar recomendaciones con IA:

1. Obtén una API key de Google AI Studio: https://makersuite.google.com/app/apikey
2. Edita `lib/config/constants.dart`:
```dart
static const String GEMINI_API_KEY = 'TU_GEMINI_API_KEY';
```

### 2. Google Maps (Búsqueda por Ubicación)

1. Crea un proyecto en Google Cloud Console
2. Habilita "Maps SDK for Android/iOS"
3. Crea una API key
4. Edita `lib/config/constants.dart`:
```dart
static const String GOOGLE_MAPS_API_KEY = 'TU_GOOGLE_MAPS_API_KEY';
```
5. Agrega la key en `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_GOOGLE_MAPS_API_KEY"/>
```

---

## 📊 Funcionalidades Disponibles

### ✅ Completamente Funcional
- [x] Autenticación (Login/Register)
- [x] Explorar servicios
- [x] Buscar servicios
- [x] Filtrar por categoría
- [x] Ver categorías
- [x] Notificaciones (badge count)
- [x] Logout

### 📝 Parcialmente Funcional (UI lista, lógica pendiente)
- [ ] Detalle de servicio
- [ ] Proceso de contratación (checkout)
- [ ] Historial de órdenes
- [ ] Seguimiento de orden
- [ ] Favoritos
- [ ] Chat/mensajería
- [ ] Perfil de usuario
- [ ] Dashboard empresa
- [ ] Gestión de servicios (empresa)

---

## 🎯 Flujo de Prueba Recomendado

### Como Cliente:
1. **Registrarse** como cliente
2. **Explorar** servicios en Home
3. **Filtrar** por categoría
4. **Buscar** un servicio específico
5. **Ver detalle** de un servicio (placeholder)
6. **Agregar a favoritos** (placeholder)
7. **Contratar servicio** (placeholder)
8. **Ver mis órdenes** (placeholder)
9. **Calificar servicio** (placeholder)

### Como Empresa:
1. **Registrarse** como empresa
2. **Ver dashboard** con estadísticas (placeholder)
3. **Crear servicio** (placeholder)
4. **Ver órdenes recibidas** (placeholder)
5. **Actualizar estado** de órdenes (placeholder)
6. **Responder mensajes** de clientes (placeholder)

---

## 📝 Comandos Útiles

```bash
# Ver dispositivos conectados
flutter devices

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release (más rápido)
flutter run --release

# Hot reload (durante desarrollo)
Presiona 'r' en la terminal

# Hot restart (durante desarrollo)
Presiona 'R' en la terminal

# Ver logs
flutter logs

# Limpiar build
flutter clean

# Reinstalar dependencias
flutter pub get

# Analizar código
flutter analyze

# Formatear código
dart format lib/

# Crear APK (Android)
flutter build apk --release

# Crear IPA (iOS)
flutter build ios --release
```

---

## 🎨 Personalizaciones

### Cambiar Colores del Tema

Edita `lib/config/theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6366F1); // Tu color
static const Color secondaryColor = Color(0xFF10B981); // Tu color
```

### Cambiar Nombre de la App

Edita `pubspec.yaml`:

```yaml
name: tu_app_name
description: Tu descripción
```

---

## 📚 Recursos

- **Flutter Docs**: https://docs.flutter.dev
- **Provider Docs**: https://pub.dev/packages/provider
- **Dio Docs**: https://pub.dev/packages/dio
- **Material Design 3**: https://m3.material.io

---

## ❓ Preguntas Frecuentes

**P: ¿Puedo usar datos de ejemplo sin el backend?**
R: No, la app requiere el backend corriendo. Todos los datos vienen de la API.

**P: ¿Cómo agrego más servicios?**
R: Registra una cuenta de empresa y usa el backend para crear servicios (o inserta directamente en la base de datos).

**P: ¿La app funciona offline?**
R: Parcialmente. Se implementó caché con Hive, pero la mayoría de funciones requieren conexión.

**P: ¿Cómo actualizo un servicio?**
R: Las pantallas de edición están creadas (placeholders). Implementa la lógica siguiendo el patrón de las pantallas Auth.

---

## 🆘 Soporte

Si encuentras problemas:

1. Revisa los logs: `flutter logs`
2. Verifica que el backend está corriendo
3. Limpia el proyecto: `flutter clean && flutter pub get`
4. Verifica la configuración de API_BASE_URL

---

**¡Listo para desarrollar!** 🚀

La estructura está completa. Solo necesitas implementar la lógica de negocio en las pantallas placeholder siguiendo los patrones establecidos.
