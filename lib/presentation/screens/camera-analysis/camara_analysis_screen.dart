import 'dart:io';
import 'dart:convert';
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
  Map<String, dynamic>? _analysisData;

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _imageSent = false;
        _analysisResult = null;
        _analysisData = null;
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
    final uri = Uri.parse(
        'http://yanapay-ia.gbgdenambygsefh6.eastus.azurecontainer.io:8000/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      setState(() {
        _analysisResult = responseBody;
        _analysisData = data;
      });
      return true;
    } else {
      setState(() {
        _analysisResult = 'Error al analizar la imagen.';
        _analysisData = null;
      });
      return false;
    }
  }

  Future<void> getRoot() async {
    final uri = Uri.parse('http://yanapay-ia.gbgdenambygsefh6.eastus.azurecontainer.io:8000/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('Root OK: ${response.body}');
    } else {
      print('Error en root: ${response.statusCode}');
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.8;
        return SizedBox(
          height: height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_pickedFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_pickedFile!.path),
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'RESULTADO DEL ANÁLISIS\n-------------------------------',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (_analysisData != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Predicción: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      Text(
                        _analysisData!['prediction'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Confianza: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      Text(
                        '${_analysisData!['confidence']}%',
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ] else
                  Text(
                    _analysisResult ?? 'Cargando análisis...',
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
              ],
            ),
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
                  onTap: isImageSelected
                      ? null
                      : () => _pickImageFromGallery(context),
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
                            isImageSelected
                                ? 'Image selected'
                                : 'Select an image to analyze',
                            style: TextStyle(
                              color: isImageSelected
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  _imageSent ? 'Image sent' : 'Send image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (isImageSelected && !_imageSent && !_isUploading)
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: _imageSent
                    ? () async {
                  await getRoot();
                  await _showAnalysisModal(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _imageSent ? green : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                ),
                child: Text(
                  'View Analysis',
                  style: TextStyle(
                    color: _imageSent ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }
}
