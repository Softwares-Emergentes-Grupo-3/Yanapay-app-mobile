import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yanapay_app_mobile/presentation/screens/screens.dart';
import 'package:yanapay_app_mobile/presentation/widgets/widgets.dart';
import 'package:yanapay_app_mobile/presentation/models/greenhouse_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreenhouseGrid extends StatefulWidget {
  const GreenhouseGrid({super.key});

  @override
  State<GreenhouseGrid> createState() => _GreenhouseGridState();
}

class _GreenhouseGridState extends State<GreenhouseGrid> {
  List<Greenhouse> greenhouses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGreenhouses();
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> fetchGreenhouses() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('No hay invernaderos del usuario');
      }

      final response = await http.get(
          Uri.parse('http://172.203.140.239:8081/api/v1/greenhouses/by-user/$userId'),
          headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        print('Datos recibidos:');
        print(data);

        setState(() {
          greenhouses =
              data.map((item) => Greenhouse.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los invernaderos');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Icon(Icons.spa, color: colors.secondary),
            const SizedBox(width: 8),
            const Text('Invernaderos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 0),

        isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            ...greenhouses.map((gh) {
              return GestureDetector(
                onTap: () {
                  print('Invernadero seleccionado: ${gh.name} - ${gh.id}');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GreenhouseScreen(greenhouseId: gh.id, greenhouseName: gh.name),
                    ),
                  );
                },
                child: GreenhouseCard(
                  id: gh.id, // Corregido: convertir a String
                  title: gh.name,
                  onRefresh: fetchGreenhouses,
                ),
              );
            }).toList(),
            // Tarjeta para agregar nuevo invernadero
            AddGreenhouseCard(onGreenhouseAdded: fetchGreenhouses),
          ],
        ),
      ],
    );
  }
}