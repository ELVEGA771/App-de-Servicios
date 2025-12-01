import 'package:servicios_app/core/api/dio_client.dart';

class AdminService {
  final DioClient _dioClient = DioClient();

  Future<List<dynamic>> getAllClients() async {
    try {
      final response = await _dioClient.get('/clientes');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAllCompanies() async {
    try {
      final response = await _dioClient.get('/empresas');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Vista: vista_contrataciones_detalle
  Future<List<dynamic>> getVistaContrataciones() async {
    try {
      final response = await _dioClient.get('/admin/vistas/contrataciones');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Vista: vista_estadisticas_empresa
  Future<List<dynamic>> getVistaEstadisticasEmpresa() async {
    try {
      final response = await _dioClient.get('/admin/vistas/estadisticas-empresas');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Vista: vista_servicios_completos
  Future<List<dynamic>> getVistaServicios() async {
    try {
      final response = await _dioClient.get('/admin/vistas/servicios');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Vista: vista_sucursales_direccion_completa
  Future<List<dynamic>> getVistaSucursales() async {
    try {
      final response = await _dioClient.get('/admin/vistas/sucursales');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Vista: vista_top_clientes
  Future<List<dynamic>> getVistaTopClientes() async {
    try {
      final response = await _dioClient.get('/admin/vistas/top-clientes');
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Helper para limpiar la respuesta
  List<dynamic> _parseResponse(dynamic response) {
    if (response.data is Map && response.data.containsKey('data')) {
      return response.data['data'] as List<dynamic>;
    }
    return response.data as List<dynamic>;
  }
}
