import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/models/contratacion.dart';
import 'package:servicios_app/core/providers/contratacion_provider.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/config/theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<void> _fetchContratacionesFuture;

  @override
  void initState() {
    super.initState();
    _fetchContratacionesFuture = _fetchContrataciones();
  }

  Future<void> _fetchContrataciones() {
    return Provider.of<ContratacionProvider>(context, listen: false)
        .loadContratacionesCliente(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Contrataciones'),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: [
              Tab(text: 'Todos'),
              Tab(text: 'Pendientes'),
              Tab(text: 'En Proceso'),
              Tab(text: 'Completados'),
              Tab(text: 'Cancelados'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _fetchContratacionesFuture = _fetchContrataciones();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _fetchContratacionesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error al cargar las contrataciones: ${snapshot.error}'),
              );
            } else {
              return Consumer<ContratacionProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final allOrders = provider.contrataciones;

                  return TabBarView(
                    children: [
                      _buildOrderList(allOrders),
                      _buildOrderList(allOrders
                          .where((c) => c.estado == 'pendiente')
                          .toList()),
                      _buildOrderList(allOrders
                          .where((c) => ['confirmado', 'en_proceso']
                              .contains(c.estado))
                          .toList()),
                      _buildOrderList(allOrders
                          .where((c) => c.estado == 'completado')
                          .toList()),
                      _buildOrderList(allOrders
                          .where((c) => ['cancelado', 'rechazado']
                              .contains(c.estado))
                          .toList()),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Contratacion> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay órdenes en esta categoría',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchContrataciones,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final contratacion = orders[index];
          return _OrderHistoryItem(contratacion: contratacion);
        },
      ),
    );
  }
}

class _OrderHistoryItem extends StatelessWidget {
  final Contratacion contratacion;

  const _OrderHistoryItem({required this.contratacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          AppRoutes.navigateToOrderDetail(context, contratacion.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      contratacion.servicioNombre ?? 'Servicio',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(context, contratacion.estado),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    contratacion.empresaNombre ?? 'Empresa',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy')
                        .format(contratacion.fechaContratacion),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '\$${contratacion.precioFinal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    String label;

    switch (status) {
      case 'pendiente':
        color = Colors.orange;
        label = 'Pendiente';
        break;
      case 'confirmado':
        color = Colors.blue;
        label = 'Confirmado';
        break;
      case 'en_proceso':
        color = Colors.purple;
        label = 'En Proceso';
        break;
      case 'completado':
        color = Colors.green;
        label = 'Completado';
        break;
      case 'cancelado':
        color = Colors.red;
        label = 'Cancelado';
        break;
      case 'rechazado':
        color = Colors.red;
        label = 'Rechazado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
