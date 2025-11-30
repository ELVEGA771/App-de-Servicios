class Direccion {
  final int id;
  final int idCliente;
  final String alias;
  final String callePrincipal;
  final String? calleSecundaria;
  final String? numero;
  final String ciudad;
  final String estado;
  final String codigoPostal;
  final String? referencia;
  final double? latitud;
  final double? longitud;
  final bool esPrincipal;

  Direccion({
    required this.id,
    required this.idCliente,
    required this.alias,
    required this.callePrincipal,
    this.calleSecundaria,
    this.numero,
    required this.ciudad,
    required this.estado,
    required this.codigoPostal,
    this.referencia,
    this.latitud,
    this.longitud,
    required this.esPrincipal,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      id: json['id_direccion'] as int? ?? json['id'] as int? ?? 0,
      idCliente: json['id_cliente'] as int? ?? 0,
      alias: json['alias'] as String? ?? '',
      callePrincipal: json['calle_principal'] as String? ?? '',
      calleSecundaria: json['calle_secundaria'] as String?,
      numero: json['numero'] as String? ?? json['numero_exterior'] as String?,
      ciudad: json['ciudad'] as String? ?? '',
      estado: json['provincia_estado'] as String? ?? json['estado'] as String? ?? '',
      codigoPostal: json['codigo_postal'] as String? ?? '',
      referencia: json['referencia'] as String?,
      latitud: json['latitud'] != null
          ? (json['latitud'] as num).toDouble()
          : null,
      longitud: json['longitud'] != null
          ? (json['longitud'] as num).toDouble()
          : null,
      esPrincipal: json['es_principal'] == 1 || json['es_principal'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_cliente': idCliente,
      'alias': alias,
      'calle_principal': callePrincipal,
      'calle_secundaria': calleSecundaria,
      'numero': numero,
      'ciudad': ciudad,
      'estado': estado,
      'codigo_postal': codigoPostal,
      'referencia': referencia,
      'latitud': latitud,
      'longitud': longitud,
      'es_principal': esPrincipal ? 1 : 0,
    };
  }

  String get direccionCompleta {
    final parts = <String>[];
    parts.add(callePrincipal);
    if (calleSecundaria != null && calleSecundaria!.isNotEmpty) {
      parts.add('y $calleSecundaria');
    }
    if (numero != null) parts.add(numero!);
    parts.add('$ciudad, $estado');
    parts.add('C.P. $codigoPostal');
    return parts.join(', ');
  }

  String get direccionCorta {
    final parts = <String>[];
    parts.add(callePrincipal);
    if (numero != null) parts.add(numero!);
    return parts.join(' ');
  }

  bool get hasLocation => latitud != null && longitud != null;

  Direccion copyWith({
    int? id,
    int? idCliente,
    String? alias,
    String? callePrincipal,
    String? calleSecundaria,
    String? numero,
    String? ciudad,
    String? estado,
    String? codigoPostal,
    String? referencia,
    double? latitud,
    double? longitud,
    bool? esPrincipal,
  }) {
    return Direccion(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      alias: alias ?? this.alias,
      callePrincipal: callePrincipal ?? this.callePrincipal,
      calleSecundaria: calleSecundaria ?? this.calleSecundaria,
      numero: numero ?? this.numero,
      ciudad: ciudad ?? this.ciudad,
      estado: estado ?? this.estado,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      referencia: referencia ?? this.referencia,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      esPrincipal: esPrincipal ?? this.esPrincipal,
    );
  }
}
