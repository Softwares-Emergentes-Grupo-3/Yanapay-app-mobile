import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanapay_app_mobile/providers/auth_provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            const Spacer(),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return IconButton(
                  onPressed: () {
                    _showUserMenu(context, authProvider);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: colors.primary.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: colors.primary.withOpacity(0.3),
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.person,
                    color: colors.primary,
                    size: 28,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context, AuthProvider authProvider) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del usuario
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.primary,
                    child: Icon(
                      Icons.person,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userName ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authProvider.userEmail ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),

              // Opciones del menú
              ListTile(
                leading: Icon(Icons.settings, color: colors.onSurface),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Configuración - Funcionalidad en desarrollo'),
                    ),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.logout, color: colors.error),
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: colors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context, authProvider);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog(
      BuildContext context, AuthProvider authProvider) async {
    final colors = Theme.of(context).colorScheme;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: colors.onSurface),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(color: colors.error),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
