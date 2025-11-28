import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/contratacion.dart';
import 'package:servicios_app/core/models/api_response.dart';
import 'package:servicios_app/config/constants.dart';

class ContratacionService {
  final DioClient _dioClient = DioClient();

  // Get contrataciones by cliente
  Future<ApiResponse<List<Contratacion>>> getContratacionesByCliente({
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
    String? estado,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (estado != null) 'estado': estado,
    };

    final response = await _dioClient.get(
      '/contrataciones',
      queryParameters: queryParams,
    );

    final contrataciones = (response.data['data'] as List)
        .map((e) => Contratacion.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: contrataciones,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Get contrataciones by empresa
  Future<ApiResponse<List<Contratacion>>> getContratacionesByEmpresa({
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
    String? estado,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (estado != null) 'estado': estado,
    };

    final response = await _dioClient.get(
      '/contrataciones',
      queryParameters: queryParams,
    );

    final contrataciones = (response.data['data'] as List)
        .map((e) => Contratacion.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: contrataciones,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Get contratacion by ID
  Future<Contratacion> getContratacionById(int id) async {
    final response = await _dioClient.get('/contrataciones/$id');
    return Contratacion.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Create contratacion
  Future<Contratacion> createContratacion({
    required int servicioId,
    required int sucursalId,
    int? direccionId,
    DateTime? fechaProgramada,
    String? codigoCupon,
    String? metodoPago,
    String? notas,
    double? precioSubtotal,
    double? descuentoAplicado,
    double? precioTotal,
  }) async {
    final body = {
      'id_servicio': servicioId,
      'id_sucursal': sucursalId,
      'id_direccion_entrega': direccionId,
      'fecha_programada': fechaProgramada?.toIso8601String(),
      'codigo_cupon': codigoCupon,
      'metodo_pago': metodoPago,
      'notas': notas,
      'precio_subtotal': precioSubtotal,
      'descuento_aplicado': descuentoAplicado,
      'precio_total': precioTotal,
    };

    final response = await _dioClient.post('/contrataciones', data: body);
    return Contratacion.fromJson(response.data['data'] ?? {});
  }

  // Update contratacion status
  Future<Contratacion> updateEstado({
    required int id,
    required String nuevoEstado,
    String? notas,
  }) async {
    final response = await _dioClient.put(
      '/contrataciones/$id/estado',
      data: {
        'estado': nuevoEstado,
        if (notas != null) 'notas_empresa': notas,
      },
    );
    return Contratacion.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Cancel contratacion
  Future<Contratacion> cancelContratacion({
    required int id,
    String? motivo,
  }) async {
    final response = await _dioClient.put(
      '/contrataciones/$id/cancelar',
      data: motivo != null ? {'motivo': motivo} : null,
    );
    return Contratacion.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Get estadísticas for empresa dashboard
  Future<Map<String, dynamic>> getEstadisticas() async {
    final response = await _dioClient.get('/contrataciones/empresa/estadisticas');
    return response.data['data'] as Map<String, dynamic>;
  }

  // Get historial de contrataciones (empresa)
  Future<ApiResponse<List<HistorialContratacion>>> getHistorialEmpresa({
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    final response = await _dioClient.get(
      '/contrataciones/empresa/historial',
      queryParameters: queryParams,
    );

    final historial = (response.data['data'] as List)
        .map((e) => HistorialContratacion.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: historial,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}
