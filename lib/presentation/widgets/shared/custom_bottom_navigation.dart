import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yanapay_app_mobile/presentation/screens/camera-analysis/camara_analysis_screen.dart';
import 'package:yanapay_app_mobile/presentation/screens/home/home_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(HomeScreen.name);
        break;
      case 1:
        context.goNamed(CamaraAnalysisScreen.name);
        break;
      case 2:
        context.go('/notifications');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 5,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Cámara',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
      ],
    );
  }
}
