import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/direccion.dart';

class DireccionService {
  final DioClient _dioClient = DioClient();

  // Obtener todas las direcciones del cliente
  Future<List<Direccion>> getDirecciones() async {
    final response = await _dioClient.get('/direcciones');
    // Asumiendo que el backend devuelve { success: true, data: [...] }
    final list = response.data['data'] as List;
    return list.map((e) => Direccion.fromJson(e)).toList();
  }

  // Crear nueva dirección
  Future<Direccion> createDireccion(Map<String, dynamic> data) async {
    final response = await _dioClient.post('/direcciones', data: data);
    return Direccion.fromJson(response.data['data']);
  }

  // Eliminar dirección
  Future<void> deleteDireccion(int id) async {
    await _dioClient.delete('/direcciones/$id');
  }

  // Marcar como principal (opcional, si tu backend lo soporta)
  Future<void> setPrincipal(int id) async {
    await _dioClient.put('/direcciones/$id/principal');
  }
}
