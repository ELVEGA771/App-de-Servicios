import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de Orden')),
      body: Center(child: Text('Tracking Orden ID: $orderId')),
    );
  }
}
