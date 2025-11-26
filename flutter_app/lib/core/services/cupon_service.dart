import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/cupon.dart';

class CuponService {
  final DioClient _dioClient = DioClient();

  // Validar cupón (Ya lo tenías)
  Future<Map<String, dynamic>> validateCupon({
    required String codigo,
    required int servicioId,
    required double montoCompra,
  }) async {
    try {
      final response = await _dioClient.post('/cupones/validar', data: {
        'codigo': codigo,
        'servicio_id': servicioId,
        'monto_compra': montoCompra,
      });
      return response.data;
    } catch (e) {
      return {'valido': false, 'mensaje': 'Error de conexión o cupón inválido'};
    }
  }

  // Nuevo: Crear cupón
  Future<bool> createCupon(Map<String, dynamic> cuponData) async {
    try {
      await _dioClient.post('/cupones', data: cuponData);
      return true;
    } catch (e) {
      throw e;
    }
  }

  // Actualizar
  Future<bool> updateCupon(int id, Map<String, dynamic> data) async {
    try {
      await _dioClient.put('/cupones/$id', data: data);
      return true;
    } catch (e) {
      print('Error actualizando cupón: $e');
      return false;
    }
  }

  // Eliminar
  Future<bool> deleteCupon(int id) async {
    try {
      await _dioClient.delete('/cupones/$id');
      return true;
    } catch (e) {
      print('Error eliminando cupón: $e');
      return false;
    }
  }

  // Nuevo: Obtener cupones de la empresa
  Future<List<Cupon>> getEmpresaCupones(int empresaId) async {
    try {
      final response = await _dioClient.get('/cupones');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Cupon.fromJson(json)).toList();
    } catch (e) {
      print('Error obteniendo cupones: $e');
      return [];
    }
  }

  // Nuevo: Alternar estado (Activar/Desactivar) - Opcional si quieres agregar switch
  Future<void> toggleEstado(int idCupon, bool activo) async {
    await _dioClient.put('/cupones/$idCupon/estado', data: {'activo': activo});
  }
}
