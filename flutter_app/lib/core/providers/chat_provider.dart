import 'package:flutter/foundation.dart';
import 'package:servicios_app/core/models/conversacion.dart';
import 'package:servicios_app/core/models/mensaje.dart';
import 'package:servicios_app/core/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Conversacion> _conversaciones = [];
  Conversacion? _selectedConversacion;
  List<Mensaje> _mensajes = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  // Getters
  List<Conversacion> get conversaciones => _conversaciones;
  Conversacion? get selectedConversacion => _selectedConversacion;
  List<Mensaje> get mensajes => _mensajes;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;

  int get unreadCount {
    return _conversaciones
        .where((c) => c.hasUnreadMessages)
        .fold(0, (sum, c) => sum + (c.mensajesNoLeidos ?? 0));
  }

  // Load conversaciones
  Future<void> loadConversaciones() async {
    _setLoading(true);
    try {
      _conversaciones = await _chatService.getConversaciones();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load conversacion details
  Future<void> loadConversacion(int id) async {
    _setLoading(true);
    try {
      _selectedConversacion = await _chatService.getConversacionById(id);
      await loadMensajes(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create conversacion
  Future<Conversacion?> createConversacion({
    required int idEmpresa,
    int? idContratacion,
  }) async {
    _setLoading(true);
    try {
      final conversacion = await _chatService.createConversacion(
        idEmpresa: idEmpresa,
        idContratacion: idContratacion,
      );
      _conversaciones.insert(0, conversacion);
      _selectedConversacion = conversacion;
      notifyListeners();
      return conversacion;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Load mensajes
  Future<void> loadMensajes(int conversacionId) async {
    try {
      _mensajes = await _chatService.getMensajes(conversacionId);
      await _chatService.markAsRead(conversacionId);

      // Update conversacion unread count
      final index = _conversaciones.indexWhere((c) => c.id == conversacionId);
      if (index != -1) {
        _conversaciones[index] = _conversaciones[index].copyWith(
          mensajesNoLeidos: 0,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Send mensaje
  Future<bool> sendMensaje({
    required int conversacionId,
    required String contenido,
  }) async {
    _isSending = true;
    notifyListeners();

    try {
      final mensaje = await _chatService.sendMensaje(
        conversacionId: conversacionId,
        contenido: contenido,
      );
      _mensajes.add(mensaje);

      // Update conversacion's last message
      final index = _conversaciones.indexWhere((c) => c.id == conversacionId);
      if (index != -1) {
        _conversaciones[index] = _conversaciones[index].copyWith(
          ultimoMensaje: contenido,
          fechaUltimoMensaje: mensaje.fechaEnvio,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  // Refresh mensajes (for real-time updates simulation)
  Future<void> refreshMensajes(int conversacionId) async {
    try {
      final newMensajes = await _chatService.getMensajes(conversacionId);
      if (newMensajes.length > _mensajes.length) {
        _mensajes = newMensajes;
        notifyListeners();
      }
    } catch (e) {
      // Silent fail for refresh
    }
  }

  // Clear current conversation
  void clearCurrentConversation() {
    _selectedConversacion = null;
    _mensajes = [];
    notifyListeners();
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
