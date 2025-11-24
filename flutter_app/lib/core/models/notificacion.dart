class Notificacion {
  final int id;
  final int idUsuario;
  final String tipo;
  final String titulo;
  final String mensaje;
  final String? enlace;
  final bool leida;
  final DateTime fechaCreacion;

  Notificacion({
    required this.id,
    required this.idUsuario,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    this.enlace,
    required this.leida,
    required this.fechaCreacion,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] as int,
      idUsuario: json['id_usuario'] as int,
      tipo: json['tipo'] as String,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      enlace: json['enlace'] as String?,
      leida: json['leida'] == 1 || json['leida'] == true,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'tipo': tipo,
      'titulo': titulo,
      'mensaje': mensaje,
      'enlace': enlace,
      'leida': leida ? 1 : 0,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  bool get hasEnlace => enlace != null && enlace!.isNotEmpty;

  String get tipoLabel {
    switch (tipo) {
      case 'contratacion':
        return 'Contratación';
      case 'mensaje':
        return 'Mensaje';
      case 'calificacion':
        return 'Calificación';
      case 'sistema':
        return 'Sistema';
      default:
        return tipo;
    }
  }

  Notificacion copyWith({
    int? id,
    int? idUsuario,
    String? tipo,
    String? titulo,
    String? mensaje,
    String? enlace,
    bool? leida,
    DateTime? fechaCreacion,
  }) {
    return Notificacion(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      enlace: enlace ?? this.enlace,
      leida: leida ?? this.leida,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
