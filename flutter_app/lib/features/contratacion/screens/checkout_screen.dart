import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/config/constants.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/core/models/direccion.dart';
import 'package:servicios_app/core/models/servicio.dart';
import 'package:servicios_app/core/providers/contratacion_provider.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'package:servicios_app/core/providers/direccion_provider.dart';
import 'package:servicios_app/features/profile/screens/address_list_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final int servicioId;
  final int sucursalId;

  const CheckoutScreen({
    super.key,
    required this.servicioId,
    required this.sucursalId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _notasController = TextEditingController();

  // Estado
  bool _isLoading = true;
  Direccion? _selectedDireccion;
  DateTime? _fechaProgramada;
  Servicio? _servicio;
  String _selectedPaymentMethod = 'efectivo';

  List<Map<String, dynamic>> get _paymentMethods => [
    {'id': 'efectivo', 'name': 'Efectivo', 'icon': Icons.money},
    {'id': 'tarjeta_credito', 'name': 'Tarjeta de Crédito', 'icon': Icons.credit_card},
    {'id': 'tarjeta_debito', 'name': 'Tarjeta de Débito', 'icon': Icons.credit_card},
    {'id': 'transferencia', 'name': 'Transferencia', 'icon': Icons.account_balance},
    {'id': 'paypal', 'name': 'PayPal', 'icon': Icons.payment},
    {'id': 'otro', 'name': 'Otro', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 1. Cargar detalles del servicio si no están en el provider
      final servicioProvider =
          Provider.of<ServicioProvider>(context, listen: false);
      if (servicioProvider.selectedServicio?.id == widget.servicioId) {
        _servicio = servicioProvider.selectedServicio;
      } else {
        await servicioProvider.loadServicioDetails(widget.servicioId);
        _servicio = servicioProvider.selectedServicio;
      }

      // 2. Cargar direcciones via Provider
      final direccionProvider = Provider.of<DireccionProvider>(context, listen: false);
      if (direccionProvider.direcciones.isEmpty) {
        await direccionProvider.loadDirecciones();
      }
      
      if (mounted) {
        setState(() {
          _selectedDireccion = direccionProvider.selectedDireccion;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al cargar datos: $e'),
              backgroundColor: AppTheme.errorColor),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _fechaProgramada) {
      setState(() {
        _fechaProgramada = picked;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_selectedDireccion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor selecciona una dirección de entrega')),
      );
      return;
    }

    final provider = Provider.of<ContratacionProvider>(context, listen: false);

    // Llamada al backend POST /api/contrataciones
    final result = await provider.createContratacion(
      servicioId: widget.servicioId,
      sucursalId: widget.sucursalId,
      direccionId: _selectedDireccion!.id,
      fechaProgramada: _fechaProgramada,
      notas: _notasController.text.isEmpty ? null : _notasController.text,
      metodoPago: _selectedPaymentMethod,
    );

    if (mounted) {
      if (result != null) {
        // Éxito
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Icon(Icons.check_circle,
                color: AppTheme.successColor, size: 50),
            content: const Text('¡Tu solicitud ha sido enviada exitosamente!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Cerrar diálogo
                  // Ir al historial o detalle
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.orderHistory);
                },
                child: const Text('Ver mis Órdenes'),
              )
            ],
          ),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Error al crear la contratación'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_servicio == null) {
      return const Scaffold(
          body: Center(child: Text('Error al cargar servicio')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Contratación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del Servicio
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: _servicio!.imagenPrincipal != null
                            ? DecorationImage(
                                image: NetworkImage(AppConstants.fixImageUrl(
                                    _servicio!.imagenPrincipal!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _servicio!.imagenPrincipal == null
                          ? const Icon(Icons.home_repair_service)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_servicio!.nombre,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(_servicio!.empresaNombre ?? 'Empresa',
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('\$${_servicio!.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Selección de Dirección
            const Text('Dirección de Entrega',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final selected = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddressListScreen(selectionMode: true),
                  ),
                );
                if (selected != null && selected is Direccion) {
                  setState(() {
                    _selectedDireccion = selected;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _selectedDireccion == null
                          ? const Text('Seleccionar dirección de entrega',
                              style: TextStyle(color: Colors.grey))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedDireccion!.alias,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _selectedDireccion!.direccionCorta,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Fecha Programada
            const Text('Fecha del Servicio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _fechaProgramada == null
                      ? 'Seleccionar fecha (Opcional)'
                      : DateFormat('dd/MM/yyyy').format(_fechaProgramada!),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Método de Pago
            const Text('Método de Pago',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _paymentMethods.map((method) {
                  final isSelected = _selectedPaymentMethod == method['id'];
                  return RadioListTile<String>(
                    value: method['id'],
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedPaymentMethod = value);
                      }
                    },
                    title: Row(
                      children: [
                        Icon(method['icon'],
                            color: isSelected ? AppTheme.primaryColor : Colors.grey),
                        const SizedBox(width: 12),
                        Text(method['name']),
                      ],
                    ),
                    activeColor: AppTheme.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Notas
            const Text('Notas Adicionales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _notasController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Instrucciones especiales para el proveedor...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // Botón de Acción (Consumer para loading state)
            Consumer<ContratacionProvider>(
              builder: (context, provider, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        provider.isLoading || _isLoading ? null : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'CONFIRMAR PEDIDO',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
