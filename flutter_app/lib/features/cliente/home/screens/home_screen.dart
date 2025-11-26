import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'package:servicios_app/core/providers/notificacion_provider.dart';
import 'package:servicios_app/features/cliente/widgets/cliente_layout.dart';

class ClienteHomeScreen extends StatefulWidget {
  const ClienteHomeScreen({super.key});

  @override
  State<ClienteHomeScreen> createState() => _ClienteHomeScreenState();
}

class _ClienteHomeScreenState extends State<ClienteHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final servicioProvider =
        Provider.of<ServicioProvider>(context, listen: false);
    final notificacionProvider =
        Provider.of<NotificacionProvider>(context, listen: false);

    await Future.wait([
      servicioProvider.loadCategorias(),
      servicioProvider.loadServicios(refresh: true),
      notificacionProvider.refreshUnreadCount(),
    ]);
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different routes based on bottom nav selection
    switch (index) {
      case 0:
        context.go('/cliente/home');
        break;
      case 1:
        // Navigate to orders screen when created
        // context.go('/cliente/contrataciones');
        break;
      case 2:
        // Navigate to favorites screen when created
        // context.go('/cliente/favoritos');
        break;
      case 3:
        // Navigate to profile screen when created
        // context.go('/cliente/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClienteLayout(
      title: 'Explorar Servicios',
      currentIndex: _selectedIndex,
      onNavigationChanged: _onNavigationChanged,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildExploreTab();
      case 1:
        return _buildOrdersPlaceholder();
      case 2:
        return _buildFavoritesPlaceholder();
      case 3:
        return _buildProfilePlaceholder();
      default:
        return _buildExploreTab();
    }
  }

  Widget _buildExploreTab() {
    return Consumer<ServicioProvider>(
      builder: (context, servicioProvider, child) {
        return CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to search screen when created
                    // context.push('/cliente/servicios/buscar');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 12),
                        Text(
                          'Buscar servicios...',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: servicioProvider.categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = servicioProvider.categorias[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          servicioProvider.setFilters(categoriaId: categoria.id);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.dividerColor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.category, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                categoria.nombre,
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Servicios Grid
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: servicioProvider.isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final servicio = servicioProvider.servicios[index];
                          return Card(
                            child: InkWell(
                              onTap: () {
                                // Navigate to service detail when created
                                // context.push('/cliente/servicios/${servicio.id}');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.backgroundColor,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.image, size: 48),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          servicio.nombre,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${servicio.precio.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: servicioProvider.servicios.length,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_outlined, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'Mis Órdenes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta sección se implementará próximamente',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_outline, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'Mis Favoritos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta sección se implementará próximamente',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'Mi Perfil',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta sección se implementará próximamente',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
