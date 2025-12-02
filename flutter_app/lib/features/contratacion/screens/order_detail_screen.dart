import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/models/contratacion.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/providers/contratacion_provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/core/services/chat_service.dart';
import 'package:servicios_app/features/chat/screens/chat_screen.dart';

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

  Future<void> _openChat(Contratacion order) async {
    try {
      setState(() => _isLoadingAction = true);
      final chatService = ChatService();
      final conversation = await chatService.getOrCreateByContratacion(order.id);
      
      if (!mounted) return;
      setState(() => _isLoadingAction = false);

      final isEmpresa = Provider.of<AuthProvider>(context, listen: false).isEmpresa;
      final otherName = isEmpresa ? (order.clienteNombre ?? 'Cliente') : (order.empresaNombre ?? 'Empresa');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            conversacionId: conversation.id,
            otherUserName: otherName,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAction = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir el chat: $e')),
        );
      }
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final notes = await _showStatusUpdateDialog(newStatus);
    if (notes == null) return;

    setState(() => _isLoadingAction = true);
    try {
      final success = await Provider.of<ContratacionProvider>(context,
              listen: false)
          .updateEstado(id: widget.orderId, nuevoEstado: newStatus, notas: notes);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Orden actualizada a $newStatus')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  Future<String?> _showStatusUpdateDialog(String status) async {
    final controller = TextEditingController();
    String title = 'Actualizar Estado';
    String message = '¿Estás seguro de cambiar el estado a $status?';
    Color color = AppTheme.primaryColor;

    if (status == 'rechazado') {
      title = 'Rechazar Orden';
      message = '¿Estás seguro de rechazar esta orden? Esta acción no se puede deshacer.';
      color = Colors.red;
    } else if (status == 'confirmado') {
      title = 'Aceptar Orden';
      message = 'Al aceptar, te comprometes a realizar el servicio en la fecha programada.';
      color = Colors.green;
    }

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Notas de la empresa (Opcional)',
                hintText: 'Agrega detalles o razones...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder() async {
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Orden #${widget.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(order),
                const SizedBox(height: 20),
                _buildSectionTitle('Detalles del Servicio'),
                const SizedBox(height: 10),
                _buildServiceCard(order),
                const SizedBox(height: 20),
                if (order.isActive) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openChat(order),
                      icon: const Icon(Icons.chat),
                      label: Text(isEmpresa ? 'Chat con el Cliente' : 'Chat con la Empresa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                _buildSectionTitle('Información de Pago'),
                const SizedBox(height: 10),
                _buildPaymentCard(order),
                if (order.notas != null && order.notas!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildSectionTitle('Notas del Cliente'),
                  const SizedBox(height: 10),
                  _buildNotesCard(order.notas!),
                ],
                if (order.notasEmpresa != null && order.notasEmpresa!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildSectionTitle('Notas de la Empresa'),
                  const SizedBox(height: 10),
                  _buildNotesCard(order.notasEmpresa!, isEmpresa: true),
                ],
                const SizedBox(height: 30),
                _buildActions(order, isEmpresa),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildStatusCard(Contratacion order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estado Actual', style: TextStyle(color: Colors.grey)),
              _buildStatusChip(order.estado),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fecha Programada', style: TextStyle(color: Colors.grey)),
              Text(
                order.fechaProgramada != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(order.fechaProgramada!)
                    : 'Por definir',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Contratacion order) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              image: order.servicioImagen != null
                  ? DecorationImage(
                      image: NetworkImage(order.servicioImagen!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: order.servicioImagen == null
                ? const Icon(Icons.image_outlined, size: 32, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.servicioNombre ?? 'Servicio',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.empresaNombre ?? 'Empresa',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(order.precioBase),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Contratacion order) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPaymentRow('Subtotal', order.precioBase, currencyFormat),
          if (order.descuento != null && order.descuento! > 0)
            _buildPaymentRow('Descuento', -order.descuento!, currencyFormat, isDiscount: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildPaymentRow('Total', order.precioFinal, currencyFormat, isTotal: true),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.payment, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  'Método: ${order.metodoPago?.toUpperCase() ?? 'NO ESPECIFICADO'}',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, double amount, NumberFormat format,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            isDiscount ? "-${format.format(amount.abs())}" : format.format(amount),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? AppTheme.primaryColor : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(String notes, {bool isEmpresa = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEmpresa ? Colors.blue[50] : Colors.yellow[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmpresa ? Colors.blue.withOpacity(0.2) : Colors.yellow.withOpacity(0.2),
        ),
      ),
      child: Text(
        notes,
        style: TextStyle(
          color: isEmpresa ? Colors.blue[900] : Colors.brown[900],
          height: 1.5,
        ),
      ),
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
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancelar Orden', style: TextStyle(fontWeight: FontWeight.bold)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    Color textColor = Colors.white;
    String label;

    switch (status) {
      case 'pendiente':
        color = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        label = 'Pendiente';
        break;
      case 'confirmado':
        color = Colors.blue[100]!;
        textColor = Colors.blue[900]!;
        label = 'Confirmado';
        break;
      case 'en_proceso':
        color = Colors.purple[100]!;
        textColor = Colors.purple[900]!;
        label = 'En Proceso';
        break;
      case 'completado':
        color = Colors.green[100]!;
        textColor = Colors.green[900]!;
        label = 'Completado';
        break;
      case 'cancelado':
        color = Colors.red[100]!;
        textColor = Colors.red[900]!;
        label = 'Cancelado';
        break;
      case 'rechazado':
        color = Colors.red[100]!;
        textColor = Colors.red[900]!;
        label = 'Rechazado';
        break;
      default:
        color = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
