import 'dart:io';
import 'package:http/http.dart' as http;
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
  bool _isUploading = false;
  String? _analysisResult;

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _imageSent = false;
        _analysisResult = null;
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

  Future<bool> _uploadImage(File imageFile) async {
    final uri = Uri.parse('http://yanapay-ia.gbgdenambygsefh6.eastus.azurecontainer.io:8000/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      // Simula obtener el análisis del API (ajusta según tu API)
      setState(() {
        _analysisResult = 'Análisis recibido del API (simulado).';
      });
      return true;
    } else {
      setState(() {
        _analysisResult = 'Error al analizar la imagen.';
      });
      return false;
    }
  }

  Future<void> _sendImage(BuildContext context) async {
    if (_pickedFile == null) return;
    setState(() {
      _isUploading = true;
    });
    final success = await _uploadImage(File(_pickedFile!.path));
    setState(() {
      _imageSent = success;
      _isUploading = false;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? '¡Éxito!' : 'Error'),
        content: Text(success
            ? 'La imagen se ha enviado correctamente.'
            : 'Error al enviar la imagen.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Future<void> _showAnalysisModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_pickedFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_pickedFile!.path),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Resultado del análisis:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _analysisResult ?? 'Cargando análisis...',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isImageSelected = _pickedFile != null;
    final Color green = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: GestureDetector(
                  onTap: isImageSelected ? null : () => _pickImageFromGallery(context),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: isImageSelected ? Colors.grey.shade200 : Colors.white,
                      border: Border.all(
                        color: isImageSelected ? Colors.grey : green,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 40,
                            color: isImageSelected ? Colors.grey : green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isImageSelected ? 'Image selected' : 'Select an image to analyze',
                            style: TextStyle(
                              color: isImageSelected ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: (isImageSelected && !_imageSent && !_isUploading)
                    ? () => _sendImage(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isImageSelected && !_imageSent && !_isUploading)
                      ? green
                      : Colors.blueGrey.shade200,
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                ),
                child: _isUploading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : Text(
                  _imageSent ? 'Image sent' : 'Send image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (isImageSelected && !_imageSent && !_isUploading)
                        ? Colors.white
                        : Colors.blueGrey.shade200,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _imageSent
                    ? () => _showAnalysisModal(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _imageSent ? green : Colors.blueGrey,
                  disabledBackgroundColor: green,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                ),
                child: Text(
                  'View Analysis',
                  style: TextStyle(
                    color: _imageSent ? Colors.white : Colors.blueGrey.shade200,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }
}