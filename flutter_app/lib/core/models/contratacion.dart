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
  final String? notasEmpresa;
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
    this.notasEmpresa,
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
    // Helper to safely parse double from String or num
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Helper to safely parse int from String or num
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Contratacion(
      id: parseInt(json['id_contratacion']) ?? parseInt(json['id']) ?? 0,
      idCliente: parseInt(json['id_cliente']) ?? 0,
      idServicio: parseInt(json['id_servicio']) ?? 0,
      idSucursal: parseInt(json['id_sucursal']) ?? 0,
      idDireccion: parseInt(json['id_direccion']) ?? parseInt(json['id_direccion_entrega']),
      fechaContratacion: json['fecha_solicitud'] != null 
          ? DateTime.parse(json['fecha_solicitud'] as String)
          : (json['fecha_contratacion'] != null 
              ? DateTime.parse(json['fecha_contratacion'] as String) 
              : DateTime.now()),
      fechaProgramada: json['fecha_programada'] != null
          ? DateTime.parse(json['fecha_programada'] as String)
          : null,
      estado: json['estado_contratacion'] as String? ?? json['estado'] as String? ?? 'pendiente',
      precioBase: parseDouble(json['precio_subtotal'] ?? json['precio_base']),
      descuento: parseDouble(json['descuento_aplicado'] ?? json['descuento']),
      precioFinal: parseDouble(json['precio_total'] ?? json['precio_final']),
      metodoPago: json['metodo_pago'] as String?,
      notas: json['notas_cliente'] as String? ?? json['notas'] as String?,
      notasEmpresa: json['notas_empresa'] as String?,
      fechaCompletado: json['fecha_completado'] != null
          ? DateTime.parse(json['fecha_completado'] as String)
          : null,
      motivoCancelacion: json['motivo_cancelacion'] as String?,
      servicioNombre: json['servicio_nombre'] as String?,
      servicioImagen: json['servicio_imagen'] as String?,
      empresaNombre: json['empresa_nombre'] as String?,
      clienteNombre: json['cliente_nombre'] as String?,
      sucursalNombre: json['nombre_sucursal'] as String? ?? json['sucursal_nombre'] as String?,
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
      'notas_empresa': notasEmpresa,
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
    String? notasEmpresa,
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
      notasEmpresa: notasEmpresa ?? this.notasEmpresa,
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

class HistorialContratacion {
  final int idHistorial;
  final int idContratacion;
  final String? estadoAnterior;
  final String estadoNuevo;
  final DateTime fechaCambio;
  final String? notas;
  final int? idUsuarioResponsable;
  final String? usuarioNombre;
  final String? usuarioApellido;
  final String? servicioNombre;

  HistorialContratacion({
    required this.idHistorial,
    required this.idContratacion,
    this.estadoAnterior,
    required this.estadoNuevo,
    required this.fechaCambio,
    this.notas,
    this.idUsuarioResponsable,
    this.usuarioNombre,
    this.usuarioApellido,
    this.servicioNombre,
  });

  factory HistorialContratacion.fromJson(Map<String, dynamic> json) {
    return HistorialContratacion(
      idHistorial: json['id_historial'] as int,
      idContratacion: json['id_contratacion'] as int,
      estadoAnterior: json['estado_anterior'] as String?,
      estadoNuevo: json['estado_nuevo'] as String,
      fechaCambio: DateTime.parse(json['fecha_cambio'] as String),
      notas: json['notas'] as String?,
      idUsuarioResponsable: json['id_usuario_responsable'] as int?,
      usuarioNombre: json['usuario_nombre'] as String?,
      usuarioApellido: json['usuario_apellido'] as String?,
      servicioNombre: json['servicio_nombre'] as String?,
    );
  }
}
