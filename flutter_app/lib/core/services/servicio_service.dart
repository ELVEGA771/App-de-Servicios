import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/servicio.dart';
import 'package:servicios_app/core/models/api_response.dart';
import 'package:servicios_app/config/constants.dart';

class ServicioService {
  final DioClient _dioClient = DioClient();

  // Get all servicios with filters and pagination
  Future<ApiResponse<List<Servicio>>> getAllServicios({
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
    int? categoriaId,
    String? ciudad,
    double? precioMin,
    double? precioMax,
    double? calificacionMin,
    String? busqueda,
    String? ordenar,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (categoriaId != null) 'categoria': categoriaId,
      if (ciudad != null) 'ciudad': ciudad,
      if (precioMin != null) 'precio_min': precioMin,
      if (precioMax != null) 'precio_max': precioMax,
      if (calificacionMin != null) 'calificacion_min': calificacionMin,
      if (busqueda != null) 'busqueda': busqueda,
      if (ordenar != null) 'ordenar': ordenar,
    };

    final response = await _dioClient.get('/servicios', queryParameters: queryParams);

    final servicios = (response.data['data'] as List)
        .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: servicios,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Get servicio by ID
  Future<Servicio> getServicioById(int id) async {
    final response = await _dioClient.get('/servicios/$id');
    return Servicio.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Search servicios
  Future<ApiResponse<List<Servicio>>> searchServicios({
    required String query,
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
    int? categoriaId,
    String? ciudad,
  }) async {
    final queryParams = <String, dynamic>{
      'q': query,
      'page': page,
      'limit': limit,
      if (categoriaId != null) 'categoria': categoriaId,
      if (ciudad != null) 'ciudad': ciudad,
    };

    final response = await _dioClient.get('/servicios/search', queryParameters: queryParams);

    final servicios = (response.data['data'] as List)
        .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: servicios,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Get servicios by empresa
  Future<List<Servicio>> getServiciosByEmpresa(int empresaId) async {
    final response = await _dioClient.get('/servicios/empresa/$empresaId');
    return (response.data['data'] as List)
        .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get servicios by categoria
  Future<ApiResponse<List<Servicio>>> getServiciosByCategoria({
    required int categoriaId,
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'categoria': categoriaId,
    };

    final response = await _dioClient.get('/servicios', queryParameters: queryParams);

    final servicios = (response.data['data'] as List)
        .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: servicios,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Create servicio (Empresa only)
  Future<Servicio> createServicio({
    required int categoriaId,
    required String nombre,
    required String descripcion,
    required double precio,
    String? duracionEstimada,
    String? imagenPrincipal,
    List<String>? imagenesAdicionales,
    String? videoUrl,
  }) async {
    final response = await _dioClient.post(
      '/servicios',
      data: {
        'id_categoria': categoriaId,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio_base': precio,
        if (duracionEstimada != null && duracionEstimada.isNotEmpty)
          'duracion_estimada': duracionEstimada,
        if (imagenPrincipal != null && imagenPrincipal.isNotEmpty)
          'imagen_url': imagenPrincipal,
      },
    );
    return Servicio.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Update servicio
  Future<Servicio> updateServicio({
    required int id,
    int? categoriaId,
    String? nombre,
    String? descripcion,
    double? precio,
    String? duracionEstimada,
    String? imagenPrincipal,
    List<String>? imagenesAdicionales,
    String? videoUrl,
    String? estado,
  }) async {
    final data = <String, dynamic>{};
    if (categoriaId != null) data['id_categoria'] = categoriaId;
    if (nombre != null) data['nombre'] = nombre;
    if (descripcion != null) data['descripcion'] = descripcion;
    if (precio != null) data['precio'] = precio;
    if (duracionEstimada != null) data['duracion_estimada'] = duracionEstimada;
    if (imagenPrincipal != null) data['imagen_principal'] = imagenPrincipal;
    if (imagenesAdicionales != null) data['imagenes_adicionales'] = imagenesAdicionales;
    if (videoUrl != null) data['video_url'] = videoUrl;
    if (estado != null) data['estado'] = estado;

    final response = await _dioClient.put('/servicios/$id', data: data);
    return Servicio.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Delete servicio
  Future<void> deleteServicio(int id) async {
    await _dioClient.delete('/servicios/$id');
  }

  // Upload servicio image
  Future<String> uploadServicioImage(String filePath) async {
    final response = await _dioClient.uploadFile(
      '/servicios/upload-image',
      filePath,
      'imagen',
    );
    return response.data['data']['url'] as String;
  }

  // Add servicio to sucursal
  Future<void> addServicioToSucursal({
    required int servicioId,
    required int sucursalId,
    double? precioSucursal,
  }) async {
    await _dioClient.post(
      '/servicios/$servicioId/sucursales',
      data: {
        'id_sucursal': sucursalId,
        if (precioSucursal != null) 'precio_sucursal': precioSucursal,
      },
    );
  }
}
