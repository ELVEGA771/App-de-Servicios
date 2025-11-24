class Direccion {
  final int id;
  final int idCliente;
  final String alias;
  final String calle;
  final String? numeroExterior;
  final String? numeroInterior;
  final String colonia;
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
    required this.calle,
    this.numeroExterior,
    this.numeroInterior,
    required this.colonia,
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
      id: json['id'] as int,
      idCliente: json['id_cliente'] as int,
      alias: json['alias'] as String,
      calle: json['calle'] as String,
      numeroExterior: json['numero_exterior'] as String?,
      numeroInterior: json['numero_interior'] as String?,
      colonia: json['colonia'] as String,
      ciudad: json['ciudad'] as String,
      estado: json['estado'] as String,
      codigoPostal: json['codigo_postal'] as String,
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
      'calle': calle,
      'numero_exterior': numeroExterior,
      'numero_interior': numeroInterior,
      'colonia': colonia,
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
    parts.add(calle);
    if (numeroExterior != null) parts.add(numeroExterior!);
    if (numeroInterior != null) parts.add('Int. $numeroInterior');
    parts.add(colonia);
    parts.add('$ciudad, $estado');
    parts.add('C.P. $codigoPostal');
    return parts.join(', ');
  }

  String get direccionCorta {
    final parts = <String>[];
    parts.add(calle);
    if (numeroExterior != null) parts.add(numeroExterior!);
    parts.add(colonia);
    return parts.join(' ');
  }

  bool get hasLocation => latitud != null && longitud != null;

  Direccion copyWith({
    int? id,
    int? idCliente,
    String? alias,
    String? calle,
    String? numeroExterior,
    String? numeroInterior,
    String? colonia,
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
      calle: calle ?? this.calle,
      numeroExterior: numeroExterior ?? this.numeroExterior,
      numeroInterior: numeroInterior ?? this.numeroInterior,
      colonia: colonia ?? this.colonia,
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
