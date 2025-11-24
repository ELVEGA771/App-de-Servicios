class Categoria {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? icono;
  final int? totalServicios;

  Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
    this.totalServicios,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: (json['id'] ?? json['id_categoria']) as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      icono: (json['icono'] ?? json['icono_url']) as String?,
      totalServicios: json['total_servicios'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'total_servicios': totalServicios,
    };
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? icono,
    int? totalServicios,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
      totalServicios: totalServicios ?? this.totalServicios,
    );
  }
}
