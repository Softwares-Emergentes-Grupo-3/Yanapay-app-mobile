import 'package:go_router/go_router.dart';
import 'package:yanapay_app_mobile/presentation/screens/camera-analysis/camara_analysis_screen.dart';
import 'package:yanapay_app_mobile/presentation/screens/screens.dart';
import 'package:yanapay_app_mobile/providers/auth_provider.dart';

// Crear router con autenticación
GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final bool isLoggedIn = authProvider.isLoggedIn;
      final bool isLoading = authProvider.isLoading;

      // Si está cargando, no hacer redirección
      if (isLoading) return null;

      // Si no está logueado y no está en páginas de auth, redirigir al login
      if (!isLoggedIn && !_isAuthRoute(state.uri.path)) {
        return '/login';
      }

      // Si está logueado y está en páginas de auth, redirigir al home
      if (isLoggedIn && _isAuthRoute(state.uri.path)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: SignUpScreen.name,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/camara-analysis',
        name: CamaraAnalysisScreen.name,
        builder: (context, state) => const CamaraAnalysisScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}

bool _isAuthRoute(String location) {
  return location == '/login' || location == '/register';
}
