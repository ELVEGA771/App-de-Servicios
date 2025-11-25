import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';

class ServicioListScreen extends StatefulWidget {
  final int? categoriaId;
  final String? ciudad;
  final String? titulo;

  const ServicioListScreen({
    super.key,
    this.categoriaId,
    this.ciudad,
    this.titulo,
  });

  @override
  State<ServicioListScreen> createState() => _ServicioListScreenState();
}

class _ServicioListScreenState extends State<ServicioListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar datos después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ServicioProvider>(context, listen: false);

      // Aplicar filtros iniciales y cargar
      provider.setFilters(
        categoriaId: widget.categoriaId,
        ciudad: widget.ciudad,
      );
    });

    // Configurar scroll infinito
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        Provider.of<ServicioProvider>(context, listen: false)
            .loadMoreServicios();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo ?? 'Servicios'),
      ),
      body: Consumer<ServicioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.servicios.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.servicios.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppTheme.errorColor),
                  const SizedBox(height: 16),
                  Text(provider.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadServicios(refresh: true),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.servicios.isEmpty) {
            return const Center(
              child: Text('No se encontraron servicios con estos criterios'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadServicios(refresh: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  provider.servicios.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.servicios.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final servicio = provider.servicios[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      AppRoutes.navigateToServicioDetail(context, servicio.id);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del servicio
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            image: servicio.imagenPrincipal != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        AppConstants.fixImageUrl(
                                            servicio.imagenPrincipal!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: servicio.imagenPrincipal == null
                              ? const Center(
                                  child: Icon(Icons.image,
                                      size: 50, color: Colors.grey),
                                )
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      servicio.nombre,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '\$${servicio.precio.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (servicio.empresaNombre != null)
                                Text(
                                  servicio.empresaNombre!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    servicio.calificacionPromedio
                                            ?.toStringAsFixed(1) ??
                                        'N/A',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Text(
                                    servicio.duracionEstimada != null
                                        ? '${servicio.duracionEstimada}h'
                                        : '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
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
        },
      ),
    );
  }
}
