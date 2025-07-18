import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanapay_app_mobile/presentation/widgets/greenhouse/greenhouse_grid.dart';
import 'package:yanapay_app_mobile/presentation/widgets/shared/custom_appbar.dart';
import 'package:yanapay_app_mobile/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:yanapay_app_mobile/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User avatar and profile icon row
            const CustomAppbar(),
            const SizedBox(height: 16),
            // Welcome text
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(text: 'Bienvenido, '),
                      TextSpan(
                          text: authProvider.userName ?? 'Usuario',
                          style: TextStyle(color: colors.primary)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Weather card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 35, right: 35, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.tertiary.withAlpha(185).withBlue(50).withRed(170), width: 3.5  ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('  20°',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Lima, Perú',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.wb_cloudy_outlined, size: 48, color:colors.primary.withRed(30).withGreen(100).withBlue(0).withAlpha(100)),
                      const SizedBox(height: 4),
                      Text('Nublado',
                          style: TextStyle(
                              fontSize: 16,
                              color: colors.primary.withRed(30).withGreen(100).withBlue(0).withAlpha(130),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const GreenhouseGrid()
          ],
        ),
      ),
    );
  }
}
