import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/servicio.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/servicio_service.dart';

class EmpresaServicesScreen extends StatefulWidget {
  const EmpresaServicesScreen({super.key});

  @override
  State<EmpresaServicesScreen> createState() => _EmpresaServicesScreenState();
}

class _EmpresaServicesScreenState extends State<EmpresaServicesScreen> {
  final ServicioService _servicioService = ServicioService();
  List<Servicio> _servicios = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final empresaId = authProvider.empresa?.id;

      if (empresaId != null) {
        final servicios = await _servicioService.getServiciosByEmpresa(empresaId);
        if (mounted) {
          setState(() {
            _servicios = servicios;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = 'No se pudo identificar la empresa';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar servicios: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteServicio(Servicio servicio) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar "${servicio.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _servicioService.deleteServicio(servicio.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Servicio eliminado correctamente')),
          );
          _loadServices(); // Recargar lista
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nota: No usamos Scaffold aquí porque esta vista se incrusta en el HomeScreen
    // que ya tiene Scaffold. Si se usara independientemente, sí llevaría Scaffold.
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadServices,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_servicios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work_off_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No tienes servicios registrados'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context, 
                  '/empresa/service/create'
                );
                if (result == true) _loadServices();
              },
              icon: const Icon(Icons.add),
              label: const Text('Crear mi primer servicio'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _servicios.length + 1, // +1 para el espacio final o botón flotante
        itemBuilder: (context, index) {
          if (index == _servicios.length) {
            // Botón al final de la lista para agregar más
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context, 
                      '/empresa/service/create'
                    );
                    if (result == true) _loadServices();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Nuevo Servicio'),
                ),
              ),
            );
          }

          final servicio = _servicios[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: servicio.imagenPrincipal != null
                      ? DecorationImage(
                          image: NetworkImage(servicio.imagenPrincipal!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: servicio.imagenPrincipal == null
                    ? const Icon(Icons.image, color: Colors.grey)
                    : null,
              ),
              title: Text(
                servicio.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '\$${servicio.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: servicio.estado == 'disponible' 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          servicio.estado.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: servicio.estado == 'disponible' 
                                ? Colors.green 
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    final result = await Navigator.pushNamed(
                      context,
                      '/empresa/service/edit',
                      arguments: {'id': servicio.id}, // Pasamos el ID en un mapa
                    );
                    if (result == true) _loadServices();
                  } else if (value == 'delete') {
                    _deleteServicio(servicio);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}