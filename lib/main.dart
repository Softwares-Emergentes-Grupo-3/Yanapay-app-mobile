import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanapay_app_mobile/config/router/app_router.dart';
import 'package:yanapay_app_mobile/config/theme/app_theme.dart';
import 'package:yanapay_app_mobile/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    // Inicializar la autenticación al inicio
    _authProvider.initializeAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'Yanapay',
            routerConfig: createAppRouter(authProvider),
            debugShowCheckedModeBanner: false,
            theme: AppTheme().getTheme(),
          );
        },
      ),
    );
  }
}
