import 'json_helpers.dart';

/// Endpoint: GET /api/v1/Region
class Region {
  final int id;
  final String name;
  final String description;

  const Region({
    required this.id,
    required this.name,
    this.description = '',
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: asInt(json['id']) ?? 0,
      name: asString(json['name']),
      description: asString(json['description']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
