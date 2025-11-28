import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servicios_app/core/api/dio_client.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb

class UploadService {
  final DioClient _dioClient = DioClient();

  Future<String?> uploadImage(XFile file) async {
    try {
      String fileName = file.name;
      FormData formData;

      if (kIsWeb) {
        // LÓGICA PARA WEB: Usar bytes
        final bytes = await file.readAsBytes();
        formData = FormData.fromMap({
          'imagen': MultipartFile.fromBytes(
            bytes,
            filename: fileName,
          ),
        });
      } else {
        // LÓGICA PARA MÓVIL: Usar path (es más eficiente en memoria para archivos grandes)
        formData = FormData.fromMap({
          'imagen': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });
      }

      final response = await _dioClient.post(
        '/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        // CORRECCIÓN AQUÍ:
        // Antes: return response.data['url'];
        // Ahora: Verificamos si viene dentro de 'data' o en la raíz
        final data = response.data;
        
        if (data['data'] != null && data['data']['url'] != null) {
          return data['data']['url'].toString();
        } else if (data['url'] != null) {
          return data['url'].toString();
        }
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}