import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/calificacion.dart';

class CalificacionService {
  final DioClient _dioClient = DioClient();

  // Get calificaciones by empresa
  Future<List<Calificacion>> getCalificacionesByEmpresa(int empresaId) async {
    final response = await _dioClient.get('/calificaciones/empresa/$empresaId');
    return (response.data['data'] as List)
        .map((e) => Calificacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Create calificacion
  Future<Calificacion> createCalificacion({
    required int contratacionId,
    required int calificacion,
    String? comentario,
  }) async {
    final response = await _dioClient.post(
      '/calificaciones',
      data: {
        'id_contratacion': contratacionId,
        'calificacion': calificacion,
        if (comentario != null) 'comentario': comentario,
      },
    );
    return Calificacion.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Check if contratacion can be rated
  Future<bool> canRateContratacion(int contratacionId) async {
    try {
      final response = await _dioClient.get('/calificaciones/can-rate/$contratacionId');
      return response.data['data']['can_rate'] as bool;
    } catch (e) {
      return false;
    }
  }
}
