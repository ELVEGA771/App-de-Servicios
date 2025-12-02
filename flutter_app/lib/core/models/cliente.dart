class Cliente {
  final int id;
  final double? calificacionPromedio;

  Cliente({
    required this.id,
    this.calificacionPromedio,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id_cliente'] as int,
      calificacionPromedio: json['calificacion_promedio'] != null
          ? (json['calificacion_promedio'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': id,
      'calificacion_promedio': calificacionPromedio,
    };
  }

  Cliente copyWith({
    int? id,
    double? calificacionPromedio,
  }) {
    return Cliente(
      id: id ?? this.id,
      calificacionPromedio: calificacionPromedio ?? this.calificacionPromedio,
    );
  }
}
