import '../models/department.dart';
import '../models/president.dart';
import '../models/region.dart';
import '../models/touristic_attraction.dart';
import 'api_client.dart';

/// Servicio que expone los endpoints de API Colombia usados por la app.
/// Es un singleton para que toda la app comparta la misma cache.
class ColombiaService {
  ColombiaService._(this._api);

  static final ColombiaService instance = ColombiaService._(ApiClient());

  final ApiClient _api;

  Future<List<Department>> getDepartments({bool forceRefresh = false}) =>
      _api.getList('Department', Department.fromJson,
          forceRefresh: forceRefresh);

  Future<List<Region>> getRegions({bool forceRefresh = false}) =>
      _api.getList('Region', Region.fromJson, forceRefresh: forceRefresh);

  Future<List<President>> getPresidents({bool forceRefresh = false}) =>
      _api.getList('President', President.fromJson,
          forceRefresh: forceRefresh);

  Future<List<TouristicAttraction>> getTouristicAttractions(
          {bool forceRefresh = false}) =>
      _api.getList('TouristicAttraction', TouristicAttraction.fromJson,
          forceRefresh: forceRefresh);
}
