import 'package:flutter/foundation.dart';
import 'package:servicios_app/core/models/notificacion.dart';
import 'package:servicios_app/core/services/notificacion_service.dart';

class NotificacionProvider with ChangeNotifier {
  final NotificacionService _notificacionService = NotificacionService();

  List<Notificacion> _notificaciones = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Notificacion> get notificaciones => _notificaciones;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Notificacion> get unreadNotificaciones {
    return _notificaciones.where((n) => !n.leida).toList();
  }

  // Load notificaciones
  Future<void> loadNotificaciones() async {
    _setLoading(true);
    _error = null;
    try {
      _notificaciones = await _notificacionService.getNotificaciones();
      _unreadCount = await _notificacionService.getUnreadCount();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Refresh unread count
  Future<void> refreshUnreadCount() async {
    try {
      _unreadCount = await _notificacionService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      // Silent fail
    }
  }

  // Mark as read
  Future<bool> markAsRead(int id) async {
    _error = null;
    try {
      await _notificacionService.markAsRead(id);

      final index = _notificaciones.indexWhere((n) => n.id == id);
      if (index != -1) {
        if (!_notificaciones[index].leida) {
          _notificaciones[index] = _notificaciones[index].copyWith(leida: true);
          _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
          notifyListeners();
        }
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Toggle read status
  Future<bool> toggleRead(int id) async {
    _error = null;
    try {
      final newStatus = await _notificacionService.toggleRead(id);

      final index = _notificaciones.indexWhere((n) => n.id == id);
      if (index != -1) {
        final oldStatus = _notificaciones[index].leida;
        _notificaciones[index] = _notificaciones[index].copyWith(leida: newStatus);
        
        if (oldStatus != newStatus) {
          if (newStatus) {
            _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
          } else {
            _unreadCount++;
          }
        }
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Mark all as read
  Future<bool> markAllAsRead() async {
    _error = null;
    try {
      await _notificacionService.markAllAsRead();

      _notificaciones = _notificaciones.map((n) => n.copyWith(leida: true)).toList();
      _unreadCount = 0;
      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Delete notificacion
  Future<bool> deleteNotificacion(int id) async {
    _error = null;
    try {
      await _notificacionService.deleteNotificacion(id);

      final wasUnread = _notificaciones.firstWhere((n) => n.id == id).leida == false;
      _notificaciones.removeWhere((n) => n.id == id);

      if (wasUnread) {
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
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
