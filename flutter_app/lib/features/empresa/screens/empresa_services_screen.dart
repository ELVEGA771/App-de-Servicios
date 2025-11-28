import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/constants.dart';
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
  Map<String, Map<String, List<Map<String, dynamic>>>> _groupedServices = {};

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
            _groupedServices = _groupServicesBySucursalAndCategoria(servicios);
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

  Map<String, Map<String, List<Map<String, dynamic>>>> _groupServicesBySucursalAndCategoria(
      List<Servicio> servicios) {
    Map<String, Map<String, List<Map<String, dynamic>>>> grouped = {};

    for (var servicio in servicios) {
      // Si el servicio tiene sucursales disponibles
      if (servicio.sucursalesDisponibles != null &&
          servicio.sucursalesDisponibles!.isNotEmpty) {
        for (var sucursalData in servicio.sucursalesDisponibles!) {
          String sucursalNombre;
          int? sucursalId;
          bool disponible = true;

          // Manejar diferentes formatos de datos de sucursal
          if (sucursalData is Map<String, dynamic>) {
            sucursalNombre = sucursalData['nombre_sucursal'] as String? ??
                            sucursalData['nombreSucursal'] as String? ??
                            'Sucursal sin nombre';
            sucursalId = sucursalData['id_sucursal'] as int?;
            disponible = (sucursalData['disponible'] == 1 || sucursalData['disponible'] == true);
          } else {
            sucursalNombre = sucursalData.toString();
          }

          // Agrupar por sucursal
          if (!grouped.containsKey(sucursalNombre)) {
            grouped[sucursalNombre] = {};
          }

          // Agrupar por categoría dentro de la sucursal
          String categoriaNombre = servicio.categoriaNombre ?? 'Sin categoría';
          if (!grouped[sucursalNombre]!.containsKey(categoriaNombre)) {
            grouped[sucursalNombre]![categoriaNombre] = [];
          }

          grouped[sucursalNombre]![categoriaNombre]!.add({
            'servicio': servicio,
            'sucursalId': sucursalId,
            'disponible': disponible,
          });
        }
      } else {
        // Servicios sin sucursal asignada
        String sucursalNombre = 'Sin sucursal asignada';
        if (!grouped.containsKey(sucursalNombre)) {
          grouped[sucursalNombre] = {};
        }

        String categoriaNombre = servicio.categoriaNombre ?? 'Sin categoría';
        if (!grouped[sucursalNombre]!.containsKey(categoriaNombre)) {
          grouped[sucursalNombre]![categoriaNombre] = [];
        }

        grouped[sucursalNombre]![categoriaNombre]!.add({
          'servicio': servicio,
          'sucursalId': null,
          'disponible': false,
        });
      }
    }

    return grouped;
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón para agregar nuevo servicio
            OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/empresa/service/create',
                );
                if (result == true) _loadServices();
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar Nuevo Servicio'),
            ),
            const SizedBox(height: 16),

            // Servicios agrupados por sucursal y categoría
            ..._buildGroupedServicesList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedServicesList() {
    List<Widget> widgets = [];

    // Ordenar sucursales alfabéticamente
    final sortedSucursales = _groupedServices.keys.toList()..sort();

    for (var sucursalNombre in sortedSucursales) {
      final categorias = _groupedServices[sucursalNombre]!;

      // Contar total de servicios en esta sucursal
      int totalServicios = 0;
      categorias.forEach((_, servicios) {
        totalServicios += servicios.length;
      });

      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.store, color: AppTheme.primaryColor),
              title: Text(
                sucursalNombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '$totalServicios servicio${totalServicios != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 12),
              ),
              children: _buildCategoriasForSucursal(categorias),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildCategoriasForSucursal(
      Map<String, List<Map<String, dynamic>>> categorias) {
    List<Widget> widgets = [];

    // Ordenar categorías alfabéticamente
    final sortedCategorias = categorias.keys.toList()..sort();

    for (var categoriaNombre in sortedCategorias) {
      final serviciosData = categorias[categoriaNombre]!;

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            color: Colors.grey[50],
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.category, size: 20, color: AppTheme.secondaryColor),
              title: Text(
                categoriaNombre,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '${serviciosData.length} servicio${serviciosData.length != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 11),
              ),
              children: serviciosData.map((data) => _buildServicioItem(
                data['servicio'] as Servicio,
                data['sucursalId'] as int?,
                data['disponible'] as bool,
              )).toList(),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Future<void> _toggleDisponibilidad(Servicio servicio, int? sucursalId, bool currentValue) async {
    if (sucursalId == null) return;

    try {
      await _servicioService.toggleDisponibilidadSucursal(
        servicioId: servicio.id,
        sucursalId: sucursalId,
        disponible: !currentValue,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !currentValue
                  ? 'Servicio activado en esta sucursal'
                  : 'Servicio desactivado en esta sucursal',
            ),
          ),
        );
        _loadServices(); // Recargar lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar disponibilidad: $e')),
        );
      }
    }
  }

  Widget _buildServicioItem(Servicio servicio, int? sucursalId, bool disponible) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    image: NetworkImage(
                        AppConstants.fixImageUrl(servicio.imagenPrincipal!)),
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
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
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
                const SizedBox(width: 8),
                // Badge de disponibilidad en sucursal
                if (sucursalId != null)
                  Row(
                    children: [
                      Icon(
                        disponible ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: disponible ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        disponible ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 10,
                          color: disponible ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Switch de disponibilidad
            if (sucursalId != null)
              Switch(
                value: disponible,
                onChanged: (value) {
                  _toggleDisponibilidad(servicio, sucursalId, disponible);
                },
                activeTrackColor: AppTheme.primaryColor,
              ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Navigator.pushNamed(
                    context,
                    '/empresa/service/edit',
                    arguments: {'id': servicio.id},
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
          ],
        ),
      ),
    );
  }
}