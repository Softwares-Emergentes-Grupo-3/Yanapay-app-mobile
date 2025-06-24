import 'package:go_router/go_router.dart';
import 'package:yanapay_app_mobile/presentation/screens/camera-analysis/camara_analysis_screen.dart';
import 'package:yanapay_app_mobile/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'camara-analysis',
            name: CamaraAnalysisScreen.name,
            builder: (context, state) => const CamaraAnalysisScreen(),
          ),
        ]),
  ],
);
