import 'package:flutter/material.dart';

class GreenhouseScreen extends StatelessWidget {
  final String greenhouseId;
  const GreenhouseScreen({super.key, required this.greenhouseId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CustomGreenhouseBar(),
              const SizedBox(height: 20),
              // Card de detalles
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F9D2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFB6E388), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Detalles',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        PopupMenuButton<String>(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.black),
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
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Humedad y temperatura centrados
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop, color: colors.primary, size: 20),
                        const SizedBox(width: 4),
                        const Text('95%',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 24),
                        Icon(Icons.thermostat,
                            color: colors.secondary, size: 20),
                        const SizedBox(width: 4),
                        const Text('25° - 32°',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text('Status',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Spacer(),
                        Icon(Icons.circle, color: Colors.green, size: 14),
                        SizedBox(width: 4),
                        Text('Online',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Text('Charge',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Spacer(),
                        Icon(Icons.battery_full, color: Colors.black, size: 18),
                        SizedBox(width: 4),
                        Text('98%',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Devices title
              Row(
                children: [
                  Icon(Icons.spa, color: colors.secondary),
                  const SizedBox(width: 8),
                  const Text('Devices',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              // Devices list
              Expanded(
                child: ListView(
                  children: [
                    const _DeviceCard(name: 'XFDFDGS'),
                    const SizedBox(height: 12),
                    const _DeviceCard(name: 'fdf23-23948'),
                    const SizedBox(height: 24),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFE9F9D2),
                        radius: 28,
                        child: Icon(Icons.add, color: colors.primary, size: 32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String name;
  const _DeviceCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primary,
          child: const Icon(Icons.thermostat, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _CustomGreenhouseBar extends StatelessWidget {
  const _CustomGreenhouseBar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.tertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const Text('Trigo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}
