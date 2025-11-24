import 'package:flutter/material.dart';

class EmpresaServicesScreen extends StatelessWidget {
  const EmpresaServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Servicios')),
      body: const Center(child: Text('Gestión de Servicios')),
    );
  }
}
