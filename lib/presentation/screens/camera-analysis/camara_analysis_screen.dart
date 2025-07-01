import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yanapay_app_mobile/presentation/widgets/shared/custom_bottom_navigation.dart';

class CamaraAnalysisScreen extends StatefulWidget {
  static const String name = 'camara-analysis';
  const CamaraAnalysisScreen({super.key});

  @override
  State<CamaraAnalysisScreen> createState() => _CamaraAnalysisScreenState();
}

class _CamaraAnalysisScreenState extends State<CamaraAnalysisScreen> {
  XFile? _pickedFile;
  bool _imageSent = false;

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _imageSent = false; // Resetear al seleccionar nueva imagen
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen seleccionada: ${pickedFile.name}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ninguna imagen')),
      );
    }
  }

  void _sendImage(BuildContext context) {
    setState(() {
      _imageSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Imagen enviada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isImageSelected = _pickedFile != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: GestureDetector(
                onTap: isImageSelected ? null: () => _pickImageFromGallery(context),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload, size: 40, color: Theme.of(context).primaryColor),
                        const SizedBox(height: 10),
                        const Text(
                          'Select an image to analyze',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (isImageSelected && !_imageSent)
                  ? () => _sendImage(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.blueGrey.shade200,
                disabledForegroundColor: Colors.white70,
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              ),
              child: Text(
                _imageSent ? 'Image sent' : 'Send image',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _imageSent
                  ? () {
                // Acción para ver el análisis
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _imageSent
                    ? Theme.of(context).primaryColor
                    : Colors.blueGrey,
              ),
              child: const Text(
                'View Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }
}