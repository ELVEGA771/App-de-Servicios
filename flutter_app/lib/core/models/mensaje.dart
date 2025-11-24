class Mensaje {
  final int id;
  final int idConversacion;
  final int idRemitente;
  final String tipoRemitente;
  final String contenido;
  final DateTime fechaEnvio;
  final bool leido;

  // Datos adicionales
  final String? remitenteNombre;
  final String? remitenteFoto;

  Mensaje({
    required this.id,
    required this.idConversacion,
    required this.idRemitente,
    required this.tipoRemitente,
    required this.contenido,
    required this.fechaEnvio,
    required this.leido,
    this.remitenteNombre,
    this.remitenteFoto,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      id: json['id'] as int,
      idConversacion: json['id_conversacion'] as int,
      idRemitente: json['id_remitente'] as int,
      tipoRemitente: json['tipo_remitente'] as String,
      contenido: json['contenido'] as String,
      fechaEnvio: DateTime.parse(json['fecha_envio'] as String),
      leido: json['leido'] == 1 || json['leido'] == true,
      remitenteNombre: json['remitente_nombre'] as String?,
      remitenteFoto: json['remitente_foto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_conversacion': idConversacion,
      'id_remitente': idRemitente,
      'tipo_remitente': tipoRemitente,
      'contenido': contenido,
      'fecha_envio': fechaEnvio.toIso8601String(),
      'leido': leido ? 1 : 0,
      'remitente_nombre': remitenteNombre,
      'remitente_foto': remitenteFoto,
    };
  }

  bool get isFromCliente => tipoRemitente == 'cliente';
  bool get isFromEmpresa => tipoRemitente == 'empresa';

  Mensaje copyWith({
    int? id,
    int? idConversacion,
    int? idRemitente,
    String? tipoRemitente,
    String? contenido,
    DateTime? fechaEnvio,
    bool? leido,
    String? remitenteNombre,
    String? remitenteFoto,
  }) {
    return Mensaje(
      id: id ?? this.id,
      idConversacion: idConversacion ?? this.idConversacion,
      idRemitente: idRemitente ?? this.idRemitente,
      tipoRemitente: tipoRemitente ?? this.tipoRemitente,
      contenido: contenido ?? this.contenido,
      fechaEnvio: fechaEnvio ?? this.fechaEnvio,
      leido: leido ?? this.leido,
      remitenteNombre: remitenteNombre ?? this.remitenteNombre,
      remitenteFoto: remitenteFoto ?? this.remitenteFoto,
    );
  }
}
