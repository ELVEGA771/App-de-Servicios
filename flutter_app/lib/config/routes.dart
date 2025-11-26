import 'package:flutter/material.dart';
import 'package:servicios_app/features/auth/screens/login_screen.dart';
import 'package:servicios_app/features/auth/screens/register_screen.dart';
import 'package:servicios_app/features/auth/screens/splash_screen.dart';
import 'package:servicios_app/features/home/screens/home_screen.dart';
import 'package:servicios_app/features/servicio/screens/servicio_list_screen.dart';
import 'package:servicios_app/features/servicio/screens/servicio_detail_screen.dart';
import 'package:servicios_app/features/servicio/screens/servicio_search_screen.dart'; // Importante: Nueva importación
import 'package:servicios_app/features/contratacion/screens/order_history_screen.dart';
import 'package:servicios_app/features/contratacion/screens/order_detail_screen.dart';
import 'package:servicios_app/features/contratacion/screens/order_tracking_screen.dart';
import 'package:servicios_app/features/contratacion/screens/checkout_screen.dart';
import 'package:servicios_app/features/profile/screens/profile_screen.dart';
import 'package:servicios_app/features/profile/screens/edit_profile_screen.dart';
import 'package:servicios_app/features/profile/screens/addresses_screen.dart';
import 'package:servicios_app/features/profile/screens/add_address_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_dashboard_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_services_screen.dart';
import 'package:servicios_app/features/empresa/screens/create_service_screen.dart';
import 'package:servicios_app/features/empresa/screens/edit_service_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_orders_screen.dart';
import 'package:servicios_app/features/empresa/screens/manage_sucursales_screen.dart';
import 'package:servicios_app/features/empresa/screens/create_sucursal_screen.dart';
import 'package:servicios_app/features/favoritos/screens/favoritos_screen.dart';
import 'package:servicios_app/features/chat/screens/conversations_screen.dart';
import 'package:servicios_app/features/chat/screens/chat_screen.dart';
import 'package:servicios_app/features/notificaciones/screens/notificaciones_screen.dart';
import 'package:servicios_app/features/empresa/screens/empresa_cupones_screen.dart';
import 'package:servicios_app/features/empresa/screens/create_cupon_screen.dart';

class AppRoutes {
  // Constantes de Rutas
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String servicios = '/servicios';
  static const String servicioDetail = '/servicio-detail';
  static const String servicioSearch = '/servicio-search'; // Restaurado
  static const String checkout = '/checkout';
  static const String orderHistory = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static const String favoritos = '/favoritos';
  static const String conversations = '/conversations';
  static const String chat = '/chat';
  static const String notificaciones = '/notificaciones';

  // Rutas de Empresa
  static const String empresaDashboard = '/empresa/dashboard';
  static const String empresaServices = '/empresa/services';
  static const String createService = '/empresa/service/create';
  static const String editService = '/empresa/service/edit';
  static const String empresaOrders = '/empresa/orders';
  static const String empresaSucursales = '/empresa/sucursales';
  static const String createSucursal = '/empresa/sucursales/create';
  static const String empresaCupones = '/empresa/cupones';
  static const String createCupon = '/empresa/cupones/create';

  // Mapa de Rutas
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      servicios: (context) => const ServicioListScreen(),
      servicioSearch: (context) => const ServicioSearchScreen(), // Restaurado
      orderHistory: (context) => const OrderHistoryScreen(),
      profile: (context) => const ProfileScreen(),
      editProfile: (context) => const EditProfileScreen(),
      addresses: (context) => const AddressesScreen(),
      addAddress: (context) => const AddAddressScreen(),
      empresaDashboard: (context) => const EmpresaDashboardScreen(),
      empresaServices: (context) => const EmpresaServicesScreen(),
      createService: (context) => const CreateServiceScreen(),
      empresaOrders: (context) => const EmpresaOrdersScreen(),
      empresaSucursales: (context) => const ManageSucursalesScreen(),
      createSucursal: (context) => const CreateSucursalScreen(),
      favoritos: (context) => const FavoritosScreen(),
      conversations: (context) => const ConversationsScreen(),
      notificaciones: (context) => const NotificacionesScreen(),
      empresaCupones: (context) => const EmpresaCuponesScreen(),
      createCupon: (context) => const CreateCuponScreen(),
    };
  }

  // Generador de Rutas Dinámicas (con argumentos)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 1. SERVICIO DETAIL
    if (settings.name == servicioDetail) {
      final args = settings.arguments;
      // Maneja si viene como Map (ej: {'id': 1}) o como int directo (ej: 1)
      final int id = (args is Map) ? args['id'] : args as int;

      return MaterialPageRoute(
        builder: (context) => ServicioDetailScreen(servicioId: id),
      );
    }

    // 2. CHECKOUT
    if (settings.name == checkout) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          servicioId: args['servicioId'],
          sucursalId: args['sucursalId'],
        ),
      );
    }

    // 3. EDIT SERVICE
    if (settings.name == editService) {
      final args = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => EditServiceScreen(servicioId: args),
      );
    }

    // 4. ORDER DETAIL
    if (settings.name == orderDetail) {
      final args = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => OrderDetailScreen(orderId: args),
      );
    }

    // 5. ORDER TRACKING
    if (settings.name == orderTracking) {
      final args = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => OrderTrackingScreen(orderId: args),
      );
    }

    // 6. CHAT
    if (settings.name == chat) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          conversacionId: args['conversationId'],
          otherUserName: args['otherUserName'],
        ),
      );
    }

    return null;
  }

  // --- MÉTODOS ESTÁTICOS DE NAVEGACIÓN (Restaurados) ---

  // Navegar al Home (Login/Register)
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  // Navegar al Login (Logout)
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  // Navegar al Detalle de Servicio
  static void navigateToServicioDetail(BuildContext context, int servicioId) {
    Navigator.pushNamed(
      context,
      servicioDetail,
      arguments: {'id': servicioId}, // Enviamos como Map para ser consistentes
    );
  }

  // Navegar al Checkout
  static void navigateToCheckout(
      BuildContext context, int servicioId, int sucursalId) {
    Navigator.pushNamed(context, checkout, arguments: {
      'servicioId': servicioId,
      'sucursalId': sucursalId,
    });
  }
}
