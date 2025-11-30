import 'package:flutter/material.dart';
import 'package:servicios_app/core/models/sucursal.dart';
import 'package:servicios_app/core/models/direccion.dart';
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
import 'package:servicios_app/features/profile/screens/address_list_screen.dart';
import 'package:servicios_app/features/profile/screens/add_edit_address_screen.dart';
// import 'package:servicios_app/features/profile/screens/addresses_screen.dart'; // Removed unused import
// import 'package:servicios_app/features/profile/screens/add_address_screen.dart'; // Removed unused import
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
import 'package:servicios_app/features/cupones/screens/cupones_disponibles_screen.dart';
import 'package:servicios_app/features/admin/screens/admin_dashboard_screen.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String adminDashboard = '/admin/dashboard';

  // Servicios
  static const String servicioDetail = '/servicio/detail';
  static const String servicioSearch = '/servicio/search';
  static const String servicioList = '/servicio/list';

  // Contrataciones
  static const String checkout = '/contratacion/checkout';
  static const String orderDetail = '/contratacion/detail';
  static const String orderTracking = '/contratacion/tracking';
  static const String orderHistory = '/contratacion/history';

  // Favoritos
  static const String favoritos = '/favoritos';

  // Chat
  static const String conversations = '/chat/conversations';
  static const String chat = '/chat';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addressList = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
  static const String editAddress = '/profile/addresses/edit';

  // Empresa
  static const String empresaDashboard = '/empresa/dashboard';
  static const String empresaServices = '/empresa/services';
  static const String createService = '/empresa/service/create';
  static const String editService = '/empresa/service/edit';
  static const String empresaOrders = '/empresa/orders';
  static const String manageSucursales = '/empresa/sucursales';
  static const String createSucursal = '/empresa/sucursal/create';
  static const String editSucursal = '/empresa/sucursal/edit';
  static const String empresaCupones = '/empresa/cupones';

  // Notificaciones
  static const String notificaciones = '/notificaciones';

  // Direcciones
  // static const String addresses = '/addresses'; // Removed unused constant
  //static const String addAddress = '/addresses/add';

  // Cupones
  static const String createCupon = '/empresa/cupones/create';
  static const String cuponesDisponibles = '/cupones/disponibles';

  // Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // Servicio routes
      case servicioDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final servicioId = args?['id'] as int;
        return MaterialPageRoute(
          builder: (_) => ServicioDetailScreen(servicioId: servicioId),
        );

      case servicioSearch:
        return MaterialPageRoute(builder: (_) => const ServicioSearchScreen());

      case servicioList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ServicioListScreen(
            categoriaId: args?['categoriaId'] as int?,
            ciudad: args?['ciudad'] as String?,
            titulo: args?['titulo'] as String?,
          ),
        );

      // Contratacion routes
      case checkout:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            servicioId: args['servicioId'] as int,
            sucursalId: args['sucursalId'] as int,
          ),
        );

      case orderDetail:
        final args = settings.arguments as Map<String, dynamic>;
        final orderId = args['id'] as int;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: orderId),
        );

      case orderTracking:
        final args = settings.arguments as Map<String, dynamic>;
        final orderId = args['id'] as int;
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: orderId),
        );

      case orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());

      // Favoritos
      case favoritos:
        return MaterialPageRoute(builder: (_) => const FavoritosScreen());

      // Chat routes
      case conversations:
        return MaterialPageRoute(builder: (_) => const ConversationsScreen());

      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversacionId: args['conversacionId'] as int,
            otherUserName: args['otherUserName'] as String,
          ),
        );

      // Profile routes
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case addressList:
        final args = settings.arguments as Map<String, dynamic>?;
        final selectionMode = args?['selectionMode'] as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => AddressListScreen(selectionMode: selectionMode),
        );

      case addAddress:
        return MaterialPageRoute(builder: (_) => const AddEditAddressScreen());

      case editAddress:
        final args = settings.arguments as Direccion;
        return MaterialPageRoute(
          builder: (_) => AddEditAddressScreen(direccion: args),
        );

      // Empresa routes
      case empresaDashboard:
        return MaterialPageRoute(
            builder: (_) => const EmpresaDashboardScreen());

      case empresaServices:
        return MaterialPageRoute(builder: (_) => const EmpresaServicesScreen());

      case createService:
        return MaterialPageRoute(builder: (_) => const CreateServiceScreen());

      case editService:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditServiceScreen(servicioId: args['id'] as int),
        );

      case empresaOrders:
        return MaterialPageRoute(builder: (_) => const EmpresaOrdersScreen());

      case manageSucursales:
        return MaterialPageRoute(
            builder: (_) => const ManageSucursalesScreen());

      case createSucursal:
        return MaterialPageRoute(builder: (_) => const CreateSucursalScreen());

      case editSucursal:
        final args = settings.arguments as Sucursal;
        return MaterialPageRoute(
          builder: (_) => CreateSucursalScreen(sucursal: args),
        );

      case empresaCupones:
        return MaterialPageRoute(builder: (_) => const EmpresaCuponesScreen());

      case createCupon:
        return MaterialPageRoute(builder: (_) => const CreateCuponScreen());

      case cuponesDisponibles:
        return MaterialPageRoute(builder: (_) => const CuponesDisponiblesScreen());

      // Notificaciones
      case notificaciones:
        return MaterialPageRoute(builder: (_) => const NotificacionesScreen());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }

// Navigation Helpers
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  }

  static void navigateToServicioDetail(BuildContext context, int servicioId) {
    Navigator.of(context).pushNamed(
      servicioDetail,
      arguments: {'id': servicioId},
    );
  }

  static void navigateToCheckout(
      BuildContext context, int servicioId, int sucursalId) {
    Navigator.of(context).pushNamed(
      checkout,
      arguments: {'servicioId': servicioId, 'sucursalId': sucursalId},
    );
  }

  static void navigateToOrderDetail(BuildContext context, int orderId) {
    Navigator.of(context).pushNamed(
      orderDetail,
      arguments: {'id': orderId},
    );
  }

  static void navigateToChat(
      BuildContext context, int conversacionId, String otherUserName) {
    Navigator.of(context).pushNamed(
      chat,
      arguments: {
        'conversacionId': conversacionId,
        'otherUserName': otherUserName
      },
    );
  }

  static void navigateToCuponesDisponibles(BuildContext context) {
    Navigator.of(context).pushNamed(cuponesDisponibles);
  }
}
