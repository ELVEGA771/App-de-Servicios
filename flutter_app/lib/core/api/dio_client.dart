import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:servicios_app/config/constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.API_BASE_URL,
        connectTimeout: Duration(milliseconds: int.parse(AppConstants.API_TIMEOUT)),
        receiveTimeout: Duration(milliseconds: int.parse(AppConstants.API_TIMEOUT)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.KEY_ACCESS_TOKEN);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request
              final opts = error.requestOptions;
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString(AppConstants.KEY_ACCESS_TOKEN);
              opts.headers['Authorization'] = 'Bearer $token';
              try {
                final response = await _dio.request(
                  opts.path,
                  options: Options(
                    method: opts.method,
                    headers: opts.headers,
                  ),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              // Refresh failed, logout user
              await logout();
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Add logger in debug mode
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  Dio get dio => _dio;

  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConstants.KEY_REFRESH_TOKEN);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['accessToken'] as String;
        await prefs.setString(
          AppConstants.KEY_ACCESS_TOKEN,
          newAccessToken,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.KEY_ACCESS_TOKEN);
    await prefs.remove(AppConstants.KEY_REFRESH_TOKEN);
    await prefs.remove(AppConstants.KEY_USER_ID);
    await prefs.remove(AppConstants.KEY_USER_TYPE);
    await prefs.remove(AppConstants.KEY_USER_DATA);
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload file
  Future<Response> uploadFile(
    String path,
    String filePath,
    String fieldName, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      return await _dio.post(
        path,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  Exception _handleError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = AppConstants.ERROR_TIMEOUT;
        break;
      case DioExceptionType.badResponse:
        message = _getErrorMessage(error.response);
        break;
      case DioExceptionType.cancel:
        message = 'Solicitud cancelada';
        break;
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          message = AppConstants.ERROR_NETWORK;
        } else {
          message = AppConstants.ERROR_UNKNOWN;
        }
        break;
      default:
        message = AppConstants.ERROR_UNKNOWN;
    }

    return Exception(message);
  }

  String _getErrorMessage(Response? response) {
    if (response == null) return AppConstants.ERROR_UNKNOWN;

    switch (response.statusCode) {
      case 400:
        return response.data['message'] ?? 'Solicitud inválida';
      case 401:
        return AppConstants.ERROR_UNAUTHORIZED;
      case 403:
        return AppConstants.ERROR_FORBIDDEN;
      case 404:
        return AppConstants.ERROR_NOT_FOUND;
      case 429:
        return 'Demasiadas solicitudes. Espera un momento.';
      case 500:
      case 502:
      case 503:
        return AppConstants.ERROR_SERVER;
      default:
        return response.data['message'] ?? AppConstants.ERROR_UNKNOWN;
    }
  }
}
