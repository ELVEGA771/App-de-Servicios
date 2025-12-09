import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 24),
            
            const Text(
              'Análisis Gráfico',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Charts Section
            _buildCompanyChart(),
            const SizedBox(height: 24),
            _buildClientChart(),
            
            const SizedBox(height: 24),
            const Text(
              'Accesos Directos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Grid of Stats
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyChart() {
    return FutureBuilder<List<dynamic>>(
      future: _adminService.getVistaEstadisticasEmpresa(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        // Process data: Top 5 companies by revenue
        final data = List<Map<String, dynamic>>.from(snapshot.data!);
        data.sort((a, b) {
          final revA = double.tryParse(a['ingresos_totales'].toString()) ?? 0;
          final revB = double.tryParse(b['ingresos_totales'].toString()) ?? 0;
          return revB.compareTo(revA);
        });
        final topCompanies = data.take(5).toList();

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Empresas por Ingresos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (double.tryParse(topCompanies.first['ingresos_totales'].toString()) ?? 100) * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${topCompanies[group.x.toInt()]['razon_social']}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\$${rod.toY.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() >= topCompanies.length) return const Text('');
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  topCompanies[value.toInt()]['razon_social'].toString().substring(0, 3),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: topCompanies.asMap().entries.map((entry) {
                        final index = entry.key;
                        final company = entry.value;
                        final revenue = double.tryParse(company['ingresos_totales'].toString()) ?? 0;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: revenue,
                              color: Colors.blue,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientChart() {
    return FutureBuilder<List<dynamic>>(
      future: _adminService.getVistaTopClientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        // Process data: Top 5 clients by spending
        final data = List<Map<String, dynamic>>.from(snapshot.data!);
        // Already sorted by SQL view, but let's be safe
        data.sort((a, b) {
          final spendA = double.tryParse(a['total_gastado'].toString()) ?? 0;
          final spendB = double.tryParse(b['total_gastado'].toString()) ?? 0;
          return spendB.compareTo(spendA);
        });
        final topClients = data.take(5).toList();

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Clientes por Gasto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (double.tryParse(topClients.first['total_gastado'].toString()) ?? 100) * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${topClients[group.x.toInt()]['nombre_completo']}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\$${rod.toY.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() >= topClients.length) return const Text('');
                              final name = topClients[value.toInt()]['nombre_completo'].toString();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  name.length > 3 ? name.substring(0, 3) : name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: topClients.asMap().entries.map((entry) {
                        final index = entry.key;
                        final client = entry.value;
                        final spending = double.tryParse(client['total_gastado'].toString()) ?? 0;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: spending,
                              color: Colors.redAccent,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
