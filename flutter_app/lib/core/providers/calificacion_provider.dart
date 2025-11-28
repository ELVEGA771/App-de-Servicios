import 'package:flutter/material.dart';
import 'package:servicios_app/core/services/calificacion_service.dart';

class CalificacionProvider with ChangeNotifier {
  final CalificacionService _calificacionService = CalificacionService();
  
  List<dynamic> _pendingRatings = [];
  bool _isLoading = false;

  List<dynamic> get pendingRatings => _pendingRatings;
  bool get isLoading => _isLoading;

  Future<void> checkPendingRatings() async {
    _isLoading = true;
    notifyListeners();
    try {
      print('DEBUG: Checking pending ratings...');
      _pendingRatings = await _calificacionService.getPendingRatings();
      print('DEBUG: Pending ratings found: ${_pendingRatings.length}');
    } catch (e) {
      print('DEBUG: Error checking pending ratings: $e');
      _pendingRatings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitRating({
    required int idContratacion,
    required int calificacion,
    required String comentario,
  }) async {
    try {
      await _calificacionService.createCalificacion(
        contratacionId: idContratacion,
        calificacion: calificacion,
        comentario: comentario,
      );
      // Remove from local list
      _pendingRatings.removeWhere((r) => r['id_contratacion'] == idContratacion);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
