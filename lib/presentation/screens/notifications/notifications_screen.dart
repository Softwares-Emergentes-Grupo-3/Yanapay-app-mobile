import 'package:flutter/material.dart';
import 'package:yanapay_app_mobile/presentation/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  static const String name = 'notifications-screen';

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _NotificationsView(),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: 2),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildNotificationsList(colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(ColorScheme colors) {
    // Lista de notificaciones de ejemplo
    final notifications = [
      {
        'title': 'Riego completado',
        'message':
            'El sistema de riego del invernadero A se ha completado exitosamente.',
        'time': '2 min',
        'icon': Icons.water_drop,
        'color': colors.primary,
      },
      {
        'title': 'Temperatura alta',
        'message': 'La temperatura en el invernadero B ha superado los 30°C.',
        'time': '15 min',
        'icon': Icons.thermostat,
        'color': colors.error,
      },
      {
        'title': 'Análisis completado',
        'message': 'El análisis de la planta de tomate ha sido procesado.',
        'time': '1 hora',
        'icon': Icons.analytics,
        'color': colors.secondary,
      },
      {
        'title': 'Recordatorio',
        'message': 'Es hora de revisar el sistema de ventilación.',
        'time': '2 horas',
        'icon': Icons.schedule,
        'color': colors.tertiary,
      },
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification['color'] as Color,
              child: Icon(
                notification['icon'] as IconData,
                color: Colors.white,
              ),
            ),
            title: Text(
              notification['title'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            subtitle: Text(
              notification['message'] as String,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.7),
              ),
            ),
            trailing: Text(
              notification['time'] as String,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            onTap: () {
              // Aquí se puede agregar la lógica para mostrar detalles de la notificación
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notificación: ${notification['title']}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
