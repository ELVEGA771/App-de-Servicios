import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final int servicioId;
  final int sucursalId;

  const CheckoutScreen({
    super.key,
    required this.servicioId,
    required this.sucursalId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Proceso de Contratación')),
    );
  }
}
