import 'package:flutter/material.dart';

class EmpresaOrdersScreen extends StatelessWidget {
  const EmpresaOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Órdenes Recibidas')),
      body: const Center(child: Text('Órdenes de Clientes')),
    );
  }
}
