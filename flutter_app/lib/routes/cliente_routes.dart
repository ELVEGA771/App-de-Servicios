import 'package:go_router/go_router.dart';
import 'package:servicios_app/features/cliente/home/screens/home_screen.dart';
import 'package:servicios_app/features/cliente/servicios/screens/servicio_list_screen.dart';
import 'package:servicios_app/features/cliente/servicios/screens/servicio_search_screen.dart';
import 'package:servicios_app/features/cliente/servicios/screens/servicio_detail_screen.dart';

/// All routes accessible by Cliente role
final List<RouteBase> clienteRoutes = [
  // Cliente Home
  GoRoute(
    path: '/cliente/home',
    name: 'cliente_home',
    builder: (context, state) => const ClienteHomeScreen(),
  ),

  // Servicios
  GoRoute(
    path: '/cliente/servicios',
    name: 'cliente_servicios',
    builder: (context, state) {
      final categoriaId = state.uri.queryParameters['categoriaId'];
      final ciudad = state.uri.queryParameters['ciudad'];
      final titulo = state.uri.queryParameters['titulo'];
      return ServicioListScreen(
        categoriaId: categoriaId != null ? int.tryParse(categoriaId) : null,
        ciudad: ciudad,
        titulo: titulo,
      );
    },
  ),
  GoRoute(
    path: '/cliente/servicios/buscar',
    name: 'cliente_servicios_buscar',
    builder: (context, state) => const ServicioSearchScreen(),
  ),
  GoRoute(
    path: '/cliente/servicios/:id',
    name: 'cliente_servicio_detail',
    builder: (context, state) {
      final id = int.parse(state.pathParameters['id']!);
      return ServicioDetailScreen(servicioId: id);
    },
  ),

  // TODO: Add more cliente routes as we migrate screens
  // - /cliente/checkout/:servicioId/:sucursalId
  // - /cliente/contrataciones
  // - /cliente/contrataciones/:id
  // - /cliente/favoritos
  // - /cliente/perfil
  // - /cliente/chat
  // - /cliente/notificaciones
];
