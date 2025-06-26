import 'package:flutter/material.dart';

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
