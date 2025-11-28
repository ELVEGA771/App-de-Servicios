import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:servicios_app/core/models/contratacion.dart';
import 'package:servicios_app/core/models/api_response.dart';
import 'package:servicios_app/core/services/contratacion_service.dart';

class ContratacionProvider with ChangeNotifier {
  final ContratacionService _contratacionService = ContratacionService();

  List<Contratacion> _contrataciones = [];
  Contratacion? _selectedContratacion;
  PaginationData? _pagination;
  Map<String, dynamic>? _estadisticas;
  bool _isLoading = false;
  final bool _isLoadingMore = false;
  String? _error;

  // Historial
  List<HistorialContratacion> _historial = [];

  // Getters
  List<Contratacion> get contrataciones => _contrataciones;
  Contratacion? get selectedContratacion => _selectedContratacion;
  PaginationData? get pagination => _pagination;
  Map<String, dynamic>? get estadisticas => _estadisticas;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _pagination?.hasNextPage ?? false;
  List<HistorialContratacion> get historial => _historial;

  // Helper: notify safely (immediately when safe, otherwise post-frame)
  void _safeNotify() {
    if (!hasListeners) return;
    final binding = WidgetsBinding.instance;
    if (binding == null) {
      notifyListeners();
      return;
    }

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
    } else {
      binding.addPostFrameCallback((_) {
        if (hasListeners) notifyListeners();
      });
    }
  }

  // Filter contrataciones by status
  List<Contratacion> getContratacionesByEstado(String estado) {
    return _contrataciones.where((c) => c.estado == estado).toList();
  }

  List<Contratacion> get contratacionesActivas {
    return _contrataciones.where((c) => c.isActive).toList();
  }

  List<Contratacion> get contratacionesCompletadas {
    return _contrataciones.where((c) => c.isCompleted).toList();
  }

  // Load contrataciones (cliente)
  Future<void> loadContratacionesCliente({
    bool refresh = false,
    String? estado,
  }) async {
    if (refresh) {
      _setLoading(true);
      _contrataciones = [];
      _pagination = null;
    }

    try {
      final response = await _contratacionService.getContratacionesByCliente(
        page: refresh ? 1 : (_pagination?.page ?? 0) + 1,
        estado: estado,
      );

      if (refresh) {
        _contrataciones = response.data ?? [];
      } else {
        _contrataciones.addAll(response.data ?? []);
      }
      _pagination = response.pagination;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load contrataciones (empresa)
  Future<void> loadContratacionesEmpresa({
    bool refresh = false,
    String? estado,
  }) async {
    if (refresh) {
      _setLoading(true);
      _contrataciones = [];
      _pagination = null;
    }

    try {
      final response = await _contratacionService.getContratacionesByEmpresa(
        page: refresh ? 1 : (_pagination?.page ?? 0) + 1,
        estado: estado,
      );

      if (refresh) {
        _contrataciones = response.data ?? [];
      } else {
        _contrataciones.addAll(response.data ?? []);
      }
      _pagination = response.pagination;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load contratacion details
  Future<void> loadContratacionDetails(int id) async {
    _setLoading(true);
    try {
      _selectedContratacion =
          await _contratacionService.getContratacionById(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create contratacion
  Future<Contratacion?> createContratacion({
    required int servicioId,
    required int sucursalId,
    int? direccionId,
    DateTime? fechaProgramada,
    String? codigoCupon,
    String? metodoPago,
    String? notas,
    double? precioSubtotal,
    double? descuentoAplicado,
    double? precioTotal,
  }) async {
    _setLoading(true);
    try {
      final contratacion = await _contratacionService.createContratacion(
        servicioId: servicioId,
        sucursalId: sucursalId,
        direccionId: direccionId,
        fechaProgramada: fechaProgramada,
        codigoCupon: codigoCupon,
        metodoPago: metodoPago,
        notas: notas,
        precioSubtotal: precioSubtotal,
        descuentoAplicado: descuentoAplicado,
        precioTotal: precioTotal,
      );
      _contrataciones.insert(0, contratacion);
      _safeNotify();
      return contratacion;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update contratacion status
  Future<bool> updateEstado({
    required int id,
    required String nuevoEstado,
    String? notas,
  }) async {
    _setLoading(true);
    try {
      final updated = await _contratacionService.updateEstado(
        id: id,
        nuevoEstado: nuevoEstado,
        notas: notas,
      );

      // Update in list
      final index = _contrataciones.indexWhere((c) => c.id == id);
      if (index != -1) {
        _contrataciones[index] = updated;
      }

      // Update selected
      if (_selectedContratacion?.id == id) {
        _selectedContratacion = updated;
      }

      _safeNotify();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cancel contratacion
  Future<bool> cancelContratacion({
    required int id,
    String? motivo,
  }) async {
    _setLoading(true);
    try {
      final updated = await _contratacionService.cancelContratacion(
        id: id,
        motivo: motivo,
      );

      // Update in list
      final index = _contrataciones.indexWhere((c) => c.id == id);
      if (index != -1) {
        _contrataciones[index] = updated;
      }

      // Update selected
      if (_selectedContratacion?.id == id) {
        _selectedContratacion = updated;
      }

      _safeNotify();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load estadisticas (for empresa dashboard)
  Future<void> loadEstadisticas() async {
    try {
      _estadisticas = await _contratacionService.getEstadisticas();
      _safeNotify();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Load historial (empresa)
  Future<void> loadHistorialEmpresa({bool refresh = false}) async {
    if (refresh) {
      _setLoading(true);
      _historial = [];
    }

    try {
      final response = await _contratacionService.getHistorialEmpresa(
        page: refresh ? 1 : 1, // Simple pagination for now
      );
      _historial = response.data ?? [];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
    _safeNotify();
  }

  void _setError(String message) {
    _error = message;
    _safeNotify();
  }

  void clearError() {
    _error = null;
    _safeNotify();
  }
}
