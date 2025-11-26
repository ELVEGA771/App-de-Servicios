import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/notificacion.dart';

class NotificacionService {
  final DioClient _dioClient = DioClient();

  // Get all notificaciones
  Future<List<Notificacion>> getNotificaciones() async {
    final response = await _dioClient.get('/notificaciones');
    return (response.data['data'] as List)
        .map((e) => Notificacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    final response = await _dioClient.get('/notificaciones/no-leidas/count');
    return response.data['data']['count'] as int;
  }

  // Mark notificacion as read
  Future<void> markAsRead(int id) async {
    await _dioClient.put('/notificaciones/$id/leer');
  }

  // Toggle read status
  Future<bool> toggleRead(int id) async {
    final response = await _dioClient.put('/notificaciones/$id/toggle');
    return response.data['data']['leida'] as bool;
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    await _dioClient.put('/notificaciones/leer-todas');
  }

  // Delete notificacion
  Future<void> deleteNotificacion(int id) async {
    await _dioClient.delete('/notificaciones/$id');
  }
}
