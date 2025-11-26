class Cupon {
  final int id;
  final String codigo;
  final String descripcion;
  final String tipoDescuento; // 'porcentaje' o 'monto_fijo'
  final double valorDescuento;
  final double montoMinimoCompra;
  final int cantidadDisponible;
  final int cantidadUsada;
  final DateTime? fechaInicio;
  final DateTime? fechaExpiracion;
  final bool activo;
  final String aplicableA;
  final int idEmpresa;

  Cupon({
    required this.id,
    required this.codigo,
    required this.descripcion,
    required this.tipoDescuento,
    required this.valorDescuento,
    this.montoMinimoCompra = 0.0,
    required this.cantidadDisponible,
    this.cantidadUsada = 0,
    this.fechaExpiracion,
    this.fechaInicio,
    this.activo = true,
    this.aplicableA = 'todos',
    required this.idEmpresa,
  });

  factory Cupon.fromJson(Map<String, dynamic> json) {
    return Cupon(
      id: json['id_cupon'] ?? 0,
      codigo: json['codigo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      tipoDescuento: json['tipo_descuento'] ?? 'porcentaje',

      // Manejo seguro de números (pueden venir como int, double o String de la DB)
      valorDescuento:
          double.tryParse(json['valor_descuento'].toString()) ?? 0.0,
      montoMinimoCompra:
          double.tryParse(json['monto_minimo_compra'].toString()) ?? 0.0,

      cantidadDisponible:
          int.tryParse(json['cantidad_disponible'].toString()) ?? 0,
      cantidadUsada: int.tryParse(json['cantidad_usada'].toString()) ?? 0,

      // Parseo de fecha
      fechaExpiracion: json['fecha_expiracion'] != null
          ? DateTime.parse(json['fecha_expiracion'].toString())
          : null,
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'].toString())
          : null,

      // La DB puede devolver 1/0 o true/false
      activo: json['activo'] == 1 || json['activo'] == true,

      aplicableA: json['aplicable_a'] ?? 'todos',
      idEmpresa: int.tryParse(json['id_empresa'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cupon': id,
      'codigo': codigo,
      'descripcion': descripcion,
      'tipo_descuento': tipoDescuento,
      'valor_descuento': valorDescuento,
      'monto_minimo_compra': montoMinimoCompra,
      'cantidad_disponible': cantidadDisponible,
      'cantidad_usada': cantidadUsada,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_expiracion': fechaExpiracion?.toIso8601String(),
      'activo': activo,
      'aplicable_a': aplicableA,
      'id_empresa': idEmpresa,
    };
  }

  // Helper para saber si sigue siendo válido en la UI sin llamar a la API
  bool get isValid {
    if (!activo) return false;
    if (fechaExpiracion != null && DateTime.now().isAfter(fechaExpiracion!))
      return false;
    if (cantidadDisponible > 0 && cantidadUsada >= cantidadDisponible)
      return false;
    return true;
  }
}
