import 'package:flutter/material.dart';

class GreenhouseCard extends StatelessWidget {
  final String title;
  const GreenhouseCard({super.key, required this.title});

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
                  builder: (context) => _AddGreenhouseDialog(
                    initialName: title,
                    isEdit: true,
                  ),
                );
              }
              // TODO: VALIDAR SI SIRVE PARA ELIMIAR
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

class _AddGreenhouseDialog extends StatelessWidget {
  final String initialName;
  final bool isEdit;

  const _AddGreenhouseDialog({
    required this.initialName,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Editar Invernadero' : 'Agregar Invernadero'),
      content: TextField(
        controller: TextEditingController(text: initialName),
        decoration: const InputDecoration(
          labelText: 'Nombre del invernadero',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // TODO: AGREGAR LOGICA PARA GUARDAR INVERNADERO
            Navigator.of(context).pop();
          },
          child: Text(isEdit ? 'Guardar' : 'Agregar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
