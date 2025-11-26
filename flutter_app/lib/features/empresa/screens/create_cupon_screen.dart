import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/cupon_service.dart';
import 'package:servicios_app/core/models/cupon.dart';

class CreateCuponScreen extends StatefulWidget {
  const CreateCuponScreen({super.key, this.cuponToEdit});
  final Cupon? cuponToEdit;

  @override
  State<CreateCuponScreen> createState() => _CreateCuponScreenState();
}

class _CreateCuponScreenState extends State<CreateCuponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cuponService = CuponService();

  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _valorController = TextEditingController();
  final _minCompraController = TextEditingController();
  final _cantidadController = TextEditingController();

  String _tipoDescuento = 'porcentaje'; // o 'monto_fijo'
  DateTime? _fechaExpiracion;
  DateTime _fechaInicio = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Si recibimos un cupón para editar, llenamos los campos
    if (widget.cuponToEdit != null) {
      final cupon = widget.cuponToEdit!;
      _codigoController.text = cupon.codigo;
      _descripcionController.text = cupon.descripcion ?? '';
      _tipoDescuento = cupon.tipoDescuento;
      _valorController.text =
          cupon.valorDescuento.toString(); // Asumiendo que es numérico
      _cantidadController.text = cupon.cantidadDisponible.toString();
      _minCompraController.text = cupon.montoMinimoCompra?.toString() ?? '';

      // Asignar fechas (asegúrate que tu modelo Cupon tenga estos campos como DateTime)
      // Si vienen como String desde el modelo, usa DateTime.parse()
      if (cupon.fechaInicio != null) {
        _fechaInicio = cupon.fechaInicio!;
      }
      _fechaExpiracion = cupon.fechaExpiracion;
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    _valorController.dispose();
    _minCompraController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isStart) async {
    final initialDate = isStart
        ? _fechaInicio
        : (_fechaExpiracion ?? DateTime.now().add(const Duration(days: 7)));

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _fechaInicio = picked;
          // Si la fecha de inicio es después de la expiración, limpiar expiración
          if (_fechaExpiracion != null &&
              _fechaInicio.isAfter(_fechaExpiracion!)) {
            _fechaExpiracion = null;
          }
        } else {
          _fechaExpiracion = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaExpiracion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha de expiración')),
      );
      return;
    }

    if (_fechaExpiracion!.isBefore(_fechaInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('La fecha de expiración debe ser posterior al inicio')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final empresa = Provider.of<AuthProvider>(context, listen: false).empresa;

      final data = {
        'id_empresa': empresa!.id,
        'codigo': _codigoController.text.toUpperCase(),
        'descripcion': _descripcionController.text,
        'tipo_descuento': _tipoDescuento,
        'valor_descuento': double.parse(_valorController.text),
        'monto_minimo_compra': _minCompraController.text.isEmpty
            ? 0
            : double.parse(_minCompraController.text),
        'cantidad_disponible': int.parse(_cantidadController.text),
        'fecha_inicio': _fechaInicio.toIso8601String(),
        'fecha_expiracion': _fechaExpiracion!.toIso8601String(),
        // Nota: 'aplicable_a' y 'activo' se suelen manejar en backend o defaults
      };

      bool success;

      // LÓGICA DE DECISIÓN (CREAR vs EDITAR)
      if (widget.cuponToEdit == null) {
        // Modo Creación
        // Asegúrate que tu servicio retorne bool o lanza excepción
        await _cuponService.createCupon(data);
        success = true;
      } else {
        // Modo Edición
        // Asegúrate de tener este método en tu CuponService
        success = await _cuponService.updateCupon(widget.cuponToEdit!.id, data);
      }

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.cuponToEdit == null
                  ? 'Cupón creado exitosamente'
                  : 'Cupón actualizado exitosamente'),
              backgroundColor: AppTheme.successColor),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al crear cupón: $e'),
              backgroundColor: AppTheme.errorColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Cupón')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CÓDIGO
              TextFormField(
                controller: _codigoController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Código del Cupón (Ej: VERANO2024)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // NUEVO: Input Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del Cupón',
                  hintText:
                      'Ej: Descuento válido para servicios de limpieza...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2, // Permitir 2 líneas para que se vea mejor
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // TIPO DESCUENTO
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Porcentaje (%)'),
                      value: 'porcentaje',
                      groupValue: _tipoDescuento,
                      onChanged: (v) => setState(() => _tipoDescuento = v!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Monto Fijo (\$)'),
                      value: 'monto_fijo',
                      groupValue: _tipoDescuento,
                      onChanged: (v) => setState(() => _tipoDescuento = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // VALOR
              TextFormField(
                controller: _valorController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _tipoDescuento == 'porcentaje'
                      ? 'Porcentaje de descuento'
                      : 'Monto de descuento',
                  suffixText: _tipoDescuento == 'porcentaje' ? '%' : '\$',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  final num = double.tryParse(v);
                  if (num == null || num <= 0) return 'Inválido';
                  if (_tipoDescuento == 'porcentaje' && num > 100)
                    return 'Máximo 100%';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // STOCK Y MINIMO
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad Total',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _minCompraController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Compra Mínima \$',
                        border: OutlineInputBorder(),
                        hintText: '0 para ninguno',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Vigencia',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Row(
                children: [
                  // FECHA INICIO
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(true), // true para inicio
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha Inicio',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_fechaInicio),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // FECHA EXPIRACIÓN
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(false), // false para expiración
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha Expiración',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event_busy),
                        ),
                        child: Text(
                          _fechaExpiracion == null
                              ? 'Seleccionar'
                              : DateFormat('dd/MM/yyyy')
                                  .format(_fechaExpiracion!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('CREAR CUPÓN',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
