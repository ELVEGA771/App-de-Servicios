import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';

// Auth screens
import 'package:servicios_app/features/auth/screens/splash_screen.dart';
import 'package:servicios_app/features/auth/screens/login_screen.dart';
import 'package:servicios_app/features/auth/screens/register_screen.dart';

// Cliente routes will be imported from cliente_routes.dart
import 'cliente_routes.dart';

// Empresa routes will be imported from empresa_routes.dart
import 'empresa_routes.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final userRole = authProvider.usuario?.tipoUsuario;
      final location = state.uri.path;

      // Always allow splash screen
      if (location == '/splash') {
        return null;
      }

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated &&
          !location.startsWith('/login') &&
          !location.startsWith('/register')) {
        return '/login';
      }

      // If authenticated and on auth screens, redirect to home based on role
      if (isAuthenticated &&
          (location == '/login' || location == '/register' || location == '/')) {
        return userRole == 'cliente' ? '/cliente/home' : '/empresa/home';
      }

      // Protect cliente routes - only clientes can access
      if (location.startsWith('/cliente/') && userRole != 'cliente') {
        return '/empresa/home';
      }

      // Protect empresa routes - only empresas can access
      if (location.startsWith('/empresa/') && userRole != 'empresa') {
        return '/cliente/home';
      }

      return null; // No redirect needed
    },

    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Cliente Routes
      ...clienteRoutes,

      // Empresa Routes
      ...empresaRoutes,
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.path,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
