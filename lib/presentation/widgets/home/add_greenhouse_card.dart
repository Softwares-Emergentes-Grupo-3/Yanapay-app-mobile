import 'package:flutter/material.dart';

class AddGreenhouseCard extends StatelessWidget {
  const AddGreenhouseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const _AddGreenhouseDialog(),
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

class _AddGreenhouseDialog extends StatefulWidget {
  final String? initialName;
  final String? initialDate;
  final bool isEdit;
  const _AddGreenhouseDialog(
      {this.initialName, this.initialDate, this.isEdit = false});

  @override
  State<_AddGreenhouseDialog> createState() => _AddGreenhouseDialogState();
}

class _AddGreenhouseDialogState extends State<_AddGreenhouseDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _date;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _date = widget.initialDate;
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
                                _date =
                                    "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(text: _date),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // TODO: GUARDADO DE DATOS
                        Navigator.of(context).pop();
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
