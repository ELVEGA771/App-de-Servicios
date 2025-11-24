import 'package:servicios_app/core/api/dio_client.dart';

class EmpresaService {
  final DioClient _dioClient = DioClient();

  // Get empresa statistics
  Future<Map<String, dynamic>> getEmpresaStatistics(int empresaId) async {
    final response = await _dioClient.get('/empresas/$empresaId/estadisticas');
    return response.data['data'] as Map<String, dynamic>;
  }

  // Get empresa services
  Future<List<Map<String, dynamic>>> getEmpresaServices(int empresaId) async {
    final response = await _dioClient.get('/servicios/empresa/$empresaId');
    final data = response.data['data'] as List;
    return data.cast<Map<String, dynamic>>();
  }
}
