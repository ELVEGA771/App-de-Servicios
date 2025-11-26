import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/core/models/servicio.dart';

class MLService {
  late GenerativeModel _model;

  MLService() {
    _model = GenerativeModel(
      model: AppConstants.GEMINI_MODEL,
      apiKey: AppConstants.GEMINI_API_KEY,
    );
  }

  // Get personalized recommendations based on user history and preferences
  Future<List<int>> getRecommendations({
    required List<Servicio> historialServicios,
    required List<int> categoriasPreferidas,
    required String? ciudad,
    int limit = 10,
  }) async {
    try {
      // Build context for Gemini
      final prompt = _buildRecommendationPrompt(
        historialServicios: historialServicios,
        categoriasPreferidas: categoriasPreferidas,
        ciudad: ciudad,
      );

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // Parse response to extract service IDs
      return _parseRecommendationResponse(response.text ?? '', limit);
    } catch (e) {
      // Fallback to simple recommendation algorithm
      return _getFallbackRecommendations(
        historialServicios: historialServicios,
        categoriasPreferidas: categoriasPreferidas,
        limit: limit,
      );
    }
  }

  // Get similar services based on a specific service
  Future<List<int>> getSimilarServices({
    required Servicio servicio,
    int limit = 5,
  }) async {
    try {
      final prompt = '''
      Basándote en el siguiente servicio:
      - Nombre: ${servicio.nombre}
      - Descripción: ${servicio.descripcion}
      - Categoría ID: ${servicio.idCategoria}
      - Precio: \$${servicio.precio}

      Recomienda servicios similares que un usuario podría estar interesado.
      Considera: categoría similar, rango de precio similar, y tipo de servicio relacionado.

      Responde SOLO con una lista de números de ID de servicios separados por comas.
      Ejemplo: 5,12,8,15,23
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return _parseRecommendationResponse(response.text ?? '', limit);
    } catch (e) {
      return [];
    }
  }

  // Categorize user search intent
  Future<Map<String, dynamic>> analyzeSearchIntent(String query) async {
    try {
      final prompt = '''
      Analiza la siguiente búsqueda de servicio y extrae información estructurada:
      Búsqueda: "$query"

      Responde en formato JSON con:
      {
        "categoria_sugerida": "nombre de categoría relevante",
        "palabras_clave": ["palabra1", "palabra2"],
        "urgencia": "alta/media/baja",
        "tipo_servicio": "descripción breve"
      }
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return _parseJsonResponse(response.text ?? '');
    } catch (e) {
      return {
        'categoria_sugerida': null,
        'palabras_clave': [query],
        'urgencia': 'media',
        'tipo_servicio': query,
      };
    }
  }

  // Build recommendation prompt
  String _buildRecommendationPrompt({
    required List<Servicio> historialServicios,
    required List<int> categoriasPreferidas,
    required String? ciudad,
  }) {
    final serviciosText = historialServicios.take(10).map((s) {
      return '- ${s.nombre} (Categoría: ${s.categoriaNombre}, Precio: \$${s.precio})';
    }).join('\n');

    return '''
    Eres un sistema de recomendación de servicios. Basándote en el siguiente perfil de usuario:

    Servicios contratados previamente:
    $serviciosText

    Categorías preferidas: ${categoriasPreferidas.join(', ')}
    ${ciudad != null ? 'Ciudad: $ciudad' : ''}

    Recomienda servicios que el usuario podría estar interesado en contratar.
    Considera:
    1. Servicios complementarios a los ya contratados
    2. Servicios en categorías preferidas
    3. Servicios populares en su ubicación

    Responde SOLO con una lista de números de ID de servicios separados por comas.
    Ejemplo: 15,7,23,42,8,19,31
    ''';
  }

  // Parse recommendation response
  List<int> _parseRecommendationResponse(String response, int limit) {
    try {
      // Extract numbers from response
      final numbers = RegExp(r'\d+').allMatches(response);
      final ids = numbers.map((m) => int.parse(m.group(0)!)).toList();
      return ids.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  // Parse JSON response
  Map<String, dynamic> _parseJsonResponse(String response) {
    try {
      // Remove markdown code blocks if present
      // var cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim(); // Removed unused variable
      // You'd use dart:convert here in actual implementation
      // For now, return default
      return {};
    } catch (e) {
      return {};
    }
  }

  // Fallback recommendation algorithm (when Gemini API fails)
  List<int> _getFallbackRecommendations({
    required List<Servicio> historialServicios,
    required List<int> categoriasPreferidas,
    required int limit,
  }) {
    // Simple algorithm: recommend services from preferred categories
    // In production, this would query the database
    return categoriasPreferidas.take(limit).toList();
  }

  // Generate service description using AI
  Future<String> generateServiceDescription({
    required String nombre,
    required String categoria,
    String? caracteristicas,
  }) async {
    try {
      final prompt = '''
      Genera una descripción atractiva y profesional para el siguiente servicio:

      Nombre: $nombre
      Categoría: $categoria
      ${caracteristicas != null ? 'Características: $caracteristicas' : ''}

      La descripción debe:
      - Ser clara y concisa (2-3 párrafos)
      - Destacar beneficios para el cliente
      - Usar un tono profesional pero amigable
      - Incluir palabras clave relevantes
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? '';
    } catch (e) {
      return '';
    }
  }
}
