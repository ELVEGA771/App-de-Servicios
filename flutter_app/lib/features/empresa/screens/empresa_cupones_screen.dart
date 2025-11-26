import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/cupon.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/cupon_service.dart';
import 'package:intl/intl.dart';

class EmpresaCuponesScreen extends StatefulWidget {
  const EmpresaCuponesScreen({super.key});

  @override
  State<EmpresaCuponesScreen> createState() => _EmpresaCuponesScreenState();
}

class _EmpresaCuponesScreenState extends State<EmpresaCuponesScreen> {
  final CuponService _cuponService = CuponService();
  List<Cupon> _cupones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCupones();
  }

  Future<void> _loadCupones() async {
    final empresa = Provider.of<AuthProvider>(context, listen: false).empresa;
    if (empresa == null) return;

    setState(() => _isLoading = true);
    try {
      final cupones = await _cuponService.getEmpresaCupones(empresa.id);
      setState(() {
        _cupones = cupones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Cupones')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/empresa/cupones/create');
          if (result == true) _loadCupones();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cupones.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cupones.length,
                  itemBuilder: (context, index) {
                    final cupon = _cupones[index];
                    final isExpired = cupon.fechaExpiracion != null &&
                        cupon.fechaExpiracion!.isBefore(DateTime.now());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isExpired
                                ? Colors.grey[300]
                                : AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.local_offer,
                              color: isExpired
                                  ? Colors.grey
                                  : AppTheme.primaryColor),
                        ),
                        title: Text(
                          cupon.codigo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cupon.tipoDescuento == 'porcentaje'
                                  ? '${cupon.valorDescuento}% OFF'
                                  : '\$${cupon.valorDescuento} OFF',
                              style: const TextStyle(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Usados: ${cupon.cantidadUsada} / ${cupon.cantidadDisponible}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (cupon.fechaExpiracion != null)
                              Text(
                                'Expira: ${DateFormat('dd/MM/yyyy').format(cupon.fechaExpiracion!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isExpired
                                      ? AppTheme.errorColor
                                      : Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cupon.activo && !isExpired
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cupon.activo && !isExpired ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                                fontSize: 10,
                                color: cupon.activo && !isExpired
                                    ? Colors.green[800]
                                    : Colors.red[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No tienes cupones activos',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text('Crea uno para atraer más clientes'),
        ],
      ),
    );
  }
}
