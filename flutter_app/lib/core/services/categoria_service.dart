import 'package:servicios_app/core/api/dio_client.dart';
import 'package:servicios_app/core/models/categoria.dart';

class CategoriaService {
  final DioClient _dioClient = DioClient();

  // Get all categorias
  Future<List<Categoria>> getAllCategorias() async {
    final response = await _dioClient.get('/categorias');
    return (response.data['data'] as List)
        .map((e) => Categoria.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get categoria by ID
  Future<Categoria> getCategoriaById(int id) async {
    final response = await _dioClient.get('/categorias/$id');
    return Categoria.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
