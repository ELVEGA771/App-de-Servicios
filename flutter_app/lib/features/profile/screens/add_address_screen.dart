import 'package:flutter/material.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/services/direccion_service.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _direccionService = DireccionService();
  bool _isLoading = false;

  // Controladores
  final _aliasController = TextEditingController();
  final _callePrincipalController = TextEditingController();
  final _calleSecundariaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _referenciaController = TextEditingController();

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Construir objeto según lo que espera tu backend (AddressController.js)
      final data = {
        'alias': _aliasController.text,
        'calle_principal': _callePrincipalController.text,
        'calle_secundaria': _calleSecundariaController.text,
        'numero': _numeroController.text,
        'ciudad': _ciudadController.text,
        'provincia_estado': _provinciaController.text,
        'referencia': _referenciaController.text,
        'es_principal': false, // Por defecto
        'pais': 'Ecuador' // O tu país por defecto
      };

      await _direccionService.createDireccion(data);

      if (mounted) {
        Navigator.pop(context); // Volver a la lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Dirección guardada correctamente'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Dirección')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                    labelText: 'Nombre (Ej: Casa, Oficina)',
                    prefixIcon: Icon(Icons.label)),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _callePrincipalController,
                decoration: const InputDecoration(
                    labelText: 'Calle Principal',
                    prefixIcon: Icon(Icons.add_road)),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numeroController,
                      decoration: const InputDecoration(
                          labelText: 'Número',
                          prefixIcon: Icon(Icons.home_filled)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _ciudadController,
                      decoration: const InputDecoration(
                          labelText: 'Ciudad',
                          prefixIcon: Icon(Icons.location_city)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _provinciaController,
                decoration: const InputDecoration(
                    labelText: 'Provincia/Estado', prefixIcon: Icon(Icons.map)),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _calleSecundariaController,
                decoration: const InputDecoration(
                    labelText: 'Calle Secundaria (Opcional)',
                    prefixIcon: Icon(Icons.timeline)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenciaController,
                decoration: const InputDecoration(
                    labelText: 'Referencia (Color de casa, etc.)',
                    prefixIcon: Icon(Icons.info_outline)),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar Dirección'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
