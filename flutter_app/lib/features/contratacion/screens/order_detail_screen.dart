import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Orden')),
      body: Center(child: Text('Orden ID: $orderId')),
    );
  }
}
