import 'package:flutter/material.dart';
import 'package:servicios_app/core/services/admin_service.dart';
import 'package:servicios_app/features/admin/screens/admin_view_detail_screen.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  final AdminService _adminService = AdminService();

  void _navigateToView(String title, Future<List<dynamic>> future) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminViewDetailScreen(
          title: title,
          futureData: future,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Revenue Card
            FutureBuilder<double>(
              future: _adminService.getIngresosPlataforma(),
              builder: (context, snapshot) {
                final total = snapshot.data ?? 0.0;
                return Card(
                  elevation: 4,
                  color: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ingresos Totales Plataforma',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    '\$${total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Grid of Stats
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    'Contrataciones Detalle',
                    Icons.assignment,
                    Colors.blue,
                    () => _navigateToView('Contrataciones',
                        _adminService.getVistaContrataciones()),
                  ),
                  _buildStatCard(
                    'Estadísticas Empresas',
                    Icons.business,
                    Colors.green,
                    () => _navigateToView('Estadísticas Empresas',
                        _adminService.getVistaEstadisticasEmpresa()),
                  ),
                  _buildStatCard(
                    'Servicios Completos',
                    Icons.cleaning_services,
                    Colors.orange,
                    () => _navigateToView(
                        'Servicios', _adminService.getVistaServicios()),
                  ),
                  _buildStatCard(
                    'Sucursales y Direcciones',
                    Icons.store,
                    Colors.purple,
                    () => _navigateToView(
                        'Sucursales', _adminService.getVistaSucursales()),
                  ),
                  _buildStatCard(
                    'Top Clientes',
                    Icons.people,
                    Colors.red,
                    () => _navigateToView(
                        'Top Clientes', _adminService.getVistaTopClientes()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
