class Calificacion {
  final int? id;
  final int? idContratacion;
  final int? idCliente;
  final int? idEmpresa;
  final int calificacion;
  final String? comentario;
  final DateTime? fechaCalificacion;

  // Datos adicionales
  final String? clienteNombre;
  final String? clienteFoto;
  final String? servicioNombre;

  Calificacion({
    this.id,
    this.idContratacion,
    this.idCliente,
    this.idEmpresa,
    required this.calificacion,
    this.comentario,
    this.fechaCalificacion,
    this.clienteNombre,
    this.clienteFoto,
    this.servicioNombre,
  });

  factory Calificacion.fromJson(Map<String, dynamic> json) {
    return Calificacion(
      id: json['id_calificacion'] as int? ?? json['id'] as int?,
      idContratacion: json['id_contratacion'] as int?,
      idCliente: json['id_cliente'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      calificacion: json['calificacion'] as int? ?? 0,
      comentario: json['comentario'] as String?,
      fechaCalificacion: json['fecha_calificacion'] != null 
          ? DateTime.parse(json['fecha_calificacion'] as String)
          : null,
      clienteNombre: json['cliente_nombre'] as String?,
      clienteFoto: json['cliente_foto'] as String? ?? json['foto_perfil_url'] as String?,
      servicioNombre: json['servicio_nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_contratacion': idContratacion,
      'id_cliente': idCliente,
      'id_empresa': idEmpresa,
      'calificacion': calificacion,
      'comentario': comentario,
      'fecha_calificacion': fechaCalificacion?.toIso8601String(),
      'cliente_nombre': clienteNombre,
      'cliente_foto': clienteFoto,
      'servicio_nombre': servicioNombre,
    };
  }

  bool get hasComment => comentario != null && comentario!.isNotEmpty;

  Calificacion copyWith({
    int? id,
    int? idContratacion,
    int? idCliente,
    int? idEmpresa,
    int? calificacion,
    String? comentario,
    DateTime? fechaCalificacion,
    String? clienteNombre,
    String? clienteFoto,
    String? servicioNombre,
  }) {
    return Calificacion(
      id: id ?? this.id,
      idContratacion: idContratacion ?? this.idContratacion,
      idCliente: idCliente ?? this.idCliente,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      calificacion: calificacion ?? this.calificacion,
      comentario: comentario ?? this.comentario,
      fechaCalificacion: fechaCalificacion ?? this.fechaCalificacion,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteFoto: clienteFoto ?? this.clienteFoto,
      servicioNombre: servicioNombre ?? this.servicioNombre,
    );
  }
}
