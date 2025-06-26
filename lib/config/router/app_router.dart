import 'package:go_router/go_router.dart';
import 'package:yanapay_app_mobile/presentation/screens/camera-analysis/camara_analysis_screen.dart';
import 'package:yanapay_app_mobile/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        name: 'home-screen',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'camara-analysis',
            name: 'camara-analysis',
            builder: (context, state) => const CamaraAnalysisScreen(),
          ),
        ]),
  ],
);
