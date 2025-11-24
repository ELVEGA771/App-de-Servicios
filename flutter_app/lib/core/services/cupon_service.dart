import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/cupon.dart';

class CuponService {
  final DioClient _dioClient = DioClient();

  // Validate cupon
  Future<Map<String, dynamic>> validateCupon({
    required String codigo,
    required int servicioId,
    required double montoCompra,
  }) async {
    final response = await _dioClient.post(
      '/cupones/validar',
      data: {
        'codigo': codigo,
        'id_servicio': servicioId,
        'monto_compra': montoCompra,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // Get cupones by empresa (for empresa dashboard)
  Future<List<Cupon>> getCuponesByEmpresa() async {
    final response = await _dioClient.get('/cupones/empresa');
    return (response.data['data'] as List)
        .map((e) => Cupon.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Create cupon (empresa only)
  Future<Cupon> createCupon({
    required String codigo,
    String? descripcion,
    required String tipoDescuento,
    required double valorDescuento,
    double? montoMinimo,
    double? descuentoMaximo,
    DateTime? fechaInicio,
    DateTime? fechaExpiracion,
    int? usosMaximos,
  }) async {
    final response = await _dioClient.post(
      '/cupones',
      data: {
        'codigo': codigo,
        'descripcion': descripcion,
        'tipo_descuento': tipoDescuento,
        'valor_descuento': valorDescuento,
        'monto_minimo': montoMinimo,
        'descuento_maximo': descuentoMaximo,
        'fecha_inicio': fechaInicio?.toIso8601String(),
        'fecha_expiracion': fechaExpiracion?.toIso8601String(),
        'usos_maximos': usosMaximos,
      },
    );
    return Cupon.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Update cupon
  Future<Cupon> updateCupon(int id, Map<String, dynamic> data) async {
    final response = await _dioClient.put('/cupones/$id', data: data);
    return Cupon.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Delete cupon
  Future<void> deleteCupon(int id) async {
    await _dioClient.delete('/cupones/$id');
  }
}
