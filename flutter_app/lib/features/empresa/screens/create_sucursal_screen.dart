import 'package:flutter/material.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/sucursal.dart';
import 'package:servicios_app/core/services/sucursal_service.dart';

class CreateSucursalScreen extends StatefulWidget {
  final Sucursal? sucursal;

  const CreateSucursalScreen({super.key, this.sucursal});

  @override
  State<CreateSucursalScreen> createState() => _CreateSucursalScreenState();
}

class _CreateSucursalScreenState extends State<CreateSucursalScreen> {
  final _formKey = GlobalKey<FormState>();
  final SucursalService _sucursalService = SucursalService();

  // Form controllers
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();

  final _callePrincipalController = TextEditingController();
  final _calleSecundariaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _referenciaController = TextEditingController();

  // Time variables
  TimeOfDay? _aperturaTime;
  TimeOfDay? _cierreTime;

  final List<bool> _selectedDays = List.filled(7, false);
  final List<String> _dayNames = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  bool _isLoading = false;
  bool get _isEditing => widget.sucursal != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadSucursalData();
    } else {
      for (int i = 0; i < 5; i++) {
        _selectedDays[i] = true;
      }
    }
  }

  void _loadSucursalData() {
    final sucursal = widget.sucursal!;
    _nombreController.text = sucursal.nombreSucursal;
    _telefonoController.text = sucursal.telefono ?? '';

    if (sucursal.diasLaborales != null && sucursal.diasLaborales!.length == 7) {
      for (int i = 0; i < 7; i++) {
        _selectedDays[i] = sucursal.diasLaborales![i] == '1';
      }
    } else {
      // Fallback si viene texto antiguo o nulo
      for (int i = 0; i < 5; i++) {
        _selectedDays[i] = true;
      }
    }

    // Parse times
    if (sucursal.horarioApertura != null) {
      _aperturaTime = _parseTime(sucursal.horarioApertura!);
    }
    if (sucursal.horarioCierre != null) {
      _cierreTime = _parseTime(sucursal.horarioCierre!);
    }

    _callePrincipalController.text = sucursal.callePrincipal;
    _calleSecundariaController.text = sucursal.calleSecundaria ?? '';
    _numeroController.text = sucursal.numero ?? '';
    _ciudadController.text = sucursal.ciudad;
    _provinciaController.text = sucursal.provinciaEstado;
    _codigoPostalController.text = sucursal.codigoPostal ?? '';
    _referenciaController.text = sucursal.referencia ?? '';
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  String _getDiasLaboralesString() {
    return _selectedDays.map((day) => day ? '1' : '0').join();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _callePrincipalController.dispose();
    _calleSecundariaController.dispose();
    _numeroController.dispose();
    _ciudadController.dispose();
    _provinciaController.dispose();
    _codigoPostalController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isApertura) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isApertura
          ? (_aperturaTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_cierreTime ?? const TimeOfDay(hour: 18, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isApertura) {
          _aperturaTime = picked;
        } else {
          _cierreTime = picked;
        }
      });
    }
  }

  String _formatTimeForDB(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selecciona al menos un día laboral'),
            backgroundColor: AppTheme.warningColor),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final String? apertura =
          _aperturaTime != null ? _formatTimeForDB(_aperturaTime!) : null;
      final String? cierre =
          _cierreTime != null ? _formatTimeForDB(_cierreTime!) : null;
      final String diasLaboralesStr = _getDiasLaboralesString();

      if (_isEditing) {
        await _sucursalService.updateSucursal(
          id: widget.sucursal!.idSucursal,
          nombreSucursal: _nombreController.text.trim(),
          telefono: _telefonoController.text.trim().isEmpty
              ? null
              : _telefonoController.text.trim(),
          // Campos nuevos
          horarioApertura: apertura,
          horarioCierre: cierre,
          diasLaborales: diasLaboralesStr,

          callePrincipal: _callePrincipalController.text.trim(),
          calleSecundaria: _calleSecundariaController.text.trim().isEmpty
              ? null
              : _calleSecundariaController.text.trim(),
          numero: _numeroController.text.trim().isEmpty
              ? null
              : _numeroController.text.trim(),
          ciudad: _ciudadController.text.trim(),
          provinciaEstado: _provinciaController.text.trim(),
          codigoPostal: _codigoPostalController.text.trim().isEmpty
              ? null
              : _codigoPostalController.text.trim(),
          referencia: _referenciaController.text.trim().isEmpty
              ? null
              : _referenciaController.text.trim(),
        );
      } else {
        await _sucursalService.createSucursal(
          nombreSucursal: _nombreController.text.trim(),
          telefono: _telefonoController.text.trim().isEmpty
              ? null
              : _telefonoController.text.trim(),
          // Campos nuevos
          horarioApertura: apertura,
          horarioCierre: cierre,
          diasLaborales: diasLaboralesStr,

          callePrincipal: _callePrincipalController.text.trim(),
          calleSecundaria: _calleSecundariaController.text.trim().isEmpty
              ? null
              : _calleSecundariaController.text.trim(),
          numero: _numeroController.text.trim().isEmpty
              ? null
              : _numeroController.text.trim(),
          ciudad: _ciudadController.text.trim(),
          provinciaEstado: _provinciaController.text.trim(),
          codigoPostal: _codigoPostalController.text.trim().isEmpty
              ? null
              : _codigoPostalController.text.trim(),
          referencia: _referenciaController.text.trim().isEmpty
              ? null
              : _referenciaController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isEditing
                        ? 'Sucursal actualizada exitosamente'
                        : 'Sucursal creada exitosamente',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = _isEditing
            ? 'Error al actualizar sucursal'
            : 'Error al crear sucursal';
        if (e.toString().contains('VALIDATION_ERROR')) {
          errorMessage = 'Por favor verifica los campos del formulario';
        } else if (e.toString().contains('Network')) {
          errorMessage = 'Error de conexión. Verifica tu internet';
        } else {
          errorMessage = 'Error: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Sucursal' : 'Crear Sucursal'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.store,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isEditing
                                      ? 'Editar Sucursal'
                                      : 'Nueva Sucursal',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Completa la información de la sucursal',
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Información básica
              const Text(
                'Información Básica',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Nombre de sucursal
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Sucursal',
                  hintText: 'Ej: Sucursal Centro',
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es requerido';
                  }
                  if (value.trim().length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ej: 099-999-9999',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              // SECCIÓN HORARIOS
              const Text(
                'Horarios de Atención',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, true),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Apertura',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _aperturaTime?.format(context) ?? 'Seleccionar',
                          style: TextStyle(
                            color: _aperturaTime != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, false),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Cierre',
                          prefixIcon: const Icon(Icons.access_time_filled),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _cierreTime?.format(context) ?? 'Seleccionar',
                          style: TextStyle(
                            color: _cierreTime != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Días laborales
              const Text('Días Laborales',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              // LISTA DE CHECKBOXES PARA DÍAS
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: List.generate(7, (index) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text(_dayNames[index]),
                          value: _selectedDays[index],
                          activeColor: AppTheme.primaryColor,
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedDays[index] = value ?? false;
                            });
                          },
                        ),
                        if (index < 6)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Dirección
              const Text(
                'Dirección',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Calle principal
              TextFormField(
                controller: _callePrincipalController,
                decoration: InputDecoration(
                  labelText: 'Calle Principal',
                  hintText: 'Ej: Av. 10 de Agosto',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La calle principal es requerida';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Calle secundaria (opcional)
              TextFormField(
                controller: _calleSecundariaController,
                decoration: InputDecoration(
                  labelText: 'Calle Secundaria (opcional)',
                  hintText: 'Ej: y Av. Amazonas',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Número (opcional)
              TextFormField(
                controller: _numeroController,
                decoration: InputDecoration(
                  labelText: 'Número (opcional)',
                  hintText: 'Ej: N24-123',
                  prefixIcon: const Icon(Icons.pin),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ciudad
              TextFormField(
                controller: _ciudadController,
                decoration: InputDecoration(
                  labelText: 'Ciudad',
                  hintText: 'Ej: Quito',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La ciudad es requerida';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Provincia
              TextFormField(
                controller: _provinciaController,
                decoration: InputDecoration(
                  labelText: 'Provincia/Estado',
                  hintText: 'Ej: Pichincha',
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La provincia/estado es requerida';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Código postal (opcional)
              TextFormField(
                controller: _codigoPostalController,
                decoration: InputDecoration(
                  labelText: 'Código Postal (opcional)',
                  hintText: 'Ej: 170150',
                  prefixIcon: const Icon(Icons.mail_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Referencia (opcional)
              TextFormField(
                controller: _referenciaController,
                decoration: InputDecoration(
                  labelText: 'Referencia (opcional)',
                  hintText: 'Ej: Frente al parque La Carolina',
                  prefixIcon: const Icon(Icons.info_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),

              // Botón de guardar
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isEditing ? 'Actualizar Sucursal' : 'Crear Sucursal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Botón de cancelar
              OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
