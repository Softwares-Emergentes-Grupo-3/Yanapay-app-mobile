import 'package:flutter/material.dart';
import 'package:yanapay_app_mobile/presentation/widgets/greenhouse/greenhouse_grid.dart';
import 'package:yanapay_app_mobile/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
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
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: [
                  const TextSpan(text: 'Bienvenido, '),
                  TextSpan(
                      text: 'Aaron', style: TextStyle(color: colors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Weather card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.primary, width: 2),
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
                      Text('20°',
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
                      Icon(Icons.cloud, size: 48, color: colors.primary),
                      const SizedBox(height: 4),
                      Text('Cloudy',
                          style: TextStyle(
                              fontSize: 16,
                              color: colors.primary,
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
