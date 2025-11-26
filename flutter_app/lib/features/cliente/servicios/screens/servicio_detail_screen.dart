import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/providers/favorito_provider.dart';

class ServicioDetailScreen extends StatefulWidget {
  final int servicioId;

  const ServicioDetailScreen({super.key, required this.servicioId});

  @override
  State<ServicioDetailScreen> createState() => _ServicioDetailScreenState();
}

class _ServicioDetailScreenState extends State<ServicioDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServicioProvider>(context, listen: false)
          .loadServicioDetails(widget.servicioId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ServicioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final servicio = provider.selectedServicio;

          if (servicio == null) {
            return const Center(child: Text('No se pudo cargar el servicio'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: servicio.imagenPrincipal != null
                      ? Image.network(
                          AppConstants.fixImageUrl(servicio.imagenPrincipal!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image,
                              size: 100, color: Colors.grey),
                        ),
                ),
                actions: [
                  Consumer<FavoritoProvider>(
                    builder: (context, favProvider, _) {
                      final isFav = favProvider.isFavorito(servicio.id);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          favProvider.toggleFavorito(servicio.id);
                        },
                      );
                    },
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              servicio.nombre,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '\$${servicio.precio.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.1),
                          backgroundImage: servicio.empresaLogo != null
                              ? NetworkImage(servicio.empresaLogo!)
                              : null,
                          child: servicio.empresaLogo == null
                              ? const Icon(Icons.business,
                                  color: AppTheme.primaryColor)
                              : null,
                        ),
                        title: Text(servicio.empresaNombre ?? 'Empresa'),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(servicio.calificacionPromedio
                                    ?.toStringAsFixed(1) ??
                                'N/A'),
                            const SizedBox(width: 12),
                            Text(
                                '${servicio.totalContrataciones ?? 0} Contrataciones'),
                          ],
                        ),
                      ),
                      const Divider(),

                      const Text(
                        'Descripción',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        servicio.descripcion,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),

                      if (servicio.duracionEstimada != null)
                        _buildDetailRow(Icons.timer, 'Duración estimada',
                            '${servicio.duracionEstimada} horas'),

                      if (servicio.categoriaNombre != null)
                        _buildDetailRow(Icons.category, 'Categoría',
                            servicio.categoriaNombre!),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isEmpresa) {
                return ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to edit service
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Mi Servicio'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              }

              return ElevatedButton(
                onPressed: () {
                  final servicio =
                      Provider.of<ServicioProvider>(context, listen: false)
                          .selectedServicio;

                  if (servicio == null) return;

                  int sucursalId = 1;

                  if (servicio.sucursalesDisponibles != null &&
                      servicio.sucursalesDisponibles!.isNotEmpty) {
                    sucursalId =
                        servicio.sucursalesDisponibles![0]['id_sucursal'];
                  }

                  context.push('/cliente/checkout/${widget.servicioId}/$sucursalId');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text(
                  'Contratar Ahora',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
