import 'package:flutter/foundation.dart';
import 'package:servicios_app/core/models/favorito.dart';
import 'package:servicios_app/core/services/favorito_service.dart';

class FavoritoProvider with ChangeNotifier {
  final FavoritoService _favoritoService = FavoritoService();

  List<Favorito> _favoritos = [];
  Set<int> _favoritoIds = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Favorito> get favoritos => _favoritos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get count => _favoritos.length;

  // Check if servicio is favorito
  bool isFavorito(int servicioId) {
    return _favoritoIds.contains(servicioId);
  }

  // Load favoritos
  Future<void> loadFavoritos() async {
    _setLoading(true);
    try {
      _favoritos = await _favoritoService.getFavoritos();
      _favoritoIds = _favoritos.map((f) => f.idServicio).toSet();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add favorito
  Future<bool> addFavorito(int servicioId) async {
    try {
      final favorito = await _favoritoService.addFavorito(servicioId);
      _favoritos.insert(0, favorito);
      _favoritoIds.add(servicioId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Remove favorito
  Future<bool> removeFavorito(int servicioId) async {
    try {
      await _favoritoService.removeFavorito(servicioId);
      _favoritos.removeWhere((f) => f.idServicio == servicioId);
      _favoritoIds.remove(servicioId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Toggle favorito
  Future<bool> toggleFavorito(int servicioId) async {
    if (isFavorito(servicioId)) {
      return await removeFavorito(servicioId);
    } else {
      return await addFavorito(servicioId);
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
