class Servicio {
  final int id;
  final int? idEmpresa;
  final int? idCategoria;
  final String nombre;
  final String descripcion;
  final double precio;
  final String? duracionEstimada;
  final String? imagenPrincipal;
  final List<String>? imagenesAdicionales;
  final String? videoUrl;
  final String estado;
  final double? calificacionPromedio;
  final int? totalCalificaciones;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  final List<dynamic>? sucursalesDisponibles;

  // Datos adicionales de relaciones
  final String? empresaNombre;
  final String? empresaLogo;
  final String? categoriaNombre;
  final int? totalContrataciones;

  Servicio({
    required this.id,
    this.idEmpresa,
    this.idCategoria,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    this.duracionEstimada,
    this.imagenPrincipal,
    this.imagenesAdicionales,
    this.videoUrl,
    required this.estado,
    this.calificacionPromedio,
    this.totalCalificaciones,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    this.empresaNombre,
    this.empresaLogo,
    this.categoriaNombre,
    this.totalContrataciones,
    this.sucursalesDisponibles,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    print('DEBUG Servicio.fromJson: json = $json');

    List<String>? parseImagenes(dynamic imagenes) {
      if (imagenes == null) return null;
      if (imagenes is List) {
        return imagenes.map((e) => e.toString()).toList();
      }
      if (imagenes is String) {
        return imagenes.split(',').map((e) => e.trim()).toList();
      }
      return null;
    }

    try {
      // --- CORRECCIÓN DE IDs (Manejar posible String) ---
      int id;
      if (json['id_servicio'] != null) {
        id = int.parse(json['id_servicio'].toString());
      } else {
        id = int.parse(json['id'].toString());
      }

      // Handle both formats: servicio_nombre and nombre
      String nombre =
          json['servicio_nombre'] as String? ?? json['nombre'] as String;

      // --- CORRECCIÓN DEL PRECIO (EL ERROR ESTABA AQUÍ) ---
      // Permitimos que venga como String o como num y lo convertimos a double seguro
      dynamic precioData = json['precio_base'] ?? json['precio'];
      double precio = 0.0;

      if (precioData != null) {
        if (precioData is num) {
          precio = precioData.toDouble();
        } else if (precioData is String) {
          precio = double.tryParse(precioData) ?? 0.0;
        }
      }
      print('DEBUG Servicio.fromJson: precio parseado = $precio');

      // Handle both formats: servicio_estado and estado
      String estado = json['servicio_estado'] as String? ??
          json['estado'] as String? ??
          'disponible';

      // Parse duration - could be int or String
      String? duracionEstimada;
      if (json['duracion_estimada'] != null) {
        duracionEstimada = json['duracion_estimada'].toString();
      }

      return Servicio(
        id: id,
        idEmpresa: json['id_empresa'] != null
            ? int.tryParse(json['id_empresa'].toString())
            : null,
        idCategoria: json['id_categoria'] != null
            ? int.tryParse(json['id_categoria'].toString())
            : null,
        nombre: nombre,
        descripcion: json['descripcion'] as String? ?? '',
        precio: precio, // Usamos la variable convertida arriba
        duracionEstimada: duracionEstimada,
        imagenPrincipal: json['imagen_principal'] as String? ??
            json['imagen_url'] as String?,
        imagenesAdicionales: parseImagenes(json['imagenes_adicionales']),
        videoUrl: json['video_url'] as String?,
        estado: estado,
        calificacionPromedio: json['calificacion_promedio'] != null
            ? double.tryParse(json['calificacion_promedio'].toString())
            : (json['empresa_calificacion'] != null
                ? double.tryParse(json['empresa_calificacion'].toString())
                : null),
        totalCalificaciones: json['total_calificaciones'] != null
            ? int.tryParse(json['total_calificaciones'].toString())
            : null,
        fechaCreacion: json['fecha_creacion'] != null
            ? DateTime.parse(json['fecha_creacion'] as String)
            : DateTime.now(),
        fechaActualizacion: json['fecha_actualizacion'] != null
            ? DateTime.parse(json['fecha_actualizacion'] as String)
            : DateTime.now(),
        empresaNombre: json['empresa_nombre'] as String?,
        empresaLogo: json['empresa_logo'] as String?,
        categoriaNombre: json['categoria_nombre'] as String?,
        totalContrataciones: json['total_contrataciones'] != null
            ? int.tryParse(json['total_contrataciones'].toString())
            : null,
        sucursalesDisponibles: json['sucursales'] as List<dynamic>?,
      );
    } catch (e, stackTrace) {
      print('ERROR Servicio.fromJson: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_empresa': idEmpresa,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'duracion_estimada': duracionEstimada,
      'imagen_principal': imagenPrincipal,
      'imagenes_adicionales': imagenesAdicionales,
      'video_url': videoUrl,
      'estado': estado,
      'calificacion_promedio': calificacionPromedio,
      'total_calificaciones': totalCalificaciones,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
      'empresa_nombre': empresaNombre,
      'empresa_logo': empresaLogo,
      'categoria_nombre': categoriaNombre,
      'total_contrataciones': totalContrataciones,
    };
  }

  bool get isActive => estado == 'activo';
  bool get hasRating =>
      calificacionPromedio != null && calificacionPromedio! > 0;
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImages =>
      imagenesAdicionales != null && imagenesAdicionales!.isNotEmpty;

  Servicio copyWith({
    int? id,
    int? idEmpresa,
    int? idCategoria,
    String? nombre,
    String? descripcion,
    double? precio,
    String? duracionEstimada,
    String? imagenPrincipal,
    List<String>? imagenesAdicionales,
    String? videoUrl,
    String? estado,
    double? calificacionPromedio,
    int? totalCalificaciones,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    String? empresaNombre,
    String? empresaLogo,
    String? categoriaNombre,
    int? totalContrataciones,
  }) {
    return Servicio(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      imagenPrincipal: imagenPrincipal ?? this.imagenPrincipal,
      imagenesAdicionales: imagenesAdicionales ?? this.imagenesAdicionales,
      videoUrl: videoUrl ?? this.videoUrl,
      estado: estado ?? this.estado,
      calificacionPromedio: calificacionPromedio ?? this.calificacionPromedio,
      totalCalificaciones: totalCalificaciones ?? this.totalCalificaciones,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      empresaNombre: empresaNombre ?? this.empresaNombre,
      empresaLogo: empresaLogo ?? this.empresaLogo,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
      totalContrataciones: totalContrataciones ?? this.totalContrataciones,
    );
  }
}
