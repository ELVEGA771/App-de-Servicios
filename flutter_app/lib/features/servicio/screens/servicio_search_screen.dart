import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'dart:async';

class ServicioSearchScreen extends StatefulWidget {
  const ServicioSearchScreen({super.key});

  @override
  State<ServicioSearchScreen> createState() => _ServicioSearchScreenState();
}

class _ServicioSearchScreenState extends State<ServicioSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        Provider.of<ServicioProvider>(context, listen: false)
            .searchServicios(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar servicios...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              Provider.of<ServicioProvider>(context, listen: false)
                  .clearFilters();
            },
          ),
        ],
      ),
      body: Consumer<ServicioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_searchController.text.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Escribe para buscar servicios'),
                ],
              ),
            );
          }

          if (provider.servicios.isEmpty) {
            return const Center(child: Text('No se encontraron resultados'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.servicios.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final servicio = provider.servicios[index];
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: servicio.imagenPrincipal != null
                        ? DecorationImage(
                            image: NetworkImage(AppConstants.fixImageUrl(
                                servicio.imagenPrincipal!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[200],
                  ),
                  child: servicio.imagenPrincipal == null
                      ? const Icon(Icons.image, size: 20)
                      : null,
                ),
                title: Text(servicio.nombre),
                subtitle: Text(servicio.empresaNombre ?? ''),
                trailing: Text('\$${servicio.precio}'),
                onTap: () {
                  AppRoutes.navigateToServicioDetail(context, servicio.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
