import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/direccion.dart';
import 'package:servicios_app/core/providers/direccion_provider.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Direccion? direccion;

  const AddEditAddressScreen({super.key, this.direccion});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _aliasController;
  late TextEditingController _callePrincipalController;
  late TextEditingController _calleSecundariaController;
  late TextEditingController _numeroController;
  late TextEditingController _ciudadController;
  late TextEditingController _estadoController;
  late TextEditingController _codigoPostalController;
  late TextEditingController _referenciaController;
  
  bool _esPrincipal = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final d = widget.direccion;
    _aliasController = TextEditingController(text: d?.alias ?? '');
    _callePrincipalController = TextEditingController(text: d?.callePrincipal ?? '');
    _calleSecundariaController = TextEditingController(text: d?.calleSecundaria ?? '');
    _numeroController = TextEditingController(text: d?.numero ?? '');
    _ciudadController = TextEditingController(text: d?.ciudad ?? '');
    _estadoController = TextEditingController(text: d?.estado ?? '');
    _codigoPostalController = TextEditingController(text: d?.codigoPostal ?? '');
    _referenciaController = TextEditingController(text: d?.referencia ?? '');
    _esPrincipal = d?.esPrincipal ?? false;
  }

  @override
  void dispose() {
    _aliasController.dispose();
    _callePrincipalController.dispose();
    _calleSecundariaController.dispose();
    _numeroController.dispose();
    _ciudadController.dispose();
    _estadoController.dispose();
    _codigoPostalController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<DireccionProvider>(context, listen: false);
    
    final newDireccion = Direccion(
      id: widget.direccion?.id ?? 0, // 0 para nuevo
      idCliente: widget.direccion?.idCliente ?? 0, // Se ignora en create/update
      alias: _aliasController.text,
      callePrincipal: _callePrincipalController.text,
      calleSecundaria: _calleSecundariaController.text.isEmpty ? null : _calleSecundariaController.text,
      numero: _numeroController.text.isEmpty ? null : _numeroController.text,
      ciudad: _ciudadController.text,
      estado: _estadoController.text,
      codigoPostal: _codigoPostalController.text,
      referencia: _referenciaController.text.isEmpty ? null : _referenciaController.text,
      esPrincipal: _esPrincipal,
      latitud: null,
      longitud: null,
    );

    bool success;
    if (widget.direccion == null) {
      success = await provider.addDireccion(newDireccion);
    } else {
      success = await provider.updateDireccion(newDireccion);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al guardar dirección'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.direccion == null ? 'Nueva Dirección' : 'Editar Dirección'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                  labelText: 'Alias (ej. Casa, Trabajo)',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _callePrincipalController,
                      decoration: const InputDecoration(labelText: 'Calle Principal'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _numeroController,
                      decoration: const InputDecoration(labelText: 'Número'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _calleSecundariaController,
                decoration: const InputDecoration(labelText: 'Calle Secundaria (Opcional)'),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codigoPostalController,
                      decoration: const InputDecoration(labelText: 'C.P.'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _ciudadController,
                      decoration: const InputDecoration(labelText: 'Ciudad'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _referenciaController,
                decoration: const InputDecoration(
                  labelText: 'Referencias (Opcional)',
                  hintText: 'Entre calles, color de fachada, etc.',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Marcar como dirección principal'),
                value: _esPrincipal,
                onChanged: (val) => setState(() => _esPrincipal = val),
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'GUARDAR DIRECCIÓN',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
