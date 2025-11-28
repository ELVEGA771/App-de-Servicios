import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/sucursal.dart';
import 'package:servicios_app/core/models/api_response.dart';
import 'package:servicios_app/config/constants.dart';

class SucursalService {
  final DioClient _dioClient = DioClient();

  // Get all sucursales with pagination
  Future<ApiResponse<List<Sucursal>>> getAllSucursales({
    int page = 1,
    int limit = AppConstants.DEFAULT_PAGE_SIZE,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    final response =
        await _dioClient.get('/sucursales', queryParameters: queryParams);

    final sucursales = (response.data['data'] as List)
        .map((e) => Sucursal.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: response.data['success'] as bool,
      data: sucursales,
      message: response.data['message'] as String?,
      pagination: response.data['pagination'] != null
          ? PaginationData.fromJson(
              response.data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Get only active sucursales
  Future<List<Sucursal>> getActiveSucursales() async {
    final response = await _dioClient.get('/sucursales/active');
    return (response.data['data'] as List)
        .map((e) => Sucursal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get sucursal by ID
  Future<Sucursal> getSucursalById(int id) async {
    final response = await _dioClient.get('/sucursales/$id');
    return Sucursal.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Create sucursal (Empresa only)
  Future<Sucursal> createSucursal({
    required String nombreSucursal,
    String? telefono,
    // Email eliminado
    String? horarioApertura,
    String? horarioCierre,
    String? diasLaborales,
    required String callePrincipal,
    String? calleSecundaria,
    String? numero,
    required String ciudad,
    required String provinciaEstado,
    String? codigoPostal,
    String? pais,
    double? latitud,
    double? longitud,
    String? referencia,
  }) async {
    final response = await _dioClient.post(
      '/sucursales',
      data: {
        'nombre_sucursal': nombreSucursal,
        if (telefono != null && telefono.isNotEmpty) 'telefono': telefono,
        // Nuevos campos
        if (horarioApertura != null) 'horario_apertura': horarioApertura,
        if (horarioCierre != null) 'horario_cierre': horarioCierre,
        if (diasLaborales != null) 'dias_laborales': diasLaborales,

        'calle_principal': callePrincipal,
        if (calleSecundaria != null && calleSecundaria.isNotEmpty)
          'calle_secundaria': calleSecundaria,
        if (numero != null && numero.isNotEmpty) 'numero': numero,
        'ciudad': ciudad,
        'provincia_estado': provinciaEstado,
        if (codigoPostal != null && codigoPostal.isNotEmpty)
          'codigo_postal': codigoPostal,
        if (pais != null && pais.isNotEmpty) 'pais': pais,
        if (latitud != null) 'latitud': latitud,
        if (longitud != null) 'longitud': longitud,
        if (referencia != null && referencia.isNotEmpty)
          'referencia': referencia,
      },
    );
    return Sucursal.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Update sucursal
  Future<Sucursal> updateSucursal({
    required int id,
    String? nombreSucursal,
    String? telefono,
    // Email eliminado
    String? horarioApertura,
    String? horarioCierre,
    String? diasLaborales,
    String? callePrincipal,
    String? calleSecundaria,
    String? numero,
    String? ciudad,
    String? provinciaEstado,
    String? codigoPostal,
    String? pais,
    double? latitud,
    double? longitud,
    String? referencia,
    String? estado,
  }) async {
    final data = <String, dynamic>{};
    if (nombreSucursal != null) data['nombre_sucursal'] = nombreSucursal;
    if (telefono != null) data['telefono'] = telefono;
    // Nuevos campos
    if (horarioApertura != null) data['horario_apertura'] = horarioApertura;
    if (horarioCierre != null) data['horario_cierre'] = horarioCierre;
    if (diasLaborales != null) data['dias_laborales'] = diasLaborales;

    if (callePrincipal != null) data['calle_principal'] = callePrincipal;
    if (calleSecundaria != null) data['calle_secundaria'] = calleSecundaria;
    if (numero != null) data['numero'] = numero;
    if (ciudad != null) data['ciudad'] = ciudad;
    if (provinciaEstado != null) data['provincia_estado'] = provinciaEstado;
    if (codigoPostal != null) data['codigo_postal'] = codigoPostal;
    if (pais != null) data['pais'] = pais;
    if (latitud != null) data['latitud'] = latitud;
    if (longitud != null) data['longitud'] = longitud;
    if (referencia != null) data['referencia'] = referencia;
    if (estado != null) data['estado'] = estado;

    final response = await _dioClient.put('/sucursales/$id', data: data);
    return Sucursal.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Delete sucursal (set to inactive)
  Future<void> deleteSucursal(int id) async {
    await _dioClient.delete('/sucursales/$id');
  }

  // Reactivate sucursal (set to active)
  Future<void> reactivateSucursal(int id) async {
    await _dioClient.patch('/sucursales/$id/reactivate');
  }

  // Get servicios for a sucursal
  Future<List<dynamic>> getSucursalServicios(int id) async {
    final response = await _dioClient.get('/sucursales/$id/servicios');
    return response.data['data'] as List;
  }

  // Get sucursales by empresa (authenticated)
  Future<List<Sucursal>> getSucursalesByEmpresa(int empresaId) async {
    // Use the authenticated endpoint that returns sucursales for the logged-in empresa
    final response = await _dioClient.get('/sucursales', queryParameters: {'limit': 100});
    return (response.data['data'] as List)
        .map((e) => Sucursal.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
