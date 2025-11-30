import 'package:flutter/material.dart';
import 'package:servicios_app/core/services/admin_service.dart';

class AdminCompaniesScreen extends StatefulWidget {
  const AdminCompaniesScreen({super.key});

  @override
  State<AdminCompaniesScreen> createState() => _AdminCompaniesScreenState();
}

class _AdminCompaniesScreenState extends State<AdminCompaniesScreen> {
  final AdminService _adminService = AdminService();
  late Future<List<dynamic>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _companiesFuture = _adminService.getAllCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _companiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No companies found'));
        }

        final companies = snapshot.data!;
        return ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) {
            final company = companies[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: company['logo_url'] != null
                    ? NetworkImage(company['logo_url'])
                    : null,
                child: company['logo_url'] == null
                    ? const Icon(Icons.business)
                    : null,
              ),
              title: Text(company['nombre_empresa'] ?? company['razon_social'] ?? 'Unknown'),
              subtitle: Text(company['email'] ?? ''),
              trailing: Text(company['estado'] ?? 'Unknown'),
            );
          },
        );
      },
    );
  }
}
