import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/direccion.dart';
import 'package:servicios_app/core/providers/direccion_provider.dart';
import 'package:servicios_app/features/profile/screens/add_edit_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  final bool selectionMode;

  const AddressListScreen({super.key, this.selectionMode = false});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DireccionProvider>(context, listen: false).loadDirecciones();
    });
  }

  void _navigateToAddEditAddress(BuildContext context, {Direccion? direccion}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(direccion: direccion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectionMode ? 'Seleccionar Dirección' : 'Mis Direcciones'),
      ),
      body: Consumer<DireccionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.direcciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No tienes direcciones guardadas'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _navigateToAddEditAddress(context),
                    child: const Text('Agregar Dirección'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.direcciones.length,
            itemBuilder: (context, index) {
              final direccion = provider.direcciones[index];
              final isSelected = widget.selectionMode && 
                  provider.selectedDireccion?.id == direccion.id;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected 
                      ? const BorderSide(color: AppTheme.primaryColor, width: 2)
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () {
                    if (widget.selectionMode) {
                      provider.selectDireccion(direccion);
                      Navigator.of(context).pop(direccion);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          direccion.alias.toLowerCase().contains('casa') 
                              ? Icons.home 
                              : direccion.alias.toLowerCase().contains('trabajo') 
                                  ? Icons.work 
                                  : Icons.location_on,
                          color: isSelected ? AppTheme.primaryColor : Colors.grey,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    direccion.alias,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (direccion.esPrincipal)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Principal',
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                direccion.direccionCompleta,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (!widget.selectionMode)
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToAddEditAddress(context, direccion: direccion);
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Eliminar dirección'),
                                    content: const Text('¿Estás seguro de eliminar esta dirección?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          provider.deleteDireccion(direccion.id);
                                        },
                                        child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (value == 'principal') {
                                provider.setPrincipal(direccion.id);
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
                              if (!direccion.esPrincipal)
                                const PopupMenuItem(
                                  value: 'principal',
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, size: 20),
                                      SizedBox(width: 8),
                                      Text('Marcar como principal'),
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
                        if (widget.selectionMode && isSelected)
                          const Icon(Icons.check_circle, color: AppTheme.primaryColor),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditAddress(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
