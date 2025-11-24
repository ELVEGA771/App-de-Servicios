import 'package:servicios_app/core/models/usuario.dart';
import 'package:servicios_app/core/models/cliente.dart';
import 'package:servicios_app/core/models/empresa.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final Usuario usuario;
  final Cliente? cliente;
  final Empresa? empresa;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.usuario,
    this.cliente,
    this.empresa,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('DEBUG AuthResponse.fromJson: Starting parsing');
      print('DEBUG AuthResponse.fromJson: json = $json');

      final data = json['data'] as Map<String, dynamic>;
      print('DEBUG AuthResponse.fromJson: data extracted = $data');

      // Backend sends 'user' but we store it as 'usuario'
      final userJson = data['user'] ?? data['usuario'];
      print('DEBUG AuthResponse.fromJson: userJson = $userJson');

      Usuario usuario;
      try {
        usuario = Usuario.fromJson(userJson as Map<String, dynamic>);
        print('DEBUG AuthResponse.fromJson: Usuario parsed successfully');
      } catch (e, stackTrace) {
        print('ERROR AuthResponse.fromJson: Failed to parse Usuario');
        print('ERROR: $e');
        print('STACK: $stackTrace');
        rethrow;
      }

      Cliente? cliente;
      if (data['cliente'] != null) {
        try {
          print('DEBUG AuthResponse.fromJson: Parsing Cliente: ${data['cliente']}');
          cliente = Cliente.fromJson(data['cliente'] as Map<String, dynamic>);
          print('DEBUG AuthResponse.fromJson: Cliente parsed successfully');
        } catch (e, stackTrace) {
          print('ERROR AuthResponse.fromJson: Failed to parse Cliente');
          print('ERROR: $e');
          print('STACK: $stackTrace');
          rethrow;
        }
      }

      Empresa? empresa;
      if (data['empresa'] != null) {
        try {
          print('DEBUG AuthResponse.fromJson: Parsing Empresa: ${data['empresa']}');
          empresa = Empresa.fromJson(data['empresa'] as Map<String, dynamic>);
          print('DEBUG AuthResponse.fromJson: Empresa parsed successfully');
        } catch (e, stackTrace) {
          print('ERROR AuthResponse.fromJson: Failed to parse Empresa');
          print('ERROR: $e');
          print('STACK: $stackTrace');
          rethrow;
        }
      }

      final authResponse = AuthResponse(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        usuario: usuario,
        cliente: cliente,
        empresa: empresa,
      );

      print('DEBUG AuthResponse.fromJson: Successfully created AuthResponse');
      return authResponse;
    } catch (e, stackTrace) {
      print('ERROR AuthResponse.fromJson: Failed to parse AuthResponse');
      print('ERROR: $e');
      print('STACK: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'usuario': usuario.toJson(),
        'cliente': cliente?.toJson(),
        'empresa': empresa?.toJson(),
      }
    };
  }

  bool get isCliente => usuario.tipoUsuario == 'cliente';
  bool get isEmpresa => usuario.tipoUsuario == 'empresa';

  String? get displayName {
    if (isCliente) {
      return '${usuario.nombre} ${usuario.apellido}';
    } else if (empresa != null) {
      return empresa!.nombre;
    }
    return usuario.email;
  }

  String? get profileImage {
    if (isCliente) {
      return usuario.fotoPerfilUrl;
    } else if (empresa != null) {
      return empresa!.logo;
    }
    return null;
  }
}
