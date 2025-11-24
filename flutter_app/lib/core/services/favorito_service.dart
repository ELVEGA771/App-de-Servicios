import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/favorito.dart';

class FavoritoService {
  final DioClient _dioClient = DioClient();

  // Get all favoritos
  Future<List<Favorito>> getFavoritos() async {
    final response = await _dioClient.get('/favoritos');
    return (response.data['data'] as List)
        .map((e) => Favorito.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Add favorito
  Future<Favorito> addFavorito(int servicioId) async {
    final response = await _dioClient.post(
      '/favoritos',
      data: {'id_servicio': servicioId},
    );
    return Favorito.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // Remove favorito
  Future<void> removeFavorito(int servicioId) async {
    await _dioClient.delete('/favoritos/$servicioId');
  }

  // Check if servicio is favorito
  Future<bool> isFavorito(int servicioId) async {
    try {
      final response = await _dioClient.get('/favoritos/check/$servicioId');
      return response.data['data']['es_favorito'] as bool;
    } catch (e) {
      return false;
    }
  }
}
