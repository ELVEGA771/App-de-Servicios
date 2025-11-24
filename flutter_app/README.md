# Servicios App - Flutter

Aplicación móvil completa para marketplace de servicios con IA/ML, desarrollada en Flutter 3.x.

## 🎯 Características Principales

- ✅ **Consumo de API REST** - Integración completa con backend Node.js/Express
- ✅ **Base de Datos Remota** - MySQL vía API REST
- ✅ **State Management** - Provider para gestión de estado reactiva
- ✅ **Recursos Multimedia** - Imágenes, videos, audio integrados
- ✅ **IA/ML** - Sistema de recomendaciones con Gemini AI
- ✅ **Gráficos** - Visualización de datos con fl_chart
- ✅ **Google Maps** - Geolocalización y búsqueda por ubicación
- ✅ **Chat en Tiempo Real** - Mensajería entre clientes y empresas
- ✅ **Material Design 3** - UI moderna y responsive

## 📋 Requisitos

- Flutter SDK 3.0.0 o superior
- Dart SDK 3.0.0 o superior
- Android Studio / VS Code con extensiones de Flutter
- Backend corriendo en `http://localhost:3000` (o configurar en constants.dart)
- API Keys:
  - Google Maps API Key
  - Gemini API Key (opcional para IA)

## 🚀 Instalación

### 1. Clonar e instalar dependencias

```bash
cd flutter_app
flutter pub get
```

### 2. Configurar API Keys

Edita `lib/config/constants.dart`:

```dart
static const String API_BASE_URL = 'http://TU_IP:3000/api'; // Cambia localhost por tu IP si usas emulador
static const String GEMINI_API_KEY = 'TU_GEMINI_API_KEY';
static const String GOOGLE_MAPS_API_KEY = 'TU_GOOGLE_MAPS_API_KEY';
```

### 3. Configurar permisos (Android)

En `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

Agrega tu Google Maps API Key en el mismo archivo:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_GOOGLE_MAPS_API_KEY"/>
```

### 4. Ejecutar la aplicación

```bash
# Verificar dispositivos conectados
flutter devices

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release (Android)
flutter run --release
```

## 📁 Estructura del Proyecto

```
lib/
├── config/                 # Configuración
│   ├── constants.dart      # Constantes y API keys
│   ├── theme.dart          # Tema Material Design 3
│   └── routes.dart         # Rutas de navegación
├── core/                   # Funcionalidad core
│   ├── api/                # Cliente HTTP Dio
│   ├── models/             # Modelos de datos (13 modelos)
│   ├── providers/          # Providers para state management
│   ├── services/           # Servicios de API
│   └── utils/              # Utilidades y helpers
├── features/               # Características por módulo
│   ├── auth/               # Autenticación
│   ├── home/               # Pantalla principal
│   ├── servicio/           # Servicios
│   ├── contratacion/       # Órdenes/Contrataciones
│   ├── favoritos/          # Favoritos
│   ├── chat/               # Chat/Mensajería
│   ├── profile/            # Perfil de usuario
│   ├── empresa/            # Dashboard de empresa
│   └── notificaciones/     # Notificaciones
├── widgets/                # Widgets reutilizables
│   ├── common/             # Widgets comunes
│   ├── cards/              # Cards personalizadas
│   └── inputs/             # Inputs personalizados
└── main.dart               # Punto de entrada

assets/
├── images/                 # Imágenes estáticas
├── icons/                  # Iconos personalizados
├── videos/                 # Videos de demostración
├── audio/                  # Archivos de audio
├── animations/             # Animaciones Lottie
└── ml_models/              # Modelos TensorFlow Lite
```

## 🎨 Pantallas Implementadas

### Cliente (12 pantallas)
1. **SplashScreen** - Pantalla inicial con animación
2. **LoginScreen** - Inicio de sesión
3. **RegisterScreen** - Registro de usuarios
4. **HomeScreen** - Dashboard con categorías y recomendaciones
5. **ServicioSearchScreen** - Búsqueda avanzada con filtros
6. **ServicioListScreen** - Lista de servicios
7. **ServicioDetailScreen** - Detalle de servicio con multimedia
8. **CheckoutScreen** - Proceso de contratación
9. **OrderHistoryScreen** - Historial de órdenes
10. **OrderDetailScreen** - Detalle de orden
11. **OrderTrackingScreen** - Seguimiento en tiempo real
12. **FavoritosScreen** - Servicios favoritos

### Empresa (5 pantallas)
13. **EmpresaDashboardScreen** - Dashboard con estadísticas y gráficos
14. **EmpresaServicesScreen** - Gestión de servicios
15. **CreateServiceScreen** - Crear nuevo servicio
16. **EditServiceScreen** - Editar servicio existente
17. **EmpresaOrdersScreen** - Órdenes recibidas

### Comunes (3 pantallas)
18. **ConversationsScreen** - Lista de conversaciones
19. **ChatScreen** - Chat individual
20. **ProfileScreen** - Perfil de usuario
21. **EditProfileScreen** - Editar perfil
22. **NotificacionesScreen** - Centro de notificaciones

## 🔄 State Management con Provider

Providers implementados:

- **AuthProvider** - Gestión de autenticación
- **ServicioProvider** - Servicios y búsqueda
- **ContratacionProvider** - Órdenes
- **FavoritoProvider** - Favoritos
- **ChatProvider** - Mensajería
- **NotificacionProvider** - Notificaciones
- **ThemeProvider** - Tema claro/oscuro
- **LocationProvider** - Geolocalización

## 🤖 IA/ML - Sistema de Recomendaciones

El sistema de recomendaciones utiliza:

1. **Gemini AI API** - Para recomendaciones contextuales basadas en:
   - Historial de búsquedas
   - Servicios contratados
   - Ubicación del usuario
   - Preferencias de categorías

2. **TensorFlow Lite** (Alternativo) - Para modelo local de clasificación

Ubicación: `lib/core/services/ml_service.dart`

## 📊 Gráficos con fl_chart

Gráficos implementados (Dashboard Empresa):

- **LineChart** - Ventas en el tiempo
- **BarChart** - Servicios más solicitados
- **PieChart** - Distribución por categoría

## 🗺️ Google Maps

Funcionalidades:

- Búsqueda de servicios por ubicación
- Mapa de sucursales disponibles
- Geolocalización del usuario
- Cálculo de distancia

## 📱 Recursos Multimedia

### Imágenes
- Carga desde API con `cached_network_image`
- Upload con `image_picker`
- Optimización automática

### Videos
- Player con `video_player` y `chewie`
- Videos de demostración de servicios

### Audio
- Reproductor con `audioplayers`
- Mensajes de voz en chat (opcional)

## 🔐 Seguridad

- Tokens JWT almacenados en `flutter_secure_storage`
- Refresh token automático en interceptores
- Validación de inputs con `form_builder_validators`
- Sanitización de datos

## 📦 Caché Local con Hive

- Caché de servicios para modo offline
- Historial de búsquedas
- Favoritos sincronizados

## 🧪 Testing

```bash
# Ejecutar tests
flutter test

# Coverage
flutter test --coverage
```

## 📱 Build para Producción

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Troubleshooting

### Error: Cannot connect to backend
- Verifica que el backend esté corriendo
- Si usas emulador Android, usa `http://10.0.2.2:3000` en lugar de `localhost`
- Si usas dispositivo físico, usa la IP de tu computadora

### Error: Google Maps no se muestra
- Verifica que agregaste el API Key correcto
- Habilita "Maps SDK for Android/iOS" en Google Cloud Console

### Error: Dependencias no resuelven
```bash
flutter clean
flutter pub get
```

## 📄 Licencia

Este proyecto es parte de un trabajo académico.

## 👥 Autor

Desarrollado como aplicación completa para marketplace de servicios.
