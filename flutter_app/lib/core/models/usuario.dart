class Usuario {
  final int id;
  final String email;
  final String tipoUsuario;
  final String estado;
  final DateTime fechaRegistro;
  final DateTime? ultimoAcceso;
  final String? nombre;
  final String? apellido;
  final String? fotoPerfilUrl;

  Usuario({
    required this.id,
    required this.email,
    required this.tipoUsuario,
    required this.estado,
    required this.fechaRegistro,
    this.ultimoAcceso,
    this.nombre,
    this.apellido,
    this.fotoPerfilUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] ?? json['id_usuario']) as int,
      email: json['email'] as String,
      tipoUsuario: json['tipo_usuario'] as String,
      estado: (json['estado'] ?? 'activo') as String,
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'] as String)
          : DateTime.now(),
      ultimoAcceso: json['ultimo_acceso'] != null
          ? DateTime.parse(json['ultimo_acceso'] as String)
          : null,
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      fotoPerfilUrl: json['foto_perfil_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'tipo_usuario': tipoUsuario,
      'estado': estado,
      'fecha_registro': fechaRegistro.toIso8601String(),
      'ultimo_acceso': ultimoAcceso?.toIso8601String(),
      'nombre': nombre,
      'apellido': apellido,
      'foto_perfil_url': fotoPerfilUrl,
    };
  }

  Usuario copyWith({
    int? id,
    String? email,
    String? tipoUsuario,
    String? estado,
    DateTime? fechaRegistro,
    DateTime? ultimoAcceso,
    String? nombre,
    String? apellido,
    String? fotoPerfilUrl,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      estado: estado ?? this.estado,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      fotoPerfilUrl: fotoPerfilUrl ?? this.fotoPerfilUrl,
    );
  }
}
