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
import 'package:servicios_app/core/api/dio_client.dart'; // Para obtener direcciones

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
  final _formKey = GlobalKey<FormState>();
  final _notasController = TextEditingController();

  // Estado
  bool _isLoading = true;
  List<Direccion> _direcciones = [];
  int? _selectedDireccionId;
  DateTime? _fechaProgramada;
  Servicio? _servicio;

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

      // 2. Cargar direcciones del cliente (Directo via DioClient ya que no hay DireccionProvider aun)
      // Endpoint: GET /api/direcciones
      final dioClient = DioClient();
      final response = await dioClient.get('/direcciones');

      if (mounted) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          _direcciones = data.map((json) => Direccion.fromJson(json)).toList();
          // Seleccionar la dirección principal por defecto
          if (_direcciones.isNotEmpty) {
            try {
              final principal = _direcciones.firstWhere((d) => d.esPrincipal);
              _selectedDireccionId = principal.id;
            } catch (e) {
              _selectedDireccionId = _direcciones.first.id;
            }
          }
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
    if (_selectedDireccionId == null) {
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
      direccionId: _selectedDireccionId,
      fechaProgramada: _fechaProgramada,
      notas: _notasController.text.isEmpty ? null : _notasController.text,
      metodoPago: 'efectivo', // Por defecto o implementar selector
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
            if (_direcciones.isEmpty)
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('No tienes direcciones registradas.',
                          textAlign: TextAlign.center),
                      TextButton(
                        onPressed: () {
                          // Navegar a crear dirección (necesita implementarse esa pantalla)
                          // Por ahora un placeholder
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Funcionalidad de crear dirección pendiente de implementar en UI')),
                          );
                        },
                        child: const Text('Agregar Dirección'),
                      ),
                    ],
                  ),
                ),
              )
            else
              DropdownButtonFormField<int>(
                value: _selectedDireccionId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                items: _direcciones.map((d) {
                  return DropdownMenuItem(
                    value: d.id,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        d.alias.isNotEmpty
                            ? '${d.alias} - ${d.direccionCorta}'
                            : d.direccionCorta,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedDireccionId = val),
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
