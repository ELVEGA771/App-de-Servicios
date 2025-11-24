import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/models/categoria.dart';
import 'package:servicios_app/core/models/sucursal.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/categoria_service.dart';
import 'package:servicios_app/core/services/servicio_service.dart';
import 'package:servicios_app/core/services/sucursal_service.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoriaService _categoriaService = CategoriaService();
  final ServicioService _servicioService = ServicioService();
  final SucursalService _sucursalService = SucursalService();

  // Form controllers
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _duracionController = TextEditingController();
  final _imagenUrlController = TextEditingController();

  // State variables
  List<Categoria> _categorias = [];
  List<Sucursal> _sucursales = [];
  int? _selectedCategoriaId;
  int? _selectedSucursalId;
  bool _isLoading = false;
  bool _isLoadingCategorias = true;
  bool _isLoadingSucursales = true;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
    _loadSucursales();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _duracionController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadCategorias() async {
    try {
      print('DEBUG: Cargando categorías...');
      final categorias = await _categoriaService.getAllCategorias();
      print('DEBUG: Categorías cargadas: ${categorias.length}');
      for (var cat in categorias) {
        print('DEBUG:   - ${cat.nombre} (ID: ${cat.id})');
      }
      setState(() {
        _categorias = categorias;
        _isLoadingCategorias = false;
      });
      print('DEBUG: Estado actualizado. _categorias.length = ${_categorias.length}');
    } catch (e) {
      print('DEBUG: Error al cargar categorías: $e');
      setState(() {
        _isLoadingCategorias = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar categorías: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _loadSucursales() async {
    try {
      print('DEBUG: Cargando sucursales...');
      final sucursales = await _sucursalService.getActiveSucursales();
      print('DEBUG: Sucursales cargadas: ${sucursales.length}');
      setState(() {
        _sucursales = sucursales;
        _isLoadingSucursales = false;
      });
    } catch (e) {
      print('DEBUG: Error al cargar sucursales: $e');
      setState(() {
        _isLoadingSucursales = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar sucursales: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final servicio = await _servicioService.createServicio(
        categoriaId: _selectedCategoriaId!,
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        precio: double.parse(_precioController.text.trim()),
        duracionEstimada: _duracionController.text.trim().isEmpty
            ? null
            : _duracionController.text.trim(),
        imagenPrincipal: _imagenUrlController.text.trim().isEmpty
            ? null
            : _imagenUrlController.text.trim(),
      );

      // Add service to sucursal if one was selected
      if (_selectedSucursalId != null) {
        try {
          await _servicioService.addServicioToSucursal(
            servicioId: servicio.id,
            sucursalId: _selectedSucursalId!,
          );
        } catch (e) {
          print('DEBUG: Error al asociar servicio con sucursal: $e');
          // Don't fail the entire operation if sucursal association fails
        }
      }

      if (mounted) {
        // Clear form
        _nombreController.clear();
        _descripcionController.clear();
        _precioController.clear();
        _duracionController.clear();
        _imagenUrlController.clear();
        setState(() {
          _selectedCategoriaId = null;
          _selectedSucursalId = null;
        });

        // Show success message with longer duration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Servicio creado exitosamente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Wait a moment before closing so user can see the success message
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      }
    } catch (e) {
      if (mounted) {
        // Extract user-friendly error message
        String errorMessage = 'Error al crear servicio';
        if (e.toString().contains('VALIDATION_ERROR')) {
          errorMessage = 'Por favor verifica los campos del formulario';
        } else if (e.toString().contains('Duration must be a positive number')) {
          errorMessage = 'La duración debe ser un número positivo (ej: 2)';
        } else if (e.toString().contains('Network')) {
          errorMessage = 'Error de conexión. Verifica tu internet';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Servicio'),
        elevation: 0,
      ),
      body: _isLoadingCategorias || _isLoadingSucursales
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add_business,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nuevo Servicio',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Completa la información del servicio',
                                        style: TextStyle(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nombre del servicio
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Servicio',
                        hintText: 'Ej: Reparación de computadoras',
                        prefixIcon: const Icon(Icons.label),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        if (value.trim().length < 3) {
                          return 'El nombre debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // Categoría
                    DropdownButtonFormField<int>(
                      value: _selectedCategoriaId,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _categorias.map((categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoriaId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sucursal (opcional)
                    DropdownButtonFormField<int>(
                      value: _selectedSucursalId,
                      decoration: InputDecoration(
                        labelText: 'Sucursal (opcional)',
                        prefixIcon: const Icon(Icons.store),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: 'Asociar este servicio a una sucursal',
                      ),
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Sin sucursal'),
                        ),
                        ..._sucursales.map((sucursal) {
                          return DropdownMenuItem<int>(
                            value: sucursal.idSucursal,
                            child: Text(sucursal.nombreSucursal),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSucursalId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    TextFormField(
                      controller: _descripcionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        hintText:
                            'Describe detalladamente el servicio que ofreces',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La descripción es requerida';
                        }
                        if (value.trim().length < 10) {
                          return 'La descripción debe tener al menos 10 caracteres';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),

                    // Precio
                    TextFormField(
                      controller: _precioController,
                      decoration: InputDecoration(
                        labelText: 'Precio Base',
                        hintText: '0.00',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixText: 'USD',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El precio es requerido';
                        }
                        final precio = double.tryParse(value.trim());
                        if (precio == null) {
                          return 'Ingresa un precio válido';
                        }
                        if (precio <= 0) {
                          return 'El precio debe ser mayor a 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Duración estimada (opcional)
                    TextFormField(
                      controller: _duracionController,
                      decoration: InputDecoration(
                        labelText: 'Duración Estimada en horas (opcional)',
                        hintText: 'Ej: 2',
                        helperText: 'Ingresa solo el número de horas',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixText: 'horas',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // URL de imagen (opcional)
                    TextFormField(
                      controller: _imagenUrlController,
                      decoration: InputDecoration(
                        labelText: 'URL de Imagen (opcional)',
                        hintText: 'https://ejemplo.com/imagen.jpg',
                        prefixIcon: const Icon(Icons.image),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 24),

                    // Botón de crear
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Crear Servicio',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Botón de cancelar
                    OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
