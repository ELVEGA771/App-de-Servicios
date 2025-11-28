import 'package:flutter/foundation.dart';

class AppConstants {
  // API Configuration
  static String get API_BASE_URL {
    // En web, siempre usar localhost
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    // En Android emulador, usar 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    // Para iOS y otras plataformas, usar localhost
    return 'http://localhost:3000/api';
  }

  static const String API_TIMEOUT = '30000'; // 30 seconds

  // Storage Keys
  static const String KEY_ACCESS_TOKEN = 'access_token';
  static const String KEY_REFRESH_TOKEN = 'refresh_token';
  static const String KEY_USER_ID = 'user_id';
  static const String KEY_USER_TYPE = 'user_type';
  static const String KEY_USER_DATA = 'user_data';
  static const String KEY_THEME_MODE = 'theme_mode';
  static const String KEY_LANGUAGE = 'language';

  // Hive Boxes
  static const String BOX_CACHE = 'cache_box';
  static const String BOX_FAVORITES = 'favorites_box';
  static const String BOX_SEARCH_HISTORY = 'search_history_box';

  // User Types
  static const String USER_TYPE_CLIENT = 'cliente';
  static const String USER_TYPE_COMPANY = 'empresa';
  static const String USER_TYPE_EMPLOYEE = 'empleado';
  static const String USER_TYPE_ADMIN = 'admin';

  // Contract Status
  static const String STATUS_PENDING = 'pendiente';
  static const String STATUS_CONFIRMED = 'confirmado';
  static const String STATUS_IN_PROGRESS = 'en_proceso';
  static const String STATUS_COMPLETED = 'completado';
  static const String STATUS_CANCELLED = 'cancelado';
  static const String STATUS_REJECTED = 'rechazado';

  // Pagination
  static const int DEFAULT_PAGE_SIZE = 20;
  static const int MAX_PAGE_SIZE = 100;

  // Gemini AI Configuration
  static const String GEMINI_API_KEY = 'YOUR_GEMINI_API_KEY_HERE';
  static const String GEMINI_MODEL = 'gemini-pro';

  // Google Maps
  static const String GOOGLE_MAPS_API_KEY = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  static const double DEFAULT_LATITUDE = 19.4326; // Mexico City
  static const double DEFAULT_LONGITUDE = -99.1332;
  static const double DEFAULT_ZOOM = 12.0;

  // Image Upload
  static const int MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB
  static const List<String> ALLOWED_IMAGE_TYPES = [
    'jpg',
    'jpeg',
    'png',
    'webp'
  ];

  // Video
  static const int MAX_VIDEO_SIZE = 50 * 1024 * 1024; // 50MB

  // Cache Duration
  static const Duration CACHE_DURATION_SHORT = Duration(minutes: 5);
  static const Duration CACHE_DURATION_MEDIUM = Duration(hours: 1);
  static const Duration CACHE_DURATION_LONG = Duration(days: 1);

  // Error Messages
  static const String ERROR_NETWORK =
      'Error de conexión. Verifica tu internet.';
  static const String ERROR_TIMEOUT =
      'La solicitud tardó demasiado. Intenta de nuevo.';
  static const String ERROR_UNAUTHORIZED =
      'Sesión expirada. Inicia sesión nuevamente.';
  static const String ERROR_FORBIDDEN =
      'No tienes permiso para realizar esta acción.';
  static const String ERROR_NOT_FOUND = 'Recurso no encontrado.';
  static const String ERROR_SERVER = 'Error del servidor. Intenta más tarde.';
  static const String ERROR_UNKNOWN = 'Ocurrió un error inesperado.';

  // Success Messages
  static const String SUCCESS_LOGIN = 'Inicio de sesión exitoso';
  static const String SUCCESS_REGISTER = 'Registro exitoso';
  static const String SUCCESS_UPDATE = 'Actualización exitosa';
  static const String SUCCESS_DELETE = 'Eliminado exitosamente';
  static const String SUCCESS_CREATE = 'Creado exitosamente';

  static String fixImageUrl(String url) {
    if (url.isEmpty) return url;

    // En web, no cambiar nada
    if (kIsWeb) return url;

    // Si estamos en Android (Emulador), cambiamos localhost por 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return url
          .replaceFirst('localhost', '10.0.2.2')
          .replaceFirst('127.0.0.1', '10.0.2.2');
    }

    return url;
  }
}
