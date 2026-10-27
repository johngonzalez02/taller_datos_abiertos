import 'package:flutter/material.dart';

import '../models/catalog_entry.dart';
import '../services/colombia_service.dart';

typedef EntryLoader = Future<List<CatalogEntry>> Function({bool forceRefresh});

/// Describe un endpoint de API Colombia que aparece como card en el Dashboard.
class Dataset {
  const Dataset({
    required this.key,
    required this.title,
    required this.endpoint,
    required this.description,
    required this.icon,
    required this.color,
    required this.load,
  });

  /// Identificador usado en la URL de go_router (ej. /lista/departamentos).
  final String key;
  final String title;

  /// Nombre del endpoint en la API (ej. Department).
  final String endpoint;
  final String description;
  final IconData icon;
  final Color color;
  final EntryLoader load;
}

final ColombiaService _service = ColombiaService.instance;

final List<Dataset> datasets = [
  Dataset(
    key: 'departamentos',
    title: 'Departamentos',
    endpoint: 'Department',
    description:
        'Departamentos de Colombia con su capital, población y superficie.',
    icon: Icons.map_outlined,
    color: const Color(0xFF003893),
    load: ({bool forceRefresh = false}) async {
      final items = await _service.getDepartments(forceRefresh: forceRefresh);
      final entries = items.map(CatalogEntry.fromDepartment).toList();
      entries.sort((a, b) => a.title.compareTo(b.title));
      return entries;
    },
  ),
  Dataset(
    key: 'regiones',
    title: 'Regiones',
    endpoint: 'Region',
    description: 'Las regiones naturales del país y sus particularidades.',
    icon: Icons.landscape_outlined,
    color: const Color(0xFF2E7D32),
    load: ({bool forceRefresh = false}) async {
      final items = await _service.getRegions(forceRefresh: forceRefresh);
      final entries = items.map(CatalogEntry.fromRegion).toList();
      entries.sort((a, b) => a.title.compareTo(b.title));
      return entries;
    },
  ),
  Dataset(
    key: 'presidentes',
    title: 'Presidentes',
    endpoint: 'President',
    description: 'Presidentes de Colombia con su periodo y partido político.',
    icon: Icons.account_balance_outlined,
    color: const Color(0xFFCE1126),
    load: ({bool forceRefresh = false}) async {
      final items = await _service.getPresidents(forceRefresh: forceRefresh);
      items.sort((a, b) => (a.startPeriodDate ?? '9999')
          .compareTo(b.startPeriodDate ?? '9999'));
      return items.map(CatalogEntry.fromPresident).toList();
    },
  ),
  Dataset(
    key: 'atracciones',
    title: 'Atracciones turísticas',
    endpoint: 'TouristicAttraction',
    description: 'Lugares turísticos para conocer, con su ciudad y ubicación.',
    icon: Icons.photo_camera_outlined,
    color: const Color(0xFFF9A825),
    load: ({bool forceRefresh = false}) async {
      final items =
          await _service.getTouristicAttractions(forceRefresh: forceRefresh);
      final entries = items.map(CatalogEntry.fromAttraction).toList();
      entries.sort((a, b) => a.title.compareTo(b.title));
      return entries;
    },
  ),
];

/// Busca un dataset por su key; devuelve null si no existe.
Dataset? datasetByKey(String key) {
  for (final dataset in datasets) {
    if (dataset.key == key) return dataset;
  }
  return null;
}
