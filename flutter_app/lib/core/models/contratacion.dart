class Contratacion {
  final int id;
  final int idCliente;
  final int idServicio;
  final int idSucursal;
  final int? idDireccion;
  final DateTime fechaContratacion;
  final DateTime? fechaProgramada;
  final String estado;
  final double precioBase;
  final double? descuento;
  final double precioFinal;
  final String? metodoPago;
  final String? notas;
  final DateTime? fechaCompletado;
  final String? motivoCancelacion;

  // Datos adicionales de relaciones
  final String? servicioNombre;
  final String? servicioImagen;
  final String? empresaNombre;
  final String? clienteNombre;
  final String? sucursalNombre;
  final String? sucursalDireccion;

  Contratacion({
    required this.id,
    required this.idCliente,
    required this.idServicio,
    required this.idSucursal,
    this.idDireccion,
    required this.fechaContratacion,
    this.fechaProgramada,
    required this.estado,
    required this.precioBase,
    this.descuento,
    required this.precioFinal,
    this.metodoPago,
    this.notas,
    this.fechaCompletado,
    this.motivoCancelacion,
    this.servicioNombre,
    this.servicioImagen,
    this.empresaNombre,
    this.clienteNombre,
    this.sucursalNombre,
    this.sucursalDireccion,
  });

  factory Contratacion.fromJson(Map<String, dynamic> json) {
    return Contratacion(
      id: json['id'] as int,
      idCliente: json['id_cliente'] as int,
      idServicio: json['id_servicio'] as int,
      idSucursal: json['id_sucursal'] as int,
      idDireccion: json['id_direccion'] as int?,
      fechaContratacion: DateTime.parse(json['fecha_contratacion'] as String),
      fechaProgramada: json['fecha_programada'] != null
          ? DateTime.parse(json['fecha_programada'] as String)
          : null,
      estado: json['estado'] as String,
      precioBase: (json['precio_base'] as num).toDouble(),
      descuento: json['descuento'] != null
          ? (json['descuento'] as num).toDouble()
          : null,
      precioFinal: (json['precio_final'] as num).toDouble(),
      metodoPago: json['metodo_pago'] as String?,
      notas: json['notas'] as String?,
      fechaCompletado: json['fecha_completado'] != null
          ? DateTime.parse(json['fecha_completado'] as String)
          : null,
      motivoCancelacion: json['motivo_cancelacion'] as String?,
      servicioNombre: json['servicio_nombre'] as String?,
      servicioImagen: json['servicio_imagen'] as String?,
      empresaNombre: json['empresa_nombre'] as String?,
      clienteNombre: json['cliente_nombre'] as String?,
      sucursalNombre: json['sucursal_nombre'] as String?,
      sucursalDireccion: json['sucursal_direccion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_cliente': idCliente,
      'id_servicio': idServicio,
      'id_sucursal': idSucursal,
      'id_direccion': idDireccion,
      'fecha_contratacion': fechaContratacion.toIso8601String(),
      'fecha_programada': fechaProgramada?.toIso8601String(),
      'estado': estado,
      'precio_base': precioBase,
      'descuento': descuento,
      'precio_final': precioFinal,
      'metodo_pago': metodoPago,
      'notas': notas,
      'fecha_completado': fechaCompletado?.toIso8601String(),
      'motivo_cancelacion': motivoCancelacion,
      'servicio_nombre': servicioNombre,
      'servicio_imagen': servicioImagen,
      'empresa_nombre': empresaNombre,
      'cliente_nombre': clienteNombre,
      'sucursal_nombre': sucursalNombre,
      'sucursal_direccion': sucursalDireccion,
    };
  }

  bool get isPending => estado == 'pendiente';
  bool get isConfirmed => estado == 'confirmado';
  bool get isInProgress => estado == 'en_proceso';
  bool get isCompleted => estado == 'completado';
  bool get isCancelled => estado == 'cancelado';
  bool get isRejected => estado == 'rechazado';
  bool get isActive => isPending || isConfirmed || isInProgress;
  bool get canBeCancelled => isPending || isConfirmed;
  bool get canBeRated => isCompleted;

  String get estadoLabel {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'confirmado':
        return 'Confirmado';
      case 'en_proceso':
        return 'En Proceso';
      case 'completado':
        return 'Completado';
      case 'cancelado':
        return 'Cancelado';
      case 'rechazado':
        return 'Rechazado';
      default:
        return estado;
    }
  }

  Contratacion copyWith({
    int? id,
    int? idCliente,
    int? idServicio,
    int? idSucursal,
    int? idDireccion,
    DateTime? fechaContratacion,
    DateTime? fechaProgramada,
    String? estado,
    double? precioBase,
    double? descuento,
    double? precioFinal,
    String? metodoPago,
    String? notas,
    DateTime? fechaCompletado,
    String? motivoCancelacion,
    String? servicioNombre,
    String? servicioImagen,
    String? empresaNombre,
    String? clienteNombre,
    String? sucursalNombre,
    String? sucursalDireccion,
  }) {
    return Contratacion(
      id: id ?? this.id,
      idCliente: idCliente ?? this.idCliente,
      idServicio: idServicio ?? this.idServicio,
      idSucursal: idSucursal ?? this.idSucursal,
      idDireccion: idDireccion ?? this.idDireccion,
      fechaContratacion: fechaContratacion ?? this.fechaContratacion,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      estado: estado ?? this.estado,
      precioBase: precioBase ?? this.precioBase,
      descuento: descuento ?? this.descuento,
      precioFinal: precioFinal ?? this.precioFinal,
      metodoPago: metodoPago ?? this.metodoPago,
      notas: notas ?? this.notas,
      fechaCompletado: fechaCompletado ?? this.fechaCompletado,
      motivoCancelacion: motivoCancelacion ?? this.motivoCancelacion,
      servicioNombre: servicioNombre ?? this.servicioNombre,
      servicioImagen: servicioImagen ?? this.servicioImagen,
      empresaNombre: empresaNombre ?? this.empresaNombre,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      sucursalNombre: sucursalNombre ?? this.sucursalNombre,
      sucursalDireccion: sucursalDireccion ?? this.sucursalDireccion,
    );
  }
}
