import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/favorito_provider.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: Consumer<FavoritoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.favoritos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes favoritos aún',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      AppRoutes.navigateToHome(context);
                    },
                    child: const Text('Explorar Servicios'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.favoritos.length,
            itemBuilder: (context, index) {
              final favorito = provider.favoritos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    AppRoutes.navigateToServicioDetail(
                      context,
                      favorito.idServicio,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      // Imagen
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                          image: favorito.servicioImagen != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                      AppConstants.fixImageUrl(favorito.servicioImagen!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: favorito.servicioImagen == null
                            ? const Icon(Icons.image, color: Colors.grey)
                            : null,
                      ),
                      // Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favorito.servicioNombre ?? 'Servicio',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                favorito.empresaNombre ?? 'Empresa',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${favorito.servicioPrecio?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite,
                                        color: Colors.red),
                                    onPressed: () {
                                      provider.removeFavorito(
                                          favorito.idServicio);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
