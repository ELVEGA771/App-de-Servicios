import 'package:flutter/material.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/sucursal.dart';
import 'package:servicios_app/core/services/sucursal_service.dart';

class ManageSucursalesScreen extends StatefulWidget {
  const ManageSucursalesScreen({super.key});

  @override
  State<ManageSucursalesScreen> createState() => _ManageSucursalesScreenState();
}

class _ManageSucursalesScreenState extends State<ManageSucursalesScreen> {
  final SucursalService _sucursalService = SucursalService();
  List<Sucursal> _sucursales = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSucursales();
  }

  Future<void> _loadSucursales() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _sucursalService.getAllSucursales();
      setState(() {
        _sucursales = response.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar sucursales: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSucursal(Sucursal sucursal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar la sucursal "${sucursal.nombreSucursal}"? Esta acción marcará la sucursal como inactiva.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _sucursalService.deleteSucursal(sucursal.idSucursal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sucursal eliminada exitosamente'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          _loadSucursales();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar sucursal: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _reactivateSucursal(Sucursal sucursal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar reactivación'),
        content: Text(
          '¿Estás seguro de que deseas reactivar la sucursal "${sucursal.nombreSucursal}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text('Reactivar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _sucursalService.reactivateSucursal(sucursal.idSucursal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sucursal reactivada exitosamente'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          _loadSucursales();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al reactivar sucursal: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _navigateToCreateSucursal() async {
    final result =
        await Navigator.pushNamed(context, '/empresa/sucursal/create');
    if (result == true) {
      _loadSucursales();
    }
  }

  Future<void> _navigateToEditSucursal(Sucursal sucursal) async {
    final result = await Navigator.pushNamed(
      context,
      '/empresa/sucursal/edit',
      arguments: sucursal,
    );
    if (result == true) {
      _loadSucursales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Sucursales'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSucursales,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: AppTheme.errorColor),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSucursales,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSucursales,
                  child: _sucursales.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store_outlined,
                                size: 80,
                                color: AppTheme.textSecondaryColor
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No tienes sucursales',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Crea tu primera sucursal',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _navigateToCreateSucursal,
                                icon: const Icon(Icons.add),
                                label: const Text('Crear Sucursal'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _sucursales.length,
                          itemBuilder: (context, index) {
                            final sucursal = _sucursales[index];
                            return _buildSucursalCard(sucursal);
                          },
                        ),
                ),
      floatingActionButton: _sucursales.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreateSucursal,
              icon: const Icon(Icons.add),
              label: const Text('Nueva Sucursal'),
            )
          : null,
    );
  }

  Widget _buildSucursalCard(Sucursal sucursal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToEditSucursal(sucursal),
        borderRadius: BorderRadius.circular(16),
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
                      gradient: sucursal.isActive
                          ? AppTheme.primaryGradient
                          : LinearGradient(
                              colors: [
                                AppTheme.textSecondaryColor.withOpacity(0.3),
                                AppTheme.textSecondaryColor.withOpacity(0.2),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                sucursal.nombreSucursal,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: sucursal.isActive
                                    ? AppTheme.successColor.withOpacity(0.1)
                                    : AppTheme.errorColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                sucursal.isActive ? 'Activa' : 'Inactiva',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: sucursal.isActive
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                sucursal.direccionCorta,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (sucursal.telefono != null &&
                      sucursal.telefono!.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              sucursal.telefono!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToEditSucursal(sucursal),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (sucursal.isActive)
                    TextButton.icon(
                      onPressed: () => _deleteSucursal(sucursal),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Eliminar'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                      ),
                    )
                  else
                    TextButton.icon(
                      onPressed: () => _reactivateSucursal(sucursal),
                      icon: const Icon(Icons.restore, size: 18),
                      label: const Text('Reactivar'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.successColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
