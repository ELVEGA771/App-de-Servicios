class Empresa {
  final int id;
  final int idUsuario;
  final String nombre;
  final String? descripcion;
  final String? telefono;
  final String? sitioWeb;
  final String? logo;
  final String? rfc;
  final String? razonSocial;
  final double? calificacionPromedio;
  final int? totalCalificaciones;

  Empresa({
    required this.id,
    required this.idUsuario,
    required this.nombre,
    this.descripcion,
    this.telefono,
    this.sitioWeb,
    this.logo,
    this.rfc,
    this.razonSocial,
    this.calificacionPromedio,
    this.totalCalificaciones,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    try {
      print('DEBUG Empresa.fromJson: Starting parsing');
      print('DEBUG Empresa.fromJson: json = $json');

      final id = (json['id_empresa'] ?? json['id']) as int;
      print('DEBUG Empresa.fromJson: id = $id');

      final idUsuario = json['id_usuario'] as int;
      print('DEBUG Empresa.fromJson: idUsuario = $idUsuario');

      final nombre = json['nombre'] as String;
      print('DEBUG Empresa.fromJson: nombre = $nombre');

      final descripcion = json['descripcion'] as String?;
      final telefono = json['telefono'] as String?;
      final sitioWeb = json['sitio_web'] as String?;
      final logo = (json['logo_url'] ?? json['logo']) as String?;
      final rfc = (json['ruc_nit'] ?? json['rfc']) as String?;
      final razonSocial = json['razon_social'] as String?;

      print('DEBUG Empresa.fromJson: About to parse calificacion_promedio: ${json['calificacion_promedio']} (type: ${json['calificacion_promedio'].runtimeType})');

      double? calificacionPromedio;
      if (json['calificacion_promedio'] != null) {
        try {
          final value = json['calificacion_promedio'];
          if (value is String) {
            calificacionPromedio = double.parse(value);
            print('DEBUG Empresa.fromJson: Converted string calificacion_promedio to double: $calificacionPromedio');
          } else {
            calificacionPromedio = (value as num).toDouble();
            print('DEBUG Empresa.fromJson: Converted num calificacion_promedio to double: $calificacionPromedio');
          }
        } catch (e) {
          print('ERROR Empresa.fromJson: Failed to parse calificacion_promedio: $e');
          calificacionPromedio = null;
        }
      }

      final totalCalificaciones = json['total_calificaciones'] as int?;

      final empresa = Empresa(
        id: id,
        idUsuario: idUsuario,
        nombre: nombre,
        descripcion: descripcion,
        telefono: telefono,
        sitioWeb: sitioWeb,
        logo: logo,
        rfc: rfc,
        razonSocial: razonSocial,
        calificacionPromedio: calificacionPromedio,
        totalCalificaciones: totalCalificaciones,
      );

      print('DEBUG Empresa.fromJson: Successfully created Empresa');
      return empresa;
    } catch (e, stackTrace) {
      print('ERROR Empresa.fromJson: Failed to parse Empresa');
      print('ERROR: $e');
      print('STACK: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'nombre': nombre,
      'descripcion': descripcion,
      'telefono': telefono,
      'sitio_web': sitioWeb,
      'logo': logo,
      'rfc': rfc,
      'razon_social': razonSocial,
      'calificacion_promedio': calificacionPromedio,
      'total_calificaciones': totalCalificaciones,
    };
  }

  Empresa copyWith({
    int? id,
    int? idUsuario,
    String? nombre,
    String? descripcion,
    String? telefono,
    String? sitioWeb,
    String? logo,
    String? rfc,
    String? razonSocial,
    double? calificacionPromedio,
    int? totalCalificaciones,
  }) {
    return Empresa(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      telefono: telefono ?? this.telefono,
      sitioWeb: sitioWeb ?? this.sitioWeb,
      logo: logo ?? this.logo,
      rfc: rfc ?? this.rfc,
      razonSocial: razonSocial ?? this.razonSocial,
      calificacionPromedio: calificacionPromedio ?? this.calificacionPromedio,
      totalCalificaciones: totalCalificaciones ?? this.totalCalificaciones,
    );
  }
}
