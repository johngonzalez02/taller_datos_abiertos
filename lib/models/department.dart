import 'city.dart';
import 'json_helpers.dart';

/// Endpoint: GET /api/v1/Department
class Department {
  final int id;
  final String name;
  final String description;
  final int? municipalities;
  final int? surface;
  final int? population;
  final String phonePrefix;
  final int? regionId;
  final City? cityCapital;

  const Department({
    required this.id,
    required this.name,
    this.description = '',
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix = '',
    this.regionId,
    this.cityCapital,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    final capital = json['cityCapital'];
    return Department(
      id: asInt(json['id']) ?? 0,
      name: asString(json['name']),
      description: asString(json['description']),
      municipalities: asInt(json['municipalities']),
      surface: asInt(json['surface']),
      population: asInt(json['population']),
      phonePrefix: asString(json['phonePrefix']),
      regionId: asInt(json['regionId']),
      cityCapital:
          capital is Map<String, dynamic> ? City.fromJson(capital) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'municipalities': municipalities,
        'surface': surface,
        'population': population,
        'phonePrefix': phonePrefix,
        'regionId': regionId,
        'cityCapital': cityCapital?.toJson(),
      };
}
