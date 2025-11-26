import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/models/contratacion.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/providers/contratacion_provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isLoadingAction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContratacionProvider>(context, listen: false)
          .loadContratacionDetails(widget.orderId);
    });
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoadingAction = true);
    try {
      final success = await Provider.of<ContratacionProvider>(context,
              listen: false)
          .updateEstado(id: widget.orderId, nuevoEstado: newStatus);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Orden actualizada a $newStatus')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  Future<void> _cancelOrder() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Orden'),
        content: const Text(
            '¿Estás seguro de que deseas cancelar esta orden? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoadingAction = true);
    try {
      final success =
          await Provider.of<ContratacionProvider>(context, listen: false)
              .cancelContratacion(id: widget.orderId, motivo: 'Cancelado por el usuario');

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden cancelada exitosamente')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmpresa = Provider.of<AuthProvider>(context).isEmpresa;

    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${widget.orderId}'),
      ),
      body: Consumer<ContratacionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.selectedContratacion == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = provider.selectedContratacion;

          if (order == null) {
            return const Center(child: Text('No se encontró la orden'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(order),
                const SizedBox(height: 24),
                _buildServiceInfo(order),
                const SizedBox(height: 24),
                _buildPaymentInfo(order),
                const SizedBox(height: 24),
                if (order.notas != null && order.notas!.isNotEmpty) ...[
                  _buildNotes(order),
                  const SizedBox(height: 24),
                ],
                _buildActions(order, isEmpresa),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Contratacion order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildStatusChip(order.estado),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha Programada',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  order.fechaProgramada != null
                      ? DateFormat('dd MMM yyyy, HH:mm')
                          .format(order.fechaProgramada!)
                      : 'Por definir',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo(Contratacion order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalles del Servicio',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    image: order.servicioImagen != null
                        ? DecorationImage(
                            image: NetworkImage(order.servicioImagen!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: order.servicioImagen == null
                      ? const Icon(Icons.image, size: 40, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.servicioNombre ?? 'Servicio',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.empresaNombre ?? 'Empresa',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${order.precioBase.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(Contratacion order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información de Pago',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPaymentRow('Subtotal', order.precioBase),
                if (order.descuento != null && order.descuento! > 0)
                  _buildPaymentRow('Descuento', -order.descuento!,
                      isDiscount: true),
                const Divider(),
                _buildPaymentRow('Total', order.precioFinal, isTotal: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.payment, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Método de pago: ${order.metodoPago?.toUpperCase() ?? 'NO ESPECIFICADO'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, double amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : null,
          ),
          Text(
            '${isDiscount ? "-" : ""}\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? AppTheme.primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(Contratacion order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notas Adicionales',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(order.notas!),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(Contratacion order, bool isEmpresa) {
    if (_isLoadingAction) {
      return const Center(child: CircularProgressIndicator());
    }

    // Client Actions
    if (!isEmpresa) {
      if (order.estado == 'pendiente') {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _cancelOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cancelar Orden'),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    // Company Actions
    List<Widget> actions = [];

    if (order.estado == 'pendiente') {
      actions = [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _updateStatus('rechazado'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Rechazar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _updateStatus('confirmado'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Aceptar'),
          ),
        ),
      ];
    } else if (order.estado == 'confirmado') {
      actions = [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _updateStatus('en_proceso'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Iniciar Servicio'),
          ),
        ),
      ];
    } else if (order.estado == 'en_proceso') {
      actions = [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _updateStatus('completado'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Marcar como Completado'),
          ),
        ),
      ];
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(children: actions);
  }

  Widget _buildStatusChip(String status) {
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

    return Chip(
      label: Text(
        label.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }
}
