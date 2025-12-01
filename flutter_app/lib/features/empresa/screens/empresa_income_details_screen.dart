import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/empresa_service.dart';
import 'package:intl/intl.dart';

class EmpresaIncomeDetailsScreen extends StatefulWidget {
  const EmpresaIncomeDetailsScreen({super.key});

  @override
  State<EmpresaIncomeDetailsScreen> createState() => _EmpresaIncomeDetailsScreenState();
}

class _EmpresaIncomeDetailsScreenState extends State<EmpresaIncomeDetailsScreen> {
  final EmpresaService _empresaService = EmpresaService();
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final empresa = authProvider.empresa;

      if (empresa != null) {
        final result = await _empresaService.getIncomeDetails(
          empresa.id,
          page: _currentPage,
          limit: _limit,
        );

        setState(() {
          _transactions = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'No se pudo obtener el ID de la empresa';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar detalles: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Ingresos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _transactions.isEmpty
                  ? const Center(child: Text('No hay transacciones registradas'))
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Fecha')),
                                  DataColumn(label: Text('Servicio')),
                                  DataColumn(label: Text('Cliente')),
                                  DataColumn(label: Text('Método Pago')),
                                  DataColumn(label: Text('Monto')),
                                  DataColumn(label: Text('Calificación')),
                                ],
                                rows: _transactions.map((tx) {
                                  final date = DateTime.parse(tx['fecha_completada']);
                                  final formattedDate = DateFormat('dd/MM/yyyy').format(date);
                                  
                                  return DataRow(cells: [
                                    DataCell(Text(formattedDate)),
                                    DataCell(Text(tx['servicio_nombre'] ?? 'N/A')),
                                    DataCell(Row(
                                      children: [
                                        if (tx['cliente_foto'] != null)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundImage: NetworkImage(tx['cliente_foto']),
                                            ),
                                          ),
                                        Text(tx['cliente_nombre'] ?? 'N/A'),
                                      ],
                                    )),
                                    DataCell(Text(tx['metodo_pago'] ?? 'N/A')),
                                    DataCell(Text('\$${double.parse(tx['precio_total'].toString()).toStringAsFixed(2)}')),
                                    DataCell(
                                      tx['calificacion'] != null
                                          ? Row(
                                              children: [
                                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                                Text(' ${tx['calificacion']}'),
                                              ],
                                            )
                                          : const Text('-'),
                                    ),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        // Pagination controls could go here
                      ],
                    ),
    );
  }
}
