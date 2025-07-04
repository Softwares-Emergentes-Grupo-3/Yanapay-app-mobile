import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GreenhouseCard extends StatelessWidget {
  final String id;
  final String title;
  final VoidCallback onRefresh;

  const GreenhouseCard({
    super.key,
    required this.id,
    required this.title,
    required this.onRefresh,
  });

  Future<void> _deleteGreenhouse(BuildContext context) async {
    final url = Uri.parse('http://172.203.140.239:8081/api/v1/greenhouses/$id');

    final response = await http.delete(url);
    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invernadero eliminado')),

      );
      print('Response: ${response.body}');
      onRefresh();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar')),
      );
    }
  }

  Future<void> _editGreenhouse(
      BuildContext context, String newName) async {
    final url = Uri.parse('http://172.203.140.239:8081/api/v1/greenhouses');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': int.parse(id),
        'name': newName}),
    );
    print('Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invernadero actualizado')),
      );
      onRefresh();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al editar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.primary.withAlpha(220),
                colors.tertiary.withGreen(200).withAlpha(200),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.bar_chart, color: colors.secondary),
                ),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            onSelected: (value) {
              if (value == 'edit') {
                showDialog(
                  context: context,
                  builder: (context) => _EditDialog(
                    initialName: title,
                    onConfirm: (newName) => _editGreenhouse(context, newName),
                  ),
                );
              } else if (value == 'delete') {
                _deleteGreenhouse(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF909EC4)),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: colors.error),
                    const SizedBox(width: 8),
                    const Text('Eliminar'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditDialog extends StatefulWidget {
  final String initialName;
  final Function(String newName) onConfirm;

  const _EditDialog({
    required this.initialName,
    required this.onConfirm,
  });

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Invernadero'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del invernadero',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await widget.onConfirm(_controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}