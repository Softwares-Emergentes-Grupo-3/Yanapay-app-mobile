import 'package:flutter/material.dart';
import 'package:yanapay_app_mobile/presentation/screens/screens.dart';
import 'package:yanapay_app_mobile/presentation/widgets/widgets.dart';

class GreenhouseGrid extends StatelessWidget {
  const GreenhouseGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Icon(Icons.spa, color: colors.secondary),
            const SizedBox(width: 8),
            const Text('Invernaderos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        // Greenhouse cards grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const GreenhouseScreen(greenhouseId: '1'),
                  ),
                );
              },
              child: const GreenhouseCard(title: 'Invernadero 1'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const GreenhouseScreen(greenhouseId: '2'),
                  ),
                );
              },
              child: const GreenhouseCard(title: 'Invernadero 2'),
            ),
            const AddGreenhouseCard(),
          ],
        ),
      ],
    );
  }
}
