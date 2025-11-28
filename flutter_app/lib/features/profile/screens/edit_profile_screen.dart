import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // <--- Importante
import 'package:provider/provider.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/services/auth_service.dart'; // Para llamar uploadImage

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  
  // Archivo de imagen seleccionado
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isUploadingImage = false;

  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _telefonoController;
  late TextEditingController _razonSocialController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.usuario;
    final empresa = authProvider.empresa;

    _nombreController = TextEditingController(text: user?.nombre ?? '');
    _apellidoController = TextEditingController(text: user?.apellido ?? '');
    _telefonoController = TextEditingController(text: user?.telefono ?? '');
    _razonSocialController = TextEditingController(text: empresa?.razonSocial ?? '');
    _descripcionController = TextEditingController(text: empresa?.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _razonSocialController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Función para seleccionar imagen
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authService = AuthService(); // Instancia directa o inyectada

    String? uploadedImageUrl;

    // 1. Si hay una imagen nueva, subirla primero
    if (_selectedImage != null) {
      setState(() => _isUploadingImage = true);
      try {
        uploadedImageUrl = await authService.uploadImage(_selectedImage!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir imagen: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isUploadingImage = false);
        return;
      }
      setState(() => _isUploadingImage = false);
    }

    // 2. Actualizar perfil con todos los datos (incluida la URL de la foto si existe)
    final success = await authProvider.updateProfile(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      telefono: _telefonoController.text.trim(),
      razonSocial: _razonSocialController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      fotoUrl: uploadedImageUrl, // <--- Enviamos la URL nueva
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Error al actualizar'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isEmpresa = authProvider.isEmpresa;
    
    // Foto actual (desde URL o placeholder)
    final currentPhotoUrl = authProvider.profileImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          if (!authProvider.isLoading && !_isUploadingImage)
            TextButton(
              onPressed: _saveChanges,
              child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
            )
        ],
      ),
      body: (authProvider.isLoading || _isUploadingImage)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // --- SECCIÓN DE FOTO ---
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primaryColor, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: _selectedImageBytes != null
                                  ? MemoryImage(_selectedImageBytes!) as ImageProvider
                                  : (currentPhotoUrl != null 
                                      ? NetworkImage(currentPhotoUrl) 
                                      : null),
                              child: (_selectedImageBytes == null && currentPhotoUrl == null)
                                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isEmpresa ? 'Logo de la Empresa' : 'Foto de Perfil',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),

                    // --- CAMPOS DE TEXTO ---
                    _buildSectionTitle('Información Personal'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nombreController,
                      label: 'Nombre',
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _apellidoController,
                      label: 'Apellido',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _telefonoController,
                      label: 'Teléfono',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    if (isEmpresa) ...[
                      const SizedBox(height: 32),
                      _buildSectionTitle('Información del Negocio'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _razonSocialController,
                        label: 'Razón Social',
                        icon: Icons.business,
                        validator: (v) => v!.isEmpty ? 'La razón social es requerida' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descripcionController,
                        label: 'Descripción',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        hint: 'Describe tu empresa...',
                      ),
                    ],
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}