import 'package:flutter/material.dart';
import 'package:servicios_app/core/services/admin_service.dart';
import 'package:servicios_app/core/models/usuario.dart'; // Assuming we map client to user or similar

class AdminClientsScreen extends StatefulWidget {
  const AdminClientsScreen({super.key});

  @override
  State<AdminClientsScreen> createState() => _AdminClientsScreenState();
}

class _AdminClientsScreenState extends State<AdminClientsScreen> {
  final AdminService _adminService = AdminService();
  late Future<List<dynamic>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientsFuture = _adminService.getAllClients();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _clientsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No clients found'));
        }

        final clients = snapshot.data!;
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: client['foto_perfil_url'] != null
                    ? NetworkImage(client['foto_perfil_url'])
                    : null,
                child: client['foto_perfil_url'] == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text('${client['nombre']} ${client['apellido']}'),
              subtitle: Text(client['email']),
              trailing: Text(client['estado'] ?? 'Unknown'),
            );
          },
        );
      },
    );
  }
}
