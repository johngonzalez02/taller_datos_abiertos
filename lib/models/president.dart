import 'json_helpers.dart';

/// Endpoint: GET /api/v1/President
class President {
  final int id;
  final String name;
  final String lastName;
  final String image;
  final String? startPeriodDate; // formato "1887-06-04"
  final String? endPeriodDate; // null si aun esta en el cargo
  final String politicalParty;
  final String description;
  final int? cityId;

  const President({
    required this.id,
    required this.name,
    this.lastName = '',
    this.image = '',
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty = '',
    this.description = '',
    this.cityId,
  });

  factory President.fromJson(Map<String, dynamic> json) {
    return President(
      id: asInt(json['id']) ?? 0,
      name: asString(json['name']),
      lastName: asString(json['lastName']),
      image: asString(json['image']),
      startPeriodDate: json['startPeriodDate']?.toString(),
      endPeriodDate: json['endPeriodDate']?.toString(),
      politicalParty: asString(json['politicalParty']),
      description: asString(json['description']),
      cityId: asInt(json['cityId']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastName': lastName,
        'image': image,
        'startPeriodDate': startPeriodDate,
        'endPeriodDate': endPeriodDate,
        'politicalParty': politicalParty,
        'description': description,
        'cityId': cityId,
      };

  String get fullName => '$name $lastName'.trim();

  String _year(String? date) =>
      (date != null && date.length >= 4) ? date.substring(0, 4) : '';

  /// Ejemplo: "1887 - 1888" o "2022 - actualidad"
  String get periodLabel {
    final start = _year(startPeriodDate);
    final end = _year(endPeriodDate);
    if (start.isEmpty) return '';
    return '$start - ${end.isEmpty ? 'actualidad' : end}';
  }
}
