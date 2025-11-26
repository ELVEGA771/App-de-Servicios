import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/features/profile/screens/addresses_screen.dart'; // Importar la pantalla creada
import 'package:servicios_app/features/profile/screens/change_password_screen.dart'; // <--- Agregar importación

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Encabezado con información del usuario
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    backgroundImage: authProvider.profileImage != null
                        ? NetworkImage(authProvider.profileImage!)
                        : null,
                    child: authProvider.profileImage == null
                        ? Text(
                            authProvider.displayName?[0].toUpperCase() ?? 'U',
                            style: const TextStyle(
                                fontSize: 40, color: AppTheme.primaryColor),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.displayName ?? 'Usuario',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Opciones del Perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 8),
                    child: Text('CUENTA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.person_outline,
                    title: 'Información Personal',
                    subtitle: 'Nombre, teléfono, fecha nacimiento',
                    onTap: () {
                      // Navegar a editar perfil (EditProfileScreen ya existía como placeholder en tu proyecto)
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Mis Direcciones',
                    subtitle: 'Gestionar direcciones de entrega',
                    onTap: () {
                      // Navegar a la pantalla de direcciones que creamos arriba
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddressesScreen()));
                    },
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 8),
                    child: Text('SEGURIDAD',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Cambiar Contraseña',
                    onTap: () {
                      // Navegar a la pantalla de cambio de contraseña
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    title: 'Cerrar Sesión',
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    showArrow: false,
                    onTap: () {
                      _showLogoutDialog(context, authProvider);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    bool showArrow = true,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? AppTheme.primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor ?? AppTheme.textPrimaryColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12))
            : null,
        trailing: showArrow
            ? const Icon(Icons.chevron_right, color: Colors.grey)
            : null,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cerrar Sesión?'),
        content:
            const Text('¿Estás seguro de que deseas salir de la aplicación?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              authProvider.logout();
              AppRoutes.navigateToLogin(context);
            },
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
