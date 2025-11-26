import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/cupon_service.dart';

class CreateCuponScreen extends StatefulWidget {
  const CreateCuponScreen({super.key});

  @override
  State<CreateCuponScreen> createState() => _CreateCuponScreenState();
}

class _CreateCuponScreenState extends State<CreateCuponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cuponService = CuponService();

  final _codigoController = TextEditingController();
  final _valorController = TextEditingController();
  final _minCompraController = TextEditingController();
  final _cantidadController = TextEditingController();

  String _tipoDescuento = 'porcentaje'; // o 'monto_fijo'
  DateTime? _fechaExpiracion;
  bool _isLoading = false;

  @override
  void dispose() {
    _codigoController.dispose();
    _valorController.dispose();
    _minCompraController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _fechaExpiracion = picked);
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

    setState(() => _isLoading = true);

    try {
      final empresa = Provider.of<AuthProvider>(context, listen: false).empresa;

      final data = {
        'id_empresa': empresa!.id,
        'codigo': _codigoController.text.toUpperCase(),
        'tipo_descuento': _tipoDescuento,
        'valor_descuento': double.parse(_valorController.text),
        'monto_minimo_compra': _minCompraController.text.isEmpty
            ? 0
            : double.parse(_minCompraController.text),
        'cantidad_disponible': int.parse(_cantidadController.text),
        'fecha_expiracion': _fechaExpiracion!.toIso8601String(),
        'aplicable_a': 'todos' // Hardcodeado por ahora según SP
      };

      await _cuponService.createCupon(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Cupón creado exitosamente'),
              backgroundColor: AppTheme.successColor),
        );
        Navigator.pop(context, true); // Retornar true para recargar lista
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

              // FECHA
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Expiración',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _fechaExpiracion == null
                        ? 'Seleccionar fecha'
                        : DateFormat('dd/MM/yyyy').format(_fechaExpiracion!),
                  ),
                ),
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
