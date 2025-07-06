import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yanapay_app_mobile/presentation/widgets/greenhouse/add_device_modal.dart';
import 'package:yanapay_app_mobile/presentation/widgets/greenhouse/delete_device_alert.dart';
import 'package:yanapay_app_mobile/presentation/widgets/greenhouse/operation_modal.dart';

class GreenhouseScreen extends StatefulWidget {
  final int greenhouseId;
  final String greenhouseName;
  const GreenhouseScreen({super.key, required this.greenhouseName, required this.greenhouseId});

  @override
  State<GreenhouseScreen> createState() => _GreenhouseScreenState();
}

class _GreenhouseScreenState extends State<GreenhouseScreen> {
  Future<Map<String, dynamic>> fetchMonitoringData() async {
    final response = await http.get(
      Uri.parse('http://172.203.140.239:8082/api/v1/monitoringreport/get-by-greenhouseid?id=${widget.greenhouseId}'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar datos: ${response.body}');
    }
  }

  Future<List<String>> fetchDevices() async {
    final url = 'http://172.203.140.239:8081/api/v1/greenhouses/${widget.greenhouseId}/devices';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic> devices = jsonBody['data'];
      print('Status code: ${response.statusCode} - Response body: ${response.body}');
      return devices.map((e) => e['deviceCode'].toString()).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error al cargar dispositivos: ${response.body}');
    }
  }

  Future<void> deleteDevice(String deviceCode) async {
    final url = 'http://172.203.140.239:8081/api/v1/linking-devices/unlink';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'deviceCode': deviceCode}),
    );

    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print('Error al eliminar: ${response.statusCode} - ${response.body}');
      throw Exception('Error al eliminar dispositivo');
    }
  }


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
              _CustomGreenhouseBar(greenhouseName: widget.greenhouseName),
              const SizedBox(height: 30),
              // Card de detalles
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 20),
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
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Humedad y temperatura desde la API
                    FutureBuilder<Map<String, dynamic>>(
                      future: fetchMonitoringData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          print('snapshot error: ${snapshot.error}');
                          return const Text('Error al cargar datos');
                        }
                        final data = snapshot.data ?? {};
                        final humidity = data['humidity']?.toString() ?? '--';
                        final temp = data['temperature']?.toString() ?? '--';
                        print('humidity: $humidity - temp: $temp');

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.water_drop, color: colors.primary, size: 25),
                            const SizedBox(width: 10),
                            Text('$humidity%',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
                            const SizedBox(width: 20),
                            Icon(Icons.thermostat, color: colors.secondary, size: 25),
                            const SizedBox(width: 5),
                            Text('$temp°',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Text('Estado',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Spacer(),
                        Icon(Icons.circle, color: Colors.green, size: 14),
                        SizedBox(width: 4),
                        Text('En línea',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text('Carga de batería',
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
              const SizedBox(height: 20),
              // Devices title
              Row(
                children: [
                  Icon(Icons.spa, color: colors.secondary),
                  const SizedBox(width: 8),
                  const Text('Dispositivos',
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              // Devices list dinámica
              Flexible(
                child: FutureBuilder<List<String>>(
                  future: fetchDevices(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text('Error al cargar dispositivos');
                    }
                    final devices = snapshot.data ?? [];
                    return ListView.separated(
                      itemCount: devices.length,
                      itemBuilder: (context, index) => _DeviceCard(
                        name: devices[index],
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteDeviceAlert(
                              onConfirm: () async {
                                Navigator.of(context).pop();
                                await deleteDevice(devices[index]);
                              },
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                    );
                  },
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
                        builder: (context) => OperationsModal(greenhouseId: widget.greenhouseId),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 12),
                    ),
                    child: const Text('Operaciones',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Añadir dispositivo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => AddDeviceModal(greenhouseId: widget.greenhouseId),
                      );
                      if (result == true) {
                        setState(() {}); // Recarga la lista de dispositivos
                      }
                    },
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
  final VoidCallback onDelete;
  const _DeviceCard({required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 15, right: 5, top: 2, bottom: 2),
        leading: CircleAvatar(
          backgroundColor: colors.tertiary,
          child: const Icon(Icons.online_prediction_sharp, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _CustomGreenhouseBar extends StatelessWidget {
  final String greenhouseName;
  const _CustomGreenhouseBar({required this.greenhouseName});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 5, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: colors.tertiary.withAlpha(185).withBlue(50).withRed(160),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 0),
          Text(greenhouseName,
              style:
              TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              )),
        ],
      ),
    );
  }
}