import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/servicio.dart';

class ChatbotService {
  final DioClient _dioClient = DioClient();

  Future<Map<String, dynamic>> sendMessage(String message, List<Map<String, String>> history) async {
    try {
      final response = await _dioClient.post(
        '/chatbot/chat',
        data: {
          'message': message,
          'history': history,
        },
      );

      final data = response.data['data'];
      
      List<Servicio> recommendedServices = [];
      if (data['services'] != null) {
        recommendedServices = (data['services'] as List)
            .map((s) => Servicio.fromJson(s))
            .toList();
      }

      return {
        'message': data['message'],
        'services': recommendedServices,
      };
    } catch (e) {
      rethrow;
    }
  }
}
