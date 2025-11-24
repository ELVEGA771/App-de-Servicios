import 'package:flutter/material.dart';

class ServicioListScreen extends StatelessWidget {
  final int? categoriaId;
  final String? ciudad;
  final String? titulo;

  const ServicioListScreen({
    super.key,
    this.categoriaId,
    this.ciudad,
    this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo ?? 'Servicios')),
      body: const Center(child: Text('Lista de Servicios')),
    );
  }
}
