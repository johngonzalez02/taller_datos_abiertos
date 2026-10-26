import 'city.dart';
import 'json_helpers.dart';

/// Endpoint: GET /api/v1/TouristicAttraction
class TouristicAttraction {
  final int id;
  final String name;
  final String description;
  final List<String> images;
  final double? latitude; // la API la envia como texto
  final double? longitude; // la API la envia como texto
  final int? cityId;
  final City? city;

  const TouristicAttraction({
    required this.id,
    required this.name,
    this.description = '',
    this.images = const [],
    this.latitude,
    this.longitude,
    this.cityId,
    this.city,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final cityJson = json['city'];
    return TouristicAttraction(
      id: asInt(json['id']) ?? 0,
      name: asString(json['name']),
      description: asString(json['description']),
      images: rawImages is List
          ? rawImages.map((e) => e.toString()).toList()
          : const [],
      latitude: asDouble(json['latitude']),
      longitude: asDouble(json['longitude']),
      cityId: asInt(json['cityId']),
      city: cityJson is Map<String, dynamic> ? City.fromJson(cityJson) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'images': images,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'city': city?.toJson(),
      };

  String get firstImage => images.isNotEmpty ? images.first : '';
}
