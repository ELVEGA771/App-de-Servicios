import 'package:flutter/material.dart';

class ServicioSearchScreen extends StatelessWidget {
  const ServicioSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Servicios')),
      body: const Center(child: Text('Búsqueda de Servicios')),
    );
  }
}
