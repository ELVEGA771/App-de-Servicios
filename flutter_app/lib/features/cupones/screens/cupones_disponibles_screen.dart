import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/cupon.dart';
import 'package:servicios_app/core/services/cupon_service.dart';
import 'package:intl/intl.dart';

class CuponesDisponiblesScreen extends StatefulWidget {
  const CuponesDisponiblesScreen({super.key});

  @override
  State<CuponesDisponiblesScreen> createState() =>
      _CuponesDisponiblesScreenState();
}

class _CuponesDisponiblesScreenState extends State<CuponesDisponiblesScreen> {
  final CuponService _cuponService = CuponService();
  List<Cupon> _cupones = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCupones();
  }

  Future<void> _loadCupones() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cupones = await _cuponService.getActiveCupones();
      if (mounted) {
        setState(() {
          _cupones = cupones;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar cupones: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _copiarCodigo(String codigo) {
    Clipboard.setData(ClipboardData(text: codigo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Código "$codigo" copiado'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupones Disponibles'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppTheme.errorColor),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadCupones,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _cupones.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_offer_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No hay cupones disponibles',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadCupones,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _cupones.length,
                        itemBuilder: (context, index) {
                          final cupon = _cupones[index];
                          return _buildCuponCard(cupon);
                        },
                      ),
                    ),
    );
  }

  Widget _buildCuponCard(Cupon cupon) {
    final usoDisponible = cupon.cantidadDisponible - cupon.cantidadUsada;
    final diasRestantes = cupon.fechaExpiracion != null
        ? cupon.fechaExpiracion!.difference(DateTime.now()).inDays
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con empresa
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      cupon.empresaNombre ?? 'Empresa',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.local_offer,
                      size: 20, color: AppTheme.primaryColor),
                ],
              ),
              const SizedBox(height: 12),

              // Código del cupón
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cupon.codigo,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Icon(Icons.copy,
                              size: 20, color: AppTheme.primaryColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _copiarCodigo(cupon.codigo),
                    icon: const Icon(Icons.content_copy),
                    color: AppTheme.primaryColor,
                    tooltip: 'Copiar código',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Descripción
              Text(
                cupon.descripcion,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Descuento
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.discount,
                        color: AppTheme.successColor, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      cupon.tipoDescuento == 'porcentaje'
                          ? '${cupon.valorDescuento.toStringAsFixed(0)}% de descuento'
                          : '\$${cupon.valorDescuento.toStringAsFixed(2)} de descuento',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Detalles
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      Icons.shopping_cart,
                      'Compra mínima',
                      '\$${cupon.montoMinimoCompra.toStringAsFixed(2)}',
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.inventory,
                      'Disponibles',
                      '$usoDisponible cupones',
                    ),
                  ),
                ],
              ),

              // Fecha de expiración
              if (cupon.fechaExpiracion != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: diasRestantes != null && diasRestantes < 7
                          ? AppTheme.errorColor
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      diasRestantes != null && diasRestantes >= 0
                          ? diasRestantes == 0
                              ? 'Expira hoy'
                              : diasRestantes == 1
                                  ? 'Expira mañana'
                                  : 'Expira en $diasRestantes días'
                          : 'Expirado',
                      style: TextStyle(
                        fontSize: 12,
                        color: diasRestantes != null && diasRestantes < 7
                            ? AppTheme.errorColor
                            : Colors.grey[600],
                        fontWeight: diasRestantes != null && diasRestantes < 7
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Válido hasta ${DateFormat('dd/MM/yyyy').format(cupon.fechaExpiracion!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
