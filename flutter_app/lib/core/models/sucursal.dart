class Sucursal {
  final int idSucursal;
  final int? idEmpresa;
  final int? idDireccion;
  final String nombreSucursal;
  final String? telefono;
  // Email eliminado
  final String estado;
  final DateTime? fechaCreacion;

  // Nuevos campos de horario
  final String? horarioApertura;
  final String? horarioCierre;
  final String? diasLaborales;

  // Campos de dirección
  final String callePrincipal;
  final String? calleSecundaria;
  final String? numero;
  final String ciudad;
  final String provinciaEstado;
  final String? codigoPostal;
  final String? pais;
  final double? latitud;
  final double? longitud;
  final String? referencia;

  Sucursal({
    required this.idSucursal,
    this.idEmpresa,
    this.idDireccion,
    required this.nombreSucursal,
    this.telefono,
    required this.estado,
    this.fechaCreacion,
    this.horarioApertura,
    this.horarioCierre,
    this.diasLaborales,
    required this.callePrincipal,
    this.calleSecundaria,
    this.numero,
    required this.ciudad,
    required this.provinciaEstado,
    this.codigoPostal,
    this.pais,
    this.latitud,
    this.longitud,
    this.referencia,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      idSucursal: json['id_sucursal'] as int,
      idEmpresa: json['id_empresa'] as int?,
      idDireccion: json['id_direccion'] as int?,
      nombreSucursal: json['nombre_sucursal'] as String,
      telefono: json['telefono'] as String?,
      estado: json['estado'] as String,
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion'].toString())
          : null,

      // Mapeo de horarios
      horarioApertura: json['horario_apertura'] as String?,
      horarioCierre: json['horario_cierre'] as String?,
      diasLaborales: json['dias_laborales'] as String?,

      // Mapeo de dirección con fallbacks
      callePrincipal: json['calle_principal'] as String? ?? '',
      calleSecundaria: json['calle_secundaria'] as String?,
      numero: json['numero'] as String?,
      ciudad: json['ciudad'] as String? ?? '',
      provinciaEstado: json['provincia_estado'] as String? ?? '',
      codigoPostal: json['codigo_postal'] as String?,
      pais: json['pais'] as String?,
      latitud:
          json['latitud'] != null ? (json['latitud'] as num).toDouble() : null,
      longitud: json['longitud'] != null
          ? (json['longitud'] as num).toDouble()
          : null,
      referencia: json['referencia'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_sucursal': idSucursal,
      'id_empresa': idEmpresa,
      'id_direccion': idDireccion,
      'nombre_sucursal': nombreSucursal,
      'telefono': telefono,
      'estado': estado,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'horario_apertura': horarioApertura,
      'horario_cierre': horarioCierre,
      'dias_laborales': diasLaborales,
      'calle_principal': callePrincipal,
      'calle_secundaria': calleSecundaria,
      'numero': numero,
      'ciudad': ciudad,
      'provincia_estado': provinciaEstado,
      'codigo_postal': codigoPostal,
      'pais': pais,
      'latitud': latitud,
      'longitud': longitud,
      'referencia': referencia,
    };
  }

  bool get isActive => estado == 'activa';

  String get direccionCompleta {
    final partes = <String>[
      callePrincipal,
      if (calleSecundaria != null && calleSecundaria!.isNotEmpty)
        calleSecundaria!,
      if (numero != null && numero!.isNotEmpty) numero!,
      ciudad,
      provinciaEstado,
    ];
    return partes.join(', ');
  }

  String get direccionCorta {
    final partes = <String>[
      callePrincipal,
      ciudad,
    ];
    return partes.join(', ');
  }

  // Método copyWith actualizado
  Sucursal copyWith({
    int? idSucursal,
    int? idEmpresa,
    int? idDireccion,
    String? nombreSucursal,
    String? telefono,
    String? estado,
    DateTime? fechaCreacion,
    String? horarioApertura,
    String? horarioCierre,
    String? diasLaborales,
    String? callePrincipal,
    String? calleSecundaria,
    String? numero,
    String? ciudad,
    String? provinciaEstado,
    String? codigoPostal,
    String? pais,
    double? latitud,
    double? longitud,
    String? referencia,
  }) {
    return Sucursal(
      idSucursal: idSucursal ?? this.idSucursal,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idDireccion: idDireccion ?? this.idDireccion,
      nombreSucursal: nombreSucursal ?? this.nombreSucursal,
      telefono: telefono ?? this.telefono,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      horarioApertura: horarioApertura ?? this.horarioApertura,
      horarioCierre: horarioCierre ?? this.horarioCierre,
      diasLaborales: diasLaborales ?? this.diasLaborales,
      callePrincipal: callePrincipal ?? this.callePrincipal,
      calleSecundaria: calleSecundaria ?? this.calleSecundaria,
      numero: numero ?? this.numero,
      ciudad: ciudad ?? this.ciudad,
      provinciaEstado: provinciaEstado ?? this.provinciaEstado,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      pais: pais ?? this.pais,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      referencia: referencia ?? this.referencia,
    );
  }

  String get diasLaboralesLabel {
    if (diasLaborales == null || diasLaborales!.length != 7)
      return 'No definido';

    const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    List<String> activos = [];

    for (int i = 0; i < 7; i++) {
      if (diasLaborales![i] == '1') {
        activos.add(dias[i]);
      }
    }

    if (activos.length == 7) return 'Todos los días';
    if (activos.isEmpty) return 'Cerrado temporalmente';
    if (diasLaborales == '1111100') return 'Lunes a Viernes';

    return activos.join(', ');
  }
}
