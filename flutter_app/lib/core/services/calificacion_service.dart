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
  Future<void> createCalificacion({
    required int contratacionId,
    required int calificacion,
    String? comentario,
  }) async {
    await _dioClient.post(
      '/calificaciones',
      data: {
        'id_contratacion': contratacionId,
        'calificacion': calificacion,
        if (comentario != null) 'comentario': comentario,
      },
    );
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

  Future<List<dynamic>> getPendingRatings() async {
    try {
      final response = await _dioClient.get('/calificaciones/pendientes');
      print('DEBUG: getPendingRatings raw response: ${response.data}');

      if (response.data == null) {
        print('DEBUG: Response data is null');
        return [];
      }

      // Caso 1: Respuesta estándar { success: true, data: [...] }
      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('data')) {
          final data = response.data['data'];
          if (data is List) {
            return data;
          } else if (data == null) {
            return [];
          }
        }
      }

      // Caso 2: Respuesta directa es una lista [...]
      if (response.data is List) {
        return response.data;
      }

      print('DEBUG: Unexpected response format');
      return [];
    } catch (e) {
      print('DEBUG: Exception in getPendingRatings service: $e');
      rethrow;
    }
  }
}
