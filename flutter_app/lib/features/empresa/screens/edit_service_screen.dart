import 'package:flutter/material.dart';

class EditServiceScreen extends StatelessWidget {
  final int servicioId;

  const EditServiceScreen({super.key, required this.servicioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Servicio')),
      body: Center(child: Text('Editar Servicio ID: $servicioId')),
    );
  }
}
