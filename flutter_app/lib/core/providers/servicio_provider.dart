import 'package:flutter/foundation.dart';
import 'package:servicios_app/core/models/servicio.dart';
import 'package:servicios_app/core/models/api_response.dart';
import 'package:servicios_app/core/models/categoria.dart';
import 'package:servicios_app/core/services/servicio_service.dart';
import 'package:servicios_app/core/services/categoria_service.dart';

class ServicioProvider with ChangeNotifier {
  final ServicioService _servicioService = ServicioService();
  final CategoriaService _categoriaService = CategoriaService();

  List<Servicio> _servicios = [];
  List<Categoria> _categorias = [];
  Servicio? _selectedServicio;
  PaginationData? _pagination;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // Filters
  int? _selectedCategoriaId;
  String? _selectedCiudad;
  double? _precioMin;
  double? _precioMax;
  double? _calificacionMin;
  String? _searchQuery;
  String? _ordenar;

  // Getters
  List<Servicio> get servicios => _servicios;
  List<Categoria> get categorias => _categorias;
  Servicio? get selectedServicio => _selectedServicio;
  PaginationData? get pagination => _pagination;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _pagination?.hasNextPage ?? false;

  // Filter getters
  int? get selectedCategoriaId => _selectedCategoriaId;
  String? get selectedCiudad => _selectedCiudad;
  double? get precioMin => _precioMin;
  double? get precioMax => _precioMax;
  double? get calificacionMin => _calificacionMin;
  String? get searchQuery => _searchQuery;
  String? get ordenar => _ordenar;

  // Load categorias
  Future<void> loadCategorias() async {
    try {
      _categorias = await _categoriaService.getAllCategorias();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Load servicios
  Future<void> loadServicios({bool refresh = false}) async {
    if (refresh) {
      _setLoading(true);
      _servicios = [];
      _pagination = null;
    }

    try {
      final response = await _servicioService.getAllServicios(
        page: refresh ? 1 : (_pagination?.page ?? 0) + 1,
        categoriaId: _selectedCategoriaId,
        ciudad: _selectedCiudad,
        precioMin: _precioMin,
        precioMax: _precioMax,
        calificacionMin: _calificacionMin,
        busqueda: _searchQuery,
        ordenar: _ordenar,
      );

      if (refresh) {
        _servicios = response.data ?? [];
      } else {
        _servicios.addAll(response.data ?? []);
      }
      _pagination = response.pagination;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load more servicios (pagination)
  Future<void> loadMoreServicios() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _servicioService.getAllServicios(
        page: (_pagination?.page ?? 0) + 1,
        categoriaId: _selectedCategoriaId,
        ciudad: _selectedCiudad,
        precioMin: _precioMin,
        precioMax: _precioMax,
        calificacionMin: _calificacionMin,
        busqueda: _searchQuery,
        ordenar: _ordenar,
      );

      _servicios.addAll(response.data ?? []);
      _pagination = response.pagination;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Search servicios
  Future<void> searchServicios(String query) async {
    _searchQuery = query;
    await loadServicios(refresh: true);
  }

  // Load servicio details
  Future<void> loadServicioDetails(int id) async {
    _setLoading(true);
    try {
      _selectedServicio = await _servicioService.getServicioById(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Set filters
  void setFilters({
    int? categoriaId,
    String? ciudad,
    double? precioMin,
    double? precioMax,
    double? calificacionMin,
    String? ordenar,
  }) {
    _selectedCategoriaId = categoriaId;
    _selectedCiudad = ciudad;
    _precioMin = precioMin;
    _precioMax = precioMax;
    _calificacionMin = calificacionMin;
    _ordenar = ordenar;
    loadServicios(refresh: true);
  }

  // Clear filters
  void clearFilters() {
    _selectedCategoriaId = null;
    _selectedCiudad = null;
    _precioMin = null;
    _precioMax = null;
    _calificacionMin = null;
    _searchQuery = null;
    _ordenar = null;
    loadServicios(refresh: true);
  }

  // Create servicio (for empresas)
  Future<bool> createServicio({
    required int categoriaId,
    required String nombre,
    required String descripcion,
    required double precio,
    String? duracionEstimada,
    String? imagenPrincipal,
    List<String>? imagenesAdicionales,
    String? videoUrl,
  }) async {
    _setLoading(true);
    try {
      await _servicioService.createServicio(
        categoriaId: categoriaId,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        duracionEstimada: duracionEstimada,
        imagenPrincipal: imagenPrincipal,
        imagenesAdicionales: imagenesAdicionales,
        videoUrl: videoUrl,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update servicio
  Future<bool> updateServicio({
    required int id,
    int? categoriaId,
    String? nombre,
    String? descripcion,
    double? precio,
    String? duracionEstimada,
    String? imagenPrincipal,
    List<String>? imagenesAdicionales,
    String? videoUrl,
    String? estado,
  }) async {
    _setLoading(true);
    try {
      await _servicioService.updateServicio(
        id: id,
        categoriaId: categoriaId,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        duracionEstimada: duracionEstimada,
        imagenPrincipal: imagenPrincipal,
        imagenesAdicionales: imagenesAdicionales,
        videoUrl: videoUrl,
        estado: estado,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete servicio
  Future<bool> deleteServicio(int id) async {
    _setLoading(true);
    try {
      await _servicioService.deleteServicio(id);
      _servicios.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
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
