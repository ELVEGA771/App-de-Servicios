import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/notificacion_provider.dart';
import 'package:servicios_app/features/empresa/widgets/empresa_layout.dart';

class EmpresaDashboardScreen extends StatefulWidget {
  const EmpresaDashboardScreen({super.key});

  @override
  State<EmpresaDashboardScreen> createState() => _EmpresaDashboardScreenState();
}

class _EmpresaDashboardScreenState extends State<EmpresaDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final notificacionProvider =
        Provider.of<NotificacionProvider>(context, listen: false);
    await notificacionProvider.refreshUnreadCount();
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different routes based on bottom nav selection
    switch (index) {
      case 0:
        context.go('/empresa/home');
        break;
      case 1:
        // Navigate to services screen when created
        // context.go('/empresa/servicios');
        break;
      case 2:
        // Navigate to orders screen when created
        // context.go('/empresa/contrataciones');
        break;
      case 3:
        // Navigate to profile screen when created
        // context.go('/empresa/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmpresaLayout(
      title: 'Dashboard',
      currentIndex: _selectedIndex,
      onNavigationChanged: _onNavigationChanged,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildServicesPlaceholder();
      case 2:
        return _buildOrdersPlaceholder();
      case 3:
        return _buildProfilePlaceholder();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Text(
            '¡Bienvenido!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Gestiona tu empresa desde aquí',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.business_center,
                  title: 'Servicios',
                  value: '0',
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.assignment,
                  title: 'Órdenes',
                  value: '0',
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.location_on,
                  title: 'Sucursales',
                  value: '0',
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star,
                  title: 'Calificación',
                  value: '0.0',
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Acciones Rápidas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildQuickAction(
            icon: Icons.add_business,
            title: 'Crear Servicio',
            subtitle: 'Añade un nuevo servicio a tu catálogo',
            onTap: () {
              // Navigate to create service when created
              // context.push('/empresa/servicios/crear');
            },
          ),
          const SizedBox(height: 12),
          _buildQuickAction(
            icon: Icons.location_city,
            title: 'Gestionar Sucursales',
            subtitle: 'Administra las ubicaciones de tu empresa',
            onTap: () {
              // Navigate to manage sucursales when created
              // context.push('/empresa/sucursales');
            },
          ),
          const SizedBox(height: 12),
          _buildQuickAction(
            icon: Icons.insights,
            title: 'Ver Estadísticas',
            subtitle: 'Revisa el rendimiento de tu negocio',
            onTap: () {
              // Navigate to stats when created
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente disponible')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.business_center_outlined, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'Mis Servicios',
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

  Widget _buildOrdersPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'Órdenes Recibidas',
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
            'Perfil de Empresa',
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
