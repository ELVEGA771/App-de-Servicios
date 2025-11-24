class Cliente {
  final int id;
  final DateTime? fechaNacimiento;
  final double? calificacionPromedio;

  Cliente({
    required this.id,
    this.fechaNacimiento,
    this.calificacionPromedio,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id_cliente'] as int,
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'] as String)
          : null,
      calificacionPromedio: json['calificacion_promedio'] != null
          ? (json['calificacion_promedio'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': id,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String().split('T')[0],
      'calificacion_promedio': calificacionPromedio,
    };
  }

  Cliente copyWith({
    int? id,
    DateTime? fechaNacimiento,
    double? calificacionPromedio,
  }) {
    return Cliente(
      id: id ?? this.id,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      calificacionPromedio: calificacionPromedio ?? this.calificacionPromedio,
    );
  }
}
