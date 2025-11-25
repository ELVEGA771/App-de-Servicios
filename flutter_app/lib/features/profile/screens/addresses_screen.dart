import 'package:flutter/material.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/direccion.dart';
import 'package:servicios_app/core/services/direccion_service.dart';
import 'package:servicios_app/features/profile/screens/add_address_screen.dart'; // La crearemos en el paso 3

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final DireccionService _direccionService = DireccionService();
  List<Direccion> _direcciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDirecciones();
  }

  Future<void> _loadDirecciones() async {
    setState(() => _isLoading = true);
    try {
      final direcciones = await _direccionService.getDirecciones();
      setState(() {
        _direcciones = direcciones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteDireccion(int id) async {
    try {
      await _direccionService.deleteDireccion(id);
      _loadDirecciones(); // Recargar lista
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Direcciones')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar a pantalla de crear y recargar al volver
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddAddressScreen()));
          _loadDirecciones();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _direcciones.isEmpty
              ? const Center(child: Text('No tienes direcciones guardadas'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _direcciones.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final direccion = _direcciones[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.1),
                          child: Icon(
                            direccion.alias.toLowerCase().contains('casa')
                                ? Icons.home
                                : direccion.alias
                                        .toLowerCase()
                                        .contains('trabajo')
                                    ? Icons.work
                                    : Icons.location_on,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        title: Text(direccion.alias.isNotEmpty
                            ? direccion.alias
                            : 'Dirección'),
                        subtitle: Text(direccion.direccionCompleta),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _deleteDireccion(direccion.id),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
