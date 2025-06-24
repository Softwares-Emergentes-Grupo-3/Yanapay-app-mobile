import 'package:flutter/material.dart';
import 'package:yanapay_app_mobile/presentation/widgets/shared/custom_bottom_navigation.dart';

class CamaraAnalysisScreen extends StatelessWidget {
  static const name = 'camara-analysis';
  const CamaraAnalysisScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Contenedor de imagen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade200, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 40, color: Colors.blueGrey),
                      SizedBox(height: 10),
                      Text(
                        'Select an image to analyze',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Botón "Send image"
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade100,
                disabledBackgroundColor: Colors.blueGrey.shade100,
              ),
              child: const Text('Send image'),
            ),
            const SizedBox(height: 10),
            // Botón "View Analysis"
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade100,
                disabledBackgroundColor: Colors.blueGrey.shade100,
              ),
              child: const Text('View  Analysis'),
            ),
          ],
        ),
      ),
    bottomNavigationBar: const CustomBottomNavigation(currentIndex:1),
    );
  }
}
