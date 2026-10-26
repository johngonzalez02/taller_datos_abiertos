import 'json_helpers.dart';

/// Ciudad. Se reutiliza como capital de un Department y como ciudad
/// de una TouristicAttraction.
class City {
  final int id;
  final String name;
  final String description;
  final int? surface;
  final int? population;
  final String postalCode;
  final int? departmentId;

  const City({
    required this.id,
    required this.name,
    this.description = '',
    this.surface,
    this.population,
    this.postalCode = '',
    this.departmentId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: asInt(json['id']) ?? 0,
      name: asString(json['name']),
      description: asString(json['description']),
      surface: asInt(json['surface']),
      population: asInt(json['population']),
      postalCode: asString(json['postalCode']),
      departmentId: asInt(json['departmentId']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'surface': surface,
        'population': population,
        'postalCode': postalCode,
        'departmentId': departmentId,
      };
}
