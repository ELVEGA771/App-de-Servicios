import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  // Login
  Future<AuthResponse> login(String email, String password) async {
    try {
      print('DEBUG: Starting login for email: $email');
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('DEBUG: Login response data: ${response.data}');

      AuthResponse authResponse;
      try {
        authResponse = AuthResponse.fromJson(response.data);
        print('DEBUG: AuthResponse created successfully');
      } catch (e, stackTrace) {
        print('ERROR: Failed to parse AuthResponse');
        print('ERROR: Exception: $e');
        print('ERROR: Stack trace: $stackTrace');
        print('ERROR: Response data was: ${response.data}');
        rethrow;
      }

      try {
        await _saveAuthData(authResponse);
        print('DEBUG: Auth data saved successfully');
      } catch (e, stackTrace) {
        print('ERROR: Failed to save auth data');
        print('ERROR: Exception: $e');
        print('ERROR: Stack trace: $stackTrace');
        rethrow;
      }

      return authResponse;
    } catch (e, stackTrace) {
      print('ERROR: Login failed');
      print('ERROR: Exception: $e');
      print('ERROR: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Subir imagen al servidor
  Future<String?> uploadImage(XFile file) async {
    try {
      String fileName = file.name;
      FormData formData;

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        formData = FormData.fromMap({
          "imagen": MultipartFile.fromBytes(bytes, filename: fileName),
        });
      } else {
        formData = FormData.fromMap({
          "imagen": await MultipartFile.fromFile(file.path, filename: fileName),
        });
      }

      // Hacemos el POST sobreescribiendo el Content-Type
      final response = await _dioClient.post(
        '/upload', 
        data: formData,
        // AGREGA ESTO: Forzamos null en contentType para que Dio calcule el boundary correctamente
        // y elimine el 'application/json' que pueda estar poniendo el interceptor.
        options: Options(
          contentType: 'multipart/form-data', 
        ),
      );
      // Verificamos la respuesta
      if (response.data is Map && response.data.containsKey('url')) {
        return response.data['url'];
      } else if (response.data['data'] != null && response.data['data']['url'] != null) {
        return response.data['data']['url'];
      }
      
      return null;
    } catch (e) {
      print('Error subiendo imagen: $e');
      rethrow;
    }
  }


  // Register Cliente
  Future<AuthResponse> registerCliente({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    String? telefono,
    DateTime? fechaNacimiento,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'tipo_usuario': AppConstants.USER_TYPE_CLIENT,
      'nombre': nombre,
      'apellido': apellido,
    };

    // Only add optional fields if they have values
    if (telefono != null && telefono.isNotEmpty) {
      data['telefono'] = telefono;
    }
    if (fechaNacimiento != null) {
      data['fecha_nacimiento'] =
          fechaNacimiento.toIso8601String().split('T')[0];
    }

    final response = await _dioClient.post(
      '/auth/register',
      data: data,
    );

    final authResponse = AuthResponse.fromJson(response.data);
    await _saveAuthData(authResponse);
    return authResponse;
  }

  // Actualizar perfil
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dioClient.put('/auth/me', data: data);
  }

  // Obtener perfil actualizado
  Future<Map<String, dynamic>> getMe() async {
    final response = await _dioClient.get('/auth/me');
    return response.data;
  }

  // Guardar datos actualizados en el almacenamiento local
  Future<void> updateLocalUserData(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Extraer la data real (a veces viene en 'data', a veces directa)
    final data = (responseData.containsKey('data') && responseData['data'] is Map) 
        ? responseData['data'] 
        : responseData;

    // 2. Construir el mapa con las claves EXACTAS que usa _saveAuthData
    // El backend manda 'user', pero tu app espera 'usuario'.
    final Map<String, dynamic> storageData = {};

    // Mapeo de Usuario
    if (data.containsKey('user')) {
      storageData['usuario'] = data['user'];
    } else if (data.containsKey('usuario')) {
      storageData['usuario'] = data['usuario'];
    }

    // Mapeo de Empresa
    if (data.containsKey('empresa')) {
      storageData['empresa'] = data['empresa'];
    }

    // Mapeo de Cliente
    if (data.containsKey('cliente')) {
      storageData['cliente'] = data['cliente'];
    }

    // 3. Guardar usando la constante correcta
    // Usamos jsonEncode para guardar el objeto como String, igual que en el login
    print('DEBUG: Actualizando datos locales en ${AppConstants.KEY_USER_DATA}...');
    await prefs.setString(
      AppConstants.KEY_USER_DATA, 
      jsonEncode(storageData),
    );
  }
  

  // Register Empresa
  Future<AuthResponse> registerEmpresa({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    String? descripcion,
    String? telefono,
    String? rfc,
    String? razonSocial,
    String? pais,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'tipo_usuario': AppConstants.USER_TYPE_COMPANY,
      'nombre': nombre,
      'apellido': apellido, // AGREGAR AL MAPA
    };

    // Only add optional fields if they have values
    if (descripcion != null && descripcion.isNotEmpty) {
      data['descripcion'] = descripcion;
    }
    if (telefono != null && telefono.isNotEmpty) {
      data['telefono'] = telefono;
    }
    if (rfc != null && rfc.isNotEmpty) {
      data['rfc'] = rfc;
    }
    if (razonSocial != null && razonSocial.isNotEmpty) {
      data['razon_social'] = razonSocial;
    }
    if (pais != null && pais.isNotEmpty) data['pais'] = pais;

    final response = await _dioClient.post(
      '/auth/register',
      data: data,
    );

    final authResponse = AuthResponse.fromJson(response.data);
    await _saveAuthData(authResponse);
    return authResponse;
  }

 

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dioClient.put(
      '/auth/change-password',
      data: {
        // CORRECCIÓN: Usar camelCase para coincidir con el backend
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } catch (e) {
      // Continue logout even if API call fails
    }
    await _clearAuthData();
  }

  // Refresh token
  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConstants.KEY_REFRESH_TOKEN);
      if (refreshToken == null) return null;

      final response = await _dioClient.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['data']['accessToken'] as String;
      await prefs.setString(
        AppConstants.KEY_ACCESS_TOKEN,
        newAccessToken,
      );
      return newAccessToken;
    } catch (e) {
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.KEY_ACCESS_TOKEN);
    return token != null;
  }

  // Get stored user type
  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.KEY_USER_TYPE);
  }

  // Get stored user ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.KEY_USER_ID);
    return userId != null ? int.tryParse(userId) : null;
  }

  // Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(AppConstants.KEY_USER_DATA);
    if (userData == null) return null;
    return jsonDecode(userData) as Map<String, dynamic>;
  }

  // Save auth data to shared preferences
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    print('DEBUG: Getting SharedPreferences instance...');
    final prefs = await SharedPreferences.getInstance();

    print('DEBUG: Saving access token...');
    await prefs.setString(
      AppConstants.KEY_ACCESS_TOKEN,
      authResponse.accessToken,
    );
    print('DEBUG: Saving refresh token...');
    await prefs.setString(
      AppConstants.KEY_REFRESH_TOKEN,
      authResponse.refreshToken,
    );
    print('DEBUG: Saving user ID: ${authResponse.usuario.id}');
    await prefs.setString(
      AppConstants.KEY_USER_ID,
      authResponse.usuario.id.toString(),
    );
    print('DEBUG: Saving user type: ${authResponse.usuario.tipoUsuario}');
    await prefs.setString(
      AppConstants.KEY_USER_TYPE,
      authResponse.usuario.tipoUsuario,
    );

    print('DEBUG: Converting usuario to JSON...');
    // Save complete user data
    final userData = {
      'usuario': authResponse.usuario.toJson(),
      if (authResponse.cliente != null)
        'cliente': authResponse.cliente!.toJson(),
      if (authResponse.empresa != null)
        'empresa': authResponse.empresa!.toJson(),
    };
    print('DEBUG: Encoding userData...');
    await prefs.setString(
      AppConstants.KEY_USER_DATA,
      jsonEncode(userData),
    );
    print('DEBUG: Auth data saved successfully!');
  }

  // Clear auth data
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.KEY_ACCESS_TOKEN);
    await prefs.remove(AppConstants.KEY_REFRESH_TOKEN);
    await prefs.remove(AppConstants.KEY_USER_ID);
    await prefs.remove(AppConstants.KEY_USER_TYPE);
    await prefs.remove(AppConstants.KEY_USER_DATA);
  }
}
