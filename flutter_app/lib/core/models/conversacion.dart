class Conversacion {
  final int id;
  final int idCliente;
  final int idEmpresa;
  final int? idContratacion;
  final DateTime fechaInicio;
  final DateTime? fechaUltimoMensaje;
  final String estado;

  // Datos adicionales
  final String? clienteNombre;
  final String? clienteFoto;
  final String? empresaNombre;
  final String? empresaLogo;
  final String? ultimoMensaje;
  final int? mensajesNoLeidos;

  Conversacion({
    required this.id,
    required this.idCliente,
    required this.idEmpresa,
    this.idContratacion,
    required this.fechaInicio,
    this.fechaUltimoMensaje,
    required this.estado,
    this.clienteNombre,
    this.clienteFoto,
    this.empresaNombre,
    this.empresaLogo,
    this.ultimoMensaje,
    this.mensajesNoLeidos,
  });

  factory Conversacion.fromJson(Map<String, dynamic> json) {
    return Conversacion(
      id: json['id'] as int? ?? json['id_conversacion'] as int,
      idCliente: json['id_cliente'] as int,
      idEmpresa: json['id_empresa'] as int,
      idContratacion: json['id_contratacion'] as int?,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaUltimoMensaje: json['fecha_ultimo_mensaje'] != null
          ? DateTime.parse(json['fecha_ultimo_mensaje'] as String)
          : null,
      estado: json['estado'] as String,
      clienteNombre: json['cliente_nombre'] as String?,
      clienteFoto: json['cliente_foto'] as String?,
      empresaNombre: json['empresa_nombre'] as String?,
      empresaLogo: json['empresa_logo'] as String?,
      ultimoMensaje: json['ultimo_mensaje'] as String?,
      mensajesNoLeidos: json['mensajes_no_leidos'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_cliente': idCliente,
      'id_empresa': idEmpresa,
      'id_contratacion': idContratacion,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_ultimo_mensaje': fechaUltimoMensaje?.toIso8601String(),
      'estado': estado,
      'cliente_nombre': clienteNombre,
      'cliente_foto': clienteFoto,
      'empresa_nombre': empresaNombre,
      'empresa_logo': empresaLogo,
      'ultimo_mensaje': ultimoMensaje,
      'mensajes_no_leidos': mensajesNoLeidos,
    };
  }

  bool get isActive => estado == 'activa';
  bool get hasUnreadMessages => mensajesNoLeidos != null && mensajesNoLeidos! > 0;

  Conversacion copyWith({
    int? id,
    int? idCliente,
    int? idEmpresa,
    int? idContratacion,
    DateTime? fechaInicio,
    DateTime? fechaUltimoMensaje,
    String? estado,
    String? clienteNombre,
    String? clienteFoto,
    String? empresaNombre,
    String? empresaLogo,
    String? ultimoMensaje,
    int? mensajesNoLeidos,
  }) {
    return Conversacion(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idContratacion: idContratacion ?? this.idContratacion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaUltimoMensaje: fechaUltimoMensaje ?? this.fechaUltimoMensaje,
      estado: estado ?? this.estado,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteFoto: clienteFoto ?? this.clienteFoto,
      empresaNombre: empresaNombre ?? this.empresaNombre,
      empresaLogo: empresaLogo ?? this.empresaLogo,
      ultimoMensaje: ultimoMensaje ?? this.ultimoMensaje,
      mensajesNoLeidos: mensajesNoLeidos ?? this.mensajesNoLeidos,
    );
  }
}
