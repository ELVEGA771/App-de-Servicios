class Favorito {
  final int id;
  final int idCliente;
  final int idServicio;
  final DateTime fechaAgregado;

  // Datos adicionales del servicio
  final String? servicioNombre;
  final String? servicioImagen;
  final double? servicioPrecio;
  final double? servicioCalificacion;
  final String? empresaNombre;

  Favorito({
    required this.id,
    required this.idCliente,
    required this.idServicio,
    required this.fechaAgregado,
    this.servicioNombre,
    this.servicioImagen,
    this.servicioPrecio,
    this.servicioCalificacion,
    this.empresaNombre,
  });

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      id: json['id'] != null
          ? int.parse(json['id'].toString())
          : (json['id_servicio'] != null
              ? int.parse(json['id_servicio'].toString())
              : 0),
      idCliente: int.parse(json['id_cliente'].toString()),
      idServicio: int.parse(json['id_servicio'].toString()),
      fechaAgregado: DateTime.parse(json['fecha_agregado'] as String),
      servicioNombre: json['servicio_nombre'] as String? ?? json['nombre'] as String?,
      servicioImagen: json['servicio_imagen'] as String? ?? json['imagen_url'] as String?,
      servicioPrecio: json['servicio_precio'] != null
          ? double.tryParse(json['servicio_precio'].toString())
          : (json['precio_base'] != null
              ? double.tryParse(json['precio_base'].toString())
              : null),
      servicioCalificacion: json['servicio_calificacion'] != null
          ? double.tryParse(json['servicio_calificacion'].toString())
          : (json['calificacion_promedio'] != null
              ? double.tryParse(json['calificacion_promedio'].toString())
              : null),
      empresaNombre: json['empresa_nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_cliente': idCliente,
      'id_servicio': idServicio,
      'fecha_agregado': fechaAgregado.toIso8601String(),
      'servicio_nombre': servicioNombre,
      'servicio_imagen': servicioImagen,
      'servicio_precio': servicioPrecio,
      'servicio_calificacion': servicioCalificacion,
      'empresa_nombre': empresaNombre,
    };
  }

  Favorito copyWith({
    int? id,
    int? idCliente,
    int? idServicio,
    DateTime? fechaAgregado,
    String? servicioNombre,
    String? servicioImagen,
    double? servicioPrecio,
    double? servicioCalificacion,
    String? empresaNombre,
  }) {
    return Favorito(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      idServicio: idServicio ?? this.idServicio,
      fechaAgregado: fechaAgregado ?? this.fechaAgregado,
      servicioNombre: servicioNombre ?? this.servicioNombre,
      servicioImagen: servicioImagen ?? this.servicioImagen,
      servicioPrecio: servicioPrecio ?? this.servicioPrecio,
      servicioCalificacion: servicioCalificacion ?? this.servicioCalificacion,
      empresaNombre: empresaNombre ?? this.empresaNombre,
    );
  }
}
