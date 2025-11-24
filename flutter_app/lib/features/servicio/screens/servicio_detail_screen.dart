import 'package:flutter/material.dart';

class ServicioDetailScreen extends StatelessWidget {
  final int servicioId;

  const ServicioDetailScreen({super.key, required this.servicioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Servicio')),
      body: Center(child: Text('Servicio ID: $servicioId')),
    );
  }
}
