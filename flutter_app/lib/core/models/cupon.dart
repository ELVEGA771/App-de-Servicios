class Cupon {
  final int id;
  final int idEmpresa;
  final String codigo;
  final String? descripcion;
  final String tipoDescuento;
  final double valorDescuento;
  final double? montoMinimo;
  final double? descuentoMaximo;
  final DateTime? fechaInicio;
  final DateTime? fechaExpiracion;
  final int? usos Maximos;
  final int? cantidadUsada;
  final String estado;
  final DateTime fechaCreacion;

  // Datos adicionales
  final String? empresaNombre;

  Cupon({
    required this.id,
    required this.idEmpresa,
    required this.codigo,
    this.descripcion,
    required this.tipoDescuento,
    required this.valorDescuento,
    this.montoMinimo,
    this.descuentoMaximo,
    this.fechaInicio,
    this.fechaExpiracion,
    this.usosMaximos,
    this.cantidadUsada,
    required this.estado,
    required this.fechaCreacion,
    this.empresaNombre,
  });

  factory Cupon.fromJson(Map<String, dynamic> json) {
    return Cupon(
      id: json['id'] as int,
      idEmpresa: json['id_empresa'] as int,
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String?,
      tipoDescuento: json['tipo_descuento'] as String,
      valorDescuento: (json['valor_descuento'] as num).toDouble(),
      montoMinimo: json['monto_minimo'] != null
          ? (json['monto_minimo'] as num).toDouble()
          : null,
      descuentoMaximo: json['descuento_maximo'] != null
          ? (json['descuento_maximo'] as num).toDouble()
          : null,
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'] as String)
          : null,
      fechaExpiracion: json['fecha_expiracion'] != null
          ? DateTime.parse(json['fecha_expiracion'] as String)
          : null,
      usosMaximos: json['usos_maximos'] as int?,
      cantidadUsada: json['cantidad_usada'] as int?,
      estado: json['estado'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      empresaNombre: json['empresa_nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_empresa': idEmpresa,
      'codigo': codigo,
      'descripcion': descripcion,
      'tipo_descuento': tipoDescuento,
      'valor_descuento': valorDescuento,
      'monto_minimo': montoMinimo,
      'descuento_maximo': descuentoMaximo,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_expiracion': fechaExpiracion?.toIso8601String(),
      'usos_maximos': usosMaximos,
      'cantidad_usada': cantidadUsada,
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'empresa_nombre': empresaNombre,
    };
  }

  bool get isActive => estado == 'activo';
  bool get isExpired => fechaExpiracion != null && fechaExpiracion!.isBefore(DateTime.now());
  bool get isStarted => fechaInicio == null || fechaInicio!.isBefore(DateTime.now());
  bool get isValid => isActive && !isExpired && isStarted;
  bool get isPercentage => tipoDescuento == 'porcentaje';
  bool get isFixed => tipoDescuento == 'monto_fijo';

  String get descuentoLabel {
    if (isPercentage) {
      return '${valorDescuento.toStringAsFixed(0)}% OFF';
    } else {
      return '\$${valorDescuento.toStringAsFixed(2)} OFF';
    }
  }

  double calcularDescuento(double montoCompra) {
    if (!isValid) return 0;
    if (montoMinimo != null && montoCompra < montoMinimo!) return 0;

    double descuento;
    if (isPercentage) {
      descuento = montoCompra * (valorDescuento / 100);
    } else {
      descuento = valorDescuento;
    }

    if (descuentoMaximo != null && descuento > descuentoMaximo!) {
      descuento = descuentoMaximo!;
    }

    return descuento;
  }

  Cupon copyWith({
    int? id,
    int? idEmpresa,
    String? codigo,
    String? descripcion,
    String? tipoDescuento,
    double? valorDescuento,
    double? montoMinimo,
    double? descuentoMaximo,
    DateTime? fechaInicio,
    DateTime? fechaExpiracion,
    int? usosMaximos,
    int? cantidadUsada,
    String? estado,
    DateTime? fechaCreacion,
    String? empresaNombre,
  }) {
    return Cupon(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      tipoDescuento: tipoDescuento ?? this.tipoDescuento,
      valorDescuento: valorDescuento ?? this.valorDescuento,
      montoMinimo: montoMinimo ?? this.montoMinimo,
      descuentoMaximo: descuentoMaximo ?? this.descuentoMaximo,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      usosMaximos: usosMaximos ?? this.usosMaximos,
      cantidadUsada: cantidadUsada ?? this.cantidadUsada,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      empresaNombre: empresaNombre ?? this.empresaNombre,
    );
  }
}
