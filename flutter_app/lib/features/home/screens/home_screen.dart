import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'package:servicios_app/core/providers/notificacion_provider.dart';
import 'package:servicios_app/core/providers/direccion_provider.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/features/empresa/screens/empresa_dashboard_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_services_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_orders_screen.dart';
import 'package:servicios_app/features/contratacion/screens/order_history_screen.dart';
import 'package:servicios_app/features/profile/screens/profile_screen.dart';
import 'package:servicios_app/features/profile/screens/address_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum GroupingMode { category, company }

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  GroupingMode _groupingMode = GroupingMode.category;

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
    final direccionProvider =
        Provider.of<DireccionProvider>(context, listen: false);

    await Future.wait([
      servicioProvider.loadCategorias(),
      servicioProvider.loadServicios(refresh: true),
      notificacionProvider.refreshUnreadCount(),
      direccionProvider.loadDirecciones(),
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
        return const OrderHistoryScreen();
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
        return const EmpresaOrdersScreen();
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
            // Address Selector
            SliverToBoxAdapter(
              child: Consumer<DireccionProvider>(
                builder: (context, provider, _) {
                  final direccion = provider.selectedDireccion;
                  return InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddressListScreen(selectionMode: true),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      direccion?.alias.toUpperCase() ?? 'AGREGAR DIRECCIÓN',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.textSecondaryColor),
                                  ],
                                ),
                                Text(
                                  direccion?.direccionCorta ?? 'Selecciona una ubicación de entrega',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            ),

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

            // Grouping Toggle
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Agrupar por:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 12),
                    SegmentedButton<GroupingMode>(
                      segments: const [
                        ButtonSegment<GroupingMode>(
                          value: GroupingMode.category,
                          label: Text('Categoría'),
                          icon: Icon(Icons.category_outlined),
                        ),
                        ButtonSegment<GroupingMode>(
                          value: GroupingMode.company,
                          label: Text('Empresa'),
                          icon: Icon(Icons.business_outlined),
                        ),
                      ],
                      selected: {_groupingMode},
                      onSelectionChanged: (Set<GroupingMode> newSelection) {
                        setState(() {
                          _groupingMode = newSelection.first;
                        });
                      },
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Content
            if (servicioProvider.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (servicioProvider.servicios.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No hay servicios disponibles')),
              )
            else
              _buildGroupedServicesList(servicioProvider),
            
            const SliverToBoxAdapter(child: SizedBox(height: 80)), // Bottom padding
          ],
        );
      },
    );
  }

  Widget _buildGroupedServicesList(ServicioProvider provider) {
    final groupedServices = <String, List<dynamic>>{};
    
    for (var servicio in provider.servicios) {
      String key;
      if (_groupingMode == GroupingMode.category) {
        key = servicio.categoriaNombre ?? 'Sin Categoría';
      } else {
        key = servicio.empresaNombre ?? 'Sin Empresa';
      }
      
      if (!groupedServices.containsKey(key)) {
        groupedServices[key] = [];
      }
      groupedServices[key]!.add(servicio);
    }

    final sortedKeys = groupedServices.keys.toList()..sort();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final key = sortedKeys[index];
          final services = groupedServices[key]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      key,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to see all in this group
                      },
                      child: const Text('Ver todo'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280, // Fixed height for the horizontal list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: services.length,
                  itemBuilder: (context, serviceIndex) {
                    final servicio = services[serviceIndex];
                    return Container(
                      width: 200, // Fixed width for each card
                      margin: const EdgeInsets.only(right: 16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            AppRoutes.navigateToServicioDetail(
                              context,
                              servicio.id,
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    image: servicio.imagenPrincipal != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                servicio.imagenPrincipal!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: servicio.imagenPrincipal == null
                                      ? const Center(
                                          child: Icon(Icons.image,
                                              size: 48,
                                              color: Colors.grey),
                                        )
                                      : null,
                                ),
                              ),
                              // Info
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            servicio.nombre,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          if (_groupingMode ==
                                              GroupingMode.category)
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.business,
                                                    size: 14,
                                                    color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    servicio.empresaNombre ??
                                                        'Empresa',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${servicio.precio.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color:
                                                      AppTheme.primaryColor,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                          ),
                                          if (servicio.calificacionPromedio !=
                                              null)
                                            Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    size: 16,
                                                    color: Colors.amber),
                                                Text(
                                                  servicio.calificacionPromedio!
                                                      .toStringAsFixed(1),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
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
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        childCount: sortedKeys.length,
      ),
    );
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
    return const ProfileScreen();
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
