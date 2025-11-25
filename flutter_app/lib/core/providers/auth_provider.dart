import 'package:flutter/foundation.dart';
import 'package:servicios_app/core/models/auth_response.dart';
import 'package:servicios_app/core/models/usuario.dart';
import 'package:servicios_app/core/models/cliente.dart';
import 'package:servicios_app/core/models/empresa.dart';
import 'package:servicios_app/core/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Usuario? _usuario;
  Cliente? _cliente;
  Empresa? _empresa;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  Usuario? get usuario => _usuario;
  Cliente? get cliente => _cliente;
  Empresa? get empresa => _empresa;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCliente => _usuario?.tipoUsuario == 'cliente';
  bool get isEmpresa => _usuario?.tipoUsuario == 'empresa';

  String? get displayName {
    if (isCliente && _usuario != null) {
      return '${_usuario!.nombre ?? ''} ${_usuario!.apellido ?? ''}'.trim();
    }
    if (_empresa != null) return _empresa!.nombre;
    return _usuario?.email;
  }

  String? get profileImage {
    if (isCliente && _usuario != null) return _usuario!.fotoPerfilUrl;
    if (_empresa != null) return _empresa!.logo;
    return null;
  }

  // Check if already logged in
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final userData = await _authService.getUserData();
        if (userData != null) {
          _usuario =
              Usuario.fromJson(userData['usuario'] as Map<String, dynamic>);
          if (userData['cliente'] != null) {
            _cliente =
                Cliente.fromJson(userData['cliente'] as Map<String, dynamic>);
          }
          if (userData['empresa'] != null) {
            _empresa =
                Empresa.fromJson(userData['empresa'] as Map<String, dynamic>);
          }
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final authResponse = await _authService.login(email, password);
      _setAuthData(authResponse);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register Cliente
  Future<bool> registerCliente({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    String? telefono,
    DateTime? fechaNacimiento,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final authResponse = await _authService.registerCliente(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        fechaNacimiento: fechaNacimiento,
      );
      _setAuthData(authResponse);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register Empresa
  Future<bool> registerEmpresa({
    required String email,
    required String password,
    required String nombre,
    required String apellido, // NUEVO CAMPO
    String? descripcion,
    String? telefono,
    String? rfc,
    String? razonSocial,
    String? pais,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final authResponse = await _authService.registerEmpresa(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido, // PASAR AL SERVICIO
        descripcion: descripcion,
        telefono: telefono,
        rfc: rfc,
        razonSocial: razonSocial,
        pais: pais,
      );
      _setAuthData(authResponse);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _clearAuthData();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    try {
      final userData = await _authService.getMe();
      _usuario = Usuario.fromJson(userData['usuario'] as Map<String, dynamic>);
      if (userData['cliente'] != null) {
        _cliente =
            Cliente.fromJson(userData['cliente'] as Map<String, dynamic>);
      }
      if (userData['empresa'] != null) {
        _empresa =
            Empresa.fromJson(userData['empresa'] as Map<String, dynamic>);
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Private helpers
  void _setAuthData(AuthResponse authResponse) {
    _usuario = authResponse.usuario;
    _cliente = authResponse.cliente;
    _empresa = authResponse.empresa;
    _isAuthenticated = true;
    notifyListeners();
  }

  void _clearAuthData() {
    _usuario = null;
    _cliente = null;
    _empresa = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
