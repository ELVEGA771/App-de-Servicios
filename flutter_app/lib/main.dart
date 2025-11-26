import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/config/routes.dart';
import 'package:servicios_app/core/providers/auth_provider.dart';
import 'package:servicios_app/core/providers/servicio_provider.dart';
import 'package:servicios_app/core/providers/contratacion_provider.dart';
import 'package:servicios_app/core/providers/favorito_provider.dart';
import 'package:servicios_app/core/providers/chat_provider.dart';
import 'package:servicios_app/core/providers/notificacion_provider.dart';
import 'package:servicios_app/core/providers/direccion_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local caching
  await Hive.initFlutter();
  await Hive.openBox('cache_box');
  await Hive.openBox('favorites_box');
  await Hive.openBox('search_history_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServicioProvider()),
        ChangeNotifierProvider(create: (_) => ContratacionProvider()),
        ChangeNotifierProvider(create: (_) => FavoritoProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NotificacionProvider()),
        ChangeNotifierProvider(create: (_) => DireccionProvider()),
      ],
      child: MaterialApp(
        title: 'Servicios App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
