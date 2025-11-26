import 'package:flutter/material.dart';
import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/direccion.dart';

class DireccionProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();
  
  List<Direccion> _direcciones = [];
  Direccion? _selectedDireccion;
  bool _isLoading = false;
  String? _error;

  List<Direccion> get direcciones => _direcciones;
  Direccion? get selectedDireccion => _selectedDireccion;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Cargar todas las direcciones
  Future<void> loadDirecciones() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dioClient.get('/direcciones');
      final List<dynamic> data = response.data['data'];
      _direcciones = data.map((json) => Direccion.fromJson(json)).toList();
      
      // Si no hay dirección seleccionada, seleccionar la principal o la primera
      if (_selectedDireccion == null && _direcciones.isNotEmpty) {
        try {
          _selectedDireccion = _direcciones.firstWhere((d) => d.esPrincipal);
        } catch (e) {
          _selectedDireccion = _direcciones.first;
        }
      } else if (_selectedDireccion != null) {
        // Actualizar la seleccionada con los datos nuevos si existe
        try {
          _selectedDireccion = _direcciones.firstWhere((d) => d.id == _selectedDireccion!.id);
        } catch (e) {
          // Si la seleccionada ya no existe (fue borrada), seleccionar otra
          if (_direcciones.isNotEmpty) {
             try {
              _selectedDireccion = _direcciones.firstWhere((d) => d.esPrincipal);
            } catch (e) {
              _selectedDireccion = _direcciones.first;
            }
          } else {
            _selectedDireccion = null;
          }
        }
      }
      
    } catch (e) {
      _error = e.toString();
      print('Error loading direcciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Seleccionar una dirección localmente (para la sesión actual)
  void selectDireccion(Direccion direccion) {
    _selectedDireccion = direccion;
    notifyListeners();
  }

  // Crear nueva dirección
  Future<bool> addDireccion(Direccion direccion) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Convertir a JSON pero remover ID si es 0 o null (el backend lo genera)
      final data = direccion.toJson();
      data.remove('id');
      data.remove('id_cliente'); // El backend lo toma del token

      await _dioClient.post('/direcciones', data: data);
      
      // Recargar lista
      await loadDirecciones();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error adding direccion: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar dirección
  Future<bool> updateDireccion(Direccion direccion) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = direccion.toJson();
      data.remove('id_cliente'); // No se debe actualizar el cliente

      await _dioClient.put('/direcciones/${direccion.id}', data: data);
      
      // Recargar lista
      await loadDirecciones();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error updating direccion: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar dirección
  Future<bool> deleteDireccion(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dioClient.delete('/direcciones/$id');
      
      // Recargar lista
      await loadDirecciones();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error deleting direccion: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Establecer como principal
  Future<bool> setPrincipal(int id) async {
    // Optimistic update
    final index = _direcciones.indexWhere((d) => d.id == id);
    if (index != -1) {
      // Desmarcar todas
      // Esto es complejo de hacer optimista sin recargar, mejor recargamos
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Asumiendo que el backend maneja la lógica de desmarcar las otras
      // Si no hay endpoint específico, usamos update
      // Pero idealmente debería haber un endpoint o lógica en el update
      
      // Opción 1: Update normal con es_principal = true
      // Primero obtenemos la dirección actual
      final direccion = _direcciones.firstWhere((d) => d.id == id);
      final updated = direccion.copyWith(esPrincipal: true);
      
      await updateDireccion(updated);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }
}
