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
              Flexible(
                child: ListView(
                  children: [
                    const _DeviceCard(name: 'XFDFDGS'),
                    const SizedBox(height: 12),
                    const _DeviceCard(name: 'fdf23-23948'),
                    const _DeviceCard(name: 'XFDFDGS'),
                    const SizedBox(height: 12),
                    const _DeviceCard(name: 'fdf23-23948'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Actions buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const OperationsModal(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Operations'),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: colors.secondary.withOpacity(0.7),
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
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

// --- Operations Modal and Components ---

class OperationsModal extends StatefulWidget {
  const OperationsModal({super.key});

  @override
  State<OperationsModal> createState() => _OperationsModalState();
}

class _OperationsModalState extends State<OperationsModal> {
  int _tabIndex = 0;
  bool _irrigationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _OperationsTabs(
                  tabIndex: _tabIndex,
                  onTabChanged: (i) => setState(() => _tabIndex = i),
                ),
                const SizedBox(height: 16),
                _IrrigationControl(
                  enabled: _irrigationEnabled,
                  onChanged: (v) => setState(() => _irrigationEnabled = v),
                  mode: _tabIndex == 0 ? 'humidity' : 'fungicide',
                ),
                const SizedBox(height: 24),
                _IrrigationHistoryButton(
                    mode: _tabIndex == 0 ? 'humidity' : 'fungicide'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OperationsTabs extends StatelessWidget {
  final int tabIndex;
  final ValueChanged<int> onTabChanged;
  const _OperationsTabs({required this.tabIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TabButton(
          label: 'Humidity',
          selected: tabIndex == 0,
          onTap: () => onTabChanged(0),
        ),
        const SizedBox(width: 12),
        _TabButton(
          label: 'Fungicide',
          selected: tabIndex == 1,
          onTap: () => onTabChanged(1),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.white,
          border: Border.all(color: colors.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _IrrigationControl extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final String mode; // 'humidity' or 'fungicide'
  const _IrrigationControl(
      {required this.enabled, required this.onChanged, required this.mode});

  @override
  Widget build(BuildContext context) {
    final isHumidity = mode == 'humidity';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isHumidity ? 'Irrigation Control' : 'Fumigate Control',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8EDB00),
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isHumidity ? 'Enabled Irrigation' : 'Enabled Fumigate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 16),
            Switch(
              value: enabled,
              onChanged: onChanged,
              activeColor: const Color(0xFF8EDB00),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.white,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: enabled ? const Color(0xFF8EDB00) : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                enabled ? 'Active' : 'Inactive',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FFD7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isHumidity
                ? 'Allow the system to activate irrigation\nbased on soil moisture levels.'
                : 'Allow the system to activate fumigation\nbased on system rules.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF8EDB00), fontSize: 15),
          ),
        ),
      ],
    );
  }
}

class _IrrigationHistoryButton extends StatelessWidget {
  final String mode; // 'humidity' or 'fungicide'
  const _IrrigationHistoryButton({this.mode = 'humidity'});

  @override
  Widget build(BuildContext context) {
    final isHumidity = mode == 'humidity';
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8EDB00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          // TODO: Implement history logic
        },
        child: Text(
          isHumidity ? 'See irrigation history' : 'See fumigation history',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
