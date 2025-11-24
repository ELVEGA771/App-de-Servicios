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
      id: json['id'] as int,
      idCliente: json['id_cliente'] as int,
      idServicio: json['id_servicio'] as int,
      fechaAgregado: DateTime.parse(json['fecha_agregado'] as String),
      servicioNombre: json['servicio_nombre'] as String?,
      servicioImagen: json['servicio_imagen'] as String?,
      servicioPrecio: json['servicio_precio'] != null
          ? (json['servicio_precio'] as num).toDouble()
          : null,
      servicioCalificacion: json['servicio_calificacion'] != null
          ? (json['servicio_calificacion'] as num).toDouble()
          : null,
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
