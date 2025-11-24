import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/conversacion.dart';
import 'package:servicios_app/core/models/mensaje.dart';

class ChatService {
  final DioClient _dioClient = DioClient();

  // Get all conversaciones
  Future<List<Conversacion>> getConversaciones() async {
    final response = await _dioClient.get('/conversaciones');
    return (response.data['data'] as List)
        .map((e) => Conversacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get conversacion by ID
  Future<Conversacion> getConversacionById(int id) async {
    final response = await _dioClient.get('/conversaciones/$id');
    return Conversacion.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Create conversacion
  Future<Conversacion> createConversacion({
    required int idEmpresa,
    int? idContratacion,
  }) async {
    final response = await _dioClient.post(
      '/conversaciones',
      data: {
        'id_empresa': idEmpresa,
        if (idContratacion != null) 'id_contratacion': idContratacion,
      },
    );
    return Conversacion.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Get mensajes from conversacion
  Future<List<Mensaje>> getMensajes(int conversacionId) async {
    final response = await _dioClient.get('/conversaciones/$conversacionId/mensajes');
    return (response.data['data'] as List)
        .map((e) => Mensaje.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Send mensaje
  Future<Mensaje> sendMensaje({
    required int conversacionId,
    required String contenido,
  }) async {
    final response = await _dioClient.post(
      '/conversaciones/$conversacionId/mensajes',
      data: {'contenido': contenido},
    );
    return Mensaje.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Mark mensajes as read
  Future<void> markAsRead(int conversacionId) async {
    await _dioClient.patch('/conversaciones/$conversacionId/marcar-leido');
  }
}
