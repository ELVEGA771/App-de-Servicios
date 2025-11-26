import 'package:go_router/go_router.dart';
import 'package:servicios_app/features/empresa/home/screens/dashboard_screen.dart';

/// All routes accessible by Empresa role
final List<RouteBase> empresaRoutes = [
  // Empresa Dashboard
  GoRoute(
    path: '/empresa/home',
    name: 'empresa_home',
    builder: (context, state) => const EmpresaDashboardScreen(),
  ),

  // TODO: Add more empresa routes as we migrate screens
  // Examples:
  // - /empresa/servicios
  // - /empresa/servicios/crear
  // - /empresa/servicios/:id/editar
  // - /empresa/sucursales
  // - /empresa/sucursales/crear
  // - /empresa/contrataciones
  // - /empresa/perfil
  // - /empresa/chat
  // - /empresa/notificaciones
];
