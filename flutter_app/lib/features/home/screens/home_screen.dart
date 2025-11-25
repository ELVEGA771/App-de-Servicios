import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'package:servicios_app/core/providers/notificacion_provider.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/features/empresa/screens/empresa_dashboard_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // CAMBIO AQUÍ: Usar addPostFrameCallback
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          authProvider.isEmpresa ? 'Dashboard' : 'Explorar Servicios',
        ),
        actions: [
          // Notificaciones
          Consumer<NotificacionProvider>(
            builder: (context, notifProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.notificaciones);
                    },
                  ),
                  if (notifProvider.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          notifProvider.unreadCount > 9
                              ? '9+'
                              : '${notifProvider.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: authProvider.isEmpresa
            ? _buildEmpresaNavItems()
            : _buildClienteNavItems(),
      ),
    );
  }

  Widget _buildBody() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isEmpresa) {
      return _buildEmpresaView();
    } else {
      return _buildClienteView();
    }
  }

  Widget _buildClienteView() {
    switch (_selectedIndex) {
      case 0:
        return _buildExploreTab();
      case 1:
        return _buildOrdersTab();
      case 2:
        return _buildFavoritesTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildExploreTab();
    }
  }

  Widget _buildEmpresaView() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildServicesTab();
      case 2:
        return _buildOrdersTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildDashboardTab();
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
                    Navigator.of(context).pushNamed(AppRoutes.servicioSearch);
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
                          servicioProvider.setFilters(
                              categoriaId: categoria.id);
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
                                AppRoutes.navigateToServicioDetail(
                                  context,
                                  servicio.id,
                                );
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

  Widget _buildOrdersTab() {
    return const Center(child: Text('Órdenes - Implementar'));
  }

  Widget _buildFavoritesTab() {
    return const Center(child: Text('Favoritos - Implementar'));
  }

  Widget _buildDashboardTab() {
    return const EmpresaDashboardScreen();
  }

  Widget _buildServicesTab() {
    return const EmpresaServicesScreen();
  }

  Widget _buildProfileTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          authProvider.logout();
          AppRoutes.navigateToLogin(context);
        },
        child: const Text('Cerrar Sesión'),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildClienteNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.explore_outlined),
        activeIcon: Icon(Icons.explore),
        label: 'Explorar',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_outlined),
        activeIcon: Icon(Icons.receipt),
        label: 'Órdenes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        activeIcon: Icon(Icons.favorite),
        label: 'Favoritos',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];
  }

  List<BottomNavigationBarItem> _buildEmpresaNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business_center_outlined),
        activeIcon: Icon(Icons.business_center),
        label: 'Servicios',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment_outlined),
        activeIcon: Icon(Icons.assignment),
        label: 'Órdenes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];
  }
}
