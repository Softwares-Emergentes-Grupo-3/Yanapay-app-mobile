class Greenhouse {
  final int id;
  final String name;
  final String plantingDate;

  Greenhouse({
    required this.id,
    required this.name,
    required this.plantingDate,
  });

  factory Greenhouse.fromJson(Map<String, dynamic> json) {
    return Greenhouse(
      id: json['id'],
      name: json['name'],
      plantingDate: json['plantingDate'],
    );
  }
}
