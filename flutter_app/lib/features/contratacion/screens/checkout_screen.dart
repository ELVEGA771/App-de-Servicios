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
// import 'package:servicios_app/core/api/dio_client.dart'; // Removed unused import
// Importar CuponService
import 'package:servicios_app/core/services/cupon_service.dart';
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
  final _cuponController = TextEditingController(); // Controlador para el cupón
  final _cuponService = CuponService(); // Instancia del servicio

  bool _isLoading = true;
  bool _isValidatingCoupon = false;
  Direccion? _selectedDireccion;
  DateTime? _fechaProgramada;
  Servicio? _servicio;

  // Variables para manejar el estado del cupón
  String? _appliedCouponCode;
  double _discountAmount = 0.0;
  double _finalPrice = 0.0;
  String? _couponMessage;
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

  @override
  void dispose() {
    _notasController.dispose();
    _cuponController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final servicioProvider =
          Provider.of<ServicioProvider>(context, listen: false);

      if (servicioProvider.selectedServicio?.id == widget.servicioId) {
        _servicio = servicioProvider.selectedServicio;
      } else {
        await servicioProvider.loadServicioDetails(widget.servicioId);
        _servicio = servicioProvider.selectedServicio;
      }

      // Inicializar precio final con el precio base
      if (_servicio != null) {
        _finalPrice = _servicio!.precio;
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
              content: Text('Error: $e'), backgroundColor: AppTheme.errorColor),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  // Lógica para validar el cupón
  Future<void> _validateCoupon() async {
    final code = _cuponController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isValidatingCoupon = true;
      _couponMessage = null;
    });

    try {
      // Llamada al backend
      final result = await _cuponService.validateCupon(
        codigo: code,
        servicioId: widget.servicioId,
        montoCompra: _servicio!.precio,
      );

      if (mounted) {
        setState(() {
          _isValidatingCoupon = false;

          if (result['valido'] == true) {
            _appliedCouponCode = code;
            // Asegurarnos de convertir num a double
            _discountAmount = (result['descuento'] as num).toDouble();
            _finalPrice = (result['precio_final'] as num).toDouble();
            _couponMessage = "¡Cupón aplicado!";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(result['mensaje'] ?? 'Cupón válido'),
                  backgroundColor: AppTheme.successColor),
            );
          } else {
            _appliedCouponCode = null;
            _discountAmount = 0.0;
            _finalPrice = _servicio!.precio;
            _couponMessage = result['mensaje'];

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(result['mensaje'] ?? 'Cupón inválido'),
                  backgroundColor: AppTheme.errorColor),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValidatingCoupon = false;
          _appliedCouponCode = null;
          _discountAmount = 0.0;
          _finalPrice = _servicio!.precio;
          _couponMessage = "Error al validar";
        });
      }
    }
  }

  void _removeCoupon() {
    setState(() {
      _cuponController.clear();
      _appliedCouponCode = null;
      _discountAmount = 0.0;
      _finalPrice = _servicio!.precio;
      _couponMessage = null;
    });
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

    final result = await provider.createContratacion(
      servicioId: widget.servicioId,
      sucursalId: widget.sucursalId,
      direccionId: _selectedDireccion!.id,
      fechaProgramada: _fechaProgramada,
      codigoCupon: _appliedCouponCode, // Enviamos el cupón validado
      notas: _notasController.text.isEmpty ? null : _notasController.text,
      metodoPago: _selectedPaymentMethod,
    );

    if (mounted) {
      if (result != null) {
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
                  Navigator.of(ctx).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.orderHistory);
                },
                child: const Text('Ver mis Órdenes'),
              )
            ],
          ),
        );
      } else {
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
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_servicio == null)
      return const Scaffold(
          body: Center(child: Text('Error al cargar servicio')));

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Contratación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- DETALLE SERVICIO ---
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

            // --- DIRECCION ---
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

            // --- FECHA ---
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

            // --- CUPÓN DE DESCUENTO (NUEVO) ---
            const Text('Cupón de Descuento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cuponController,
                    enabled: _appliedCouponCode ==
                        null, // Deshabilitar si ya está aplicado
                    decoration: InputDecoration(
                      hintText: 'Ingresa código',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      errorText:
                          _couponMessage != null && _appliedCouponCode == null
                              ? _couponMessage
                              : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_appliedCouponCode == null)
                  ElevatedButton(
                    onPressed: _isValidatingCoupon ? null : _validateCoupon,
                    child: _isValidatingCoupon
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Aplicar'),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _removeCoupon,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Quitar'),
                    style:
                        OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
            if (_appliedCouponCode != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _couponMessage ?? '',
                  style: const TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 24),

            // --- NOTAS ---
            const Text('Notas Adicionales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _notasController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Instrucciones especiales...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // --- RESUMEN DE PAGO (CON DESCUENTOS) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', _servicio!.precio),
                  if (_discountAmount > 0)
                    _buildPriceRow('Descuento', -_discountAmount,
                        isDiscount: true),
                  const Divider(),
                  _buildPriceRow('Total a Pagar', _finalPrice, isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- BOTÓN CONFIRMAR ---
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
                        : const Text('CONFIRMAR PEDIDO',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isDiscount ? AppTheme.successColor : Colors.black87,
              )),
          Text(
              '\$${amount.abs().toStringAsFixed(2)}', // abs() para mostrar el número positivo aunque sea resta visual
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isDiscount
                    ? AppTheme.successColor
                    : (isTotal ? AppTheme.primaryColor : Colors.black87),
              )),
        ],
      ),
    );
  }
}
