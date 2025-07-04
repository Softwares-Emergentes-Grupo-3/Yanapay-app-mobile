import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddGreenhouseCard extends StatelessWidget {
  final VoidCallback? onGreenhouseAdded;
  const AddGreenhouseCard({super.key, this.onGreenhouseAdded}); // <-- aquí

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _AddGreenhouseDialog(
            onGreenhouseAdded: onGreenhouseAdded,
          ),
        );
      },
      child: Container(
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
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: colors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

// En la clase _AddGreenhouseDialog
class _AddGreenhouseDialog extends StatefulWidget {
  final String? initialName;
  final String? initialDate;
  final bool isEdit;
  final VoidCallback? onGreenhouseAdded;

  const _AddGreenhouseDialog({
    this.initialName,
    this.initialDate,
    this.isEdit = false,
    this.onGreenhouseAdded,
  });

  @override
  State<_AddGreenhouseDialog> createState() => _AddGreenhouseDialogState();
}

class _AddGreenhouseDialogState extends State<_AddGreenhouseDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _date; // Formato para backend: yyyy-MM-dd
  String? _dateDisplay; // Formato para usuario: dd/MM/yyyy

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _date = widget.initialDate;
    if (_date != null && _date!.isNotEmpty) {
      // Si viene en formato yyyy-MM-dd, convertir a dd/MM/yyyy
      final parts = _date!.split('-');
      if (parts.length == 3) {
        _dateDisplay =
        '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
      }
    }
  }

  Future<void> _saveGreenhouse() async {
    final url = Uri.parse('http://172.203.140.239:8081/api/v1/greenhouses');

    final userId = 10; // TODO: Reemplaza con el ID real del usuario

    final body = jsonEncode({
      'name': _name,
      'plantingDate': _date,
      'userId': userId,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Invernadero guardado: $data');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invernadero guardado con éxito')),
      );
    } else {
      throw Exception('Error al guardar el invernadero: ${response.body}');
    }
  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 350,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 32),
                      Text(
                        widget.isEdit
                            ? 'Edit Greenhouse'
                            : 'Add New Greenhouse',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      // TODO: LOGICA IMAGENES
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F9D2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child:
                        Icon(Icons.upload, size: 48, color: colors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("Greenhouse' name"),
                        const SizedBox(height: 4),
                        TextFormField(
                          initialValue: _name,
                          decoration: const InputDecoration(
                            hintText: 'Enter name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onSaved: (value) => _name = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Text('Planting Date'),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _dateDisplay =
                                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                                _date = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller:
                              TextEditingController(text: _dateDisplay),
                              decoration: const InputDecoration(
                                hintText: 'DD/MM/YYYY',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              validator: (value) =>
                              (_date == null || _date!.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                      // En el método donde guardas el invernadero:
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            await _saveGreenhouse();
                            widget.onGreenhouseAdded?.call(); // <-- Llama aquí el callback
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al guardar: $e')),
                            );
                          }
                        }
                      },
                    child: Text(widget.isEdit ? 'Save' : 'Add',
                        style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}