import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/models/contratacion.dart';
import 'package:servicios_app/core/providers/contratacion_provider.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/config/theme.dart';

class EmpresaOrdersScreen extends StatefulWidget {
  const EmpresaOrdersScreen({super.key});

  @override
  State<EmpresaOrdersScreen> createState() => _EmpresaOrdersScreenState();
}

class _EmpresaOrdersScreenState extends State<EmpresaOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  void _handleTabSelection() {
    if (_tabController.index == 5) {
      // Historial tab
      Provider.of<ContratacionProvider>(context, listen: false)
          .loadHistorialEmpresa(refresh: true);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    await Provider.of<ContratacionProvider>(context, listen: false)
        .loadContratacionesEmpresa(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Órdenes'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Pendientes'),
            Tab(text: 'Activas'),
            Tab(text: 'En Proceso'),
            Tab(text: 'Completadas'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: Consumer<ContratacionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allOrders = provider.contrataciones;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrdersList(allOrders),
              _buildOrdersList(allOrders
                  .where((c) => c.estado == 'pendiente')
                  .toList()),
              _buildOrdersList(allOrders
                  .where((c) => c.estado == 'confirmado')
                  .toList()),
              _buildOrdersList(allOrders
                  .where((c) => c.estado == 'en_proceso')
                  .toList()),
              _buildOrdersList(allOrders
                  .where((c) => c.estado == 'completado')
                  .toList()),
              _buildHistoryList(provider.historial),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<Contratacion> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay órdenes en esta categoría'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _EmpresaOrderItem(contratacion: orders[index]);
        },
      ),
    );
  }

  Widget _buildHistoryList(List<HistorialContratacion> historial) {
    if (historial.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay historial de cambios'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => Provider.of<ContratacionProvider>(context, listen: false)
          .loadHistorialEmpresa(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historial.length,
        itemBuilder: (context, index) {
          final item = historial[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(_getStatusIcon(item.estadoNuevo),
                    color: _getStatusColor(item.estadoNuevo)),
              ),
              title: Text('Orden #${item.idContratacion}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${item.estadoAnterior ?? 'Inicio'} ➔ ${item.estadoNuevo}'),
                  if (item.notas != null && item.notas!.isNotEmpty)
                    Text('Nota: ${item.notas}',
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(item.fechaCambio),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pendiente':
        return Icons.access_time;
      case 'confirmado':
        return Icons.check_circle_outline;
      case 'en_proceso':
        return Icons.run_circle_outlined;
      case 'completado':
        return Icons.check_circle;
      case 'cancelado':
      case 'rechazado':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmado':
        return Colors.blue;
      case 'en_proceso':
        return Colors.purple;
      case 'completado':
        return Colors.green;
      case 'cancelado':
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _EmpresaOrderItem extends StatelessWidget {
  final Contratacion contratacion;

  const _EmpresaOrderItem({required this.contratacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                      'Orden #${contratacion.id}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                    ),
                  ),
                  _buildStatusChip(context, contratacion.estado),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      image: contratacion.servicioImagen != null
                          ? DecorationImage(
                              image: NetworkImage(contratacion.servicioImagen!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: contratacion.servicioImagen == null
                        ? const Icon(Icons.image, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contratacion.servicioNombre ?? 'Servicio',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              contratacion.clienteNombre ?? 'Cliente',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm')
                              .format(contratacion.fechaContratacion),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
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
                    'Total',
                    style: Theme.of(context).textTheme.bodyMedium,
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

