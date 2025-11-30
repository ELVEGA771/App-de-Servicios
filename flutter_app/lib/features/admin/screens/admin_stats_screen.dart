import 'package:flutter/material.dart';
import 'package:servicios_app/core/services/admin_service.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  final AdminService _adminService = AdminService();
  late Future<List<dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _adminService.getVistaEstadisticasEmpresa();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No statistics available'));
        }

        final stats = snapshot.data!;
        return ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(stat['nombre_empresa'] ?? 'Unknown Company'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Services: ${stat['total_servicios']}'),
                    Text('Active Services: ${stat['servicios_activos']}'),
                    Text('Total Hires: ${stat['total_contrataciones']}'),
                    Text('Total Earnings: \$${stat['total_ganancias'] ?? 0}'),
                  ],
                ),
                trailing: Text('Rating: ${stat['calificacion_promedio'] ?? 'N/A'}'),
              ),
            );
          },
        );
      },
    );
  }
}
