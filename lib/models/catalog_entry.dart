import 'department.dart';
import 'president.dart';
import 'region.dart';
import 'touristic_attraction.dart';

/// Formatea un entero con separador de miles estilo Colombia: 1234567 -> 1.234.567
String _number(int? value) {
  if (value == null) return '-';
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Representacion uniforme de un registro de cualquier endpoint.
/// Permite reutilizar una sola pantalla de Listado y una sola de Detalle.
class CatalogEntry {
  const CatalogEntry({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.imageUrl = '',
    this.description = '',
    this.details = const {},
  });

  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;

  /// Datos a mostrar en el detalle como pares etiqueta -> valor (conserva el orden).
  final Map<String, String> details;

  factory CatalogEntry.fromDepartment(Department d) {
    final capital = d.cityCapital?.name ?? '';
    return CatalogEntry(
      id: d.id,
      title: d.name,
      subtitle: capital.isEmpty ? '' : 'Capital: $capital',
      description: d.description,
      details: {
        'Capital': capital.isEmpty ? '-' : capital,
        'Población': _number(d.population),
        'Superficie': d.surface == null ? '-' : '${_number(d.surface)} km²',
        'Municipios': _number(d.municipalities),
        'Prefijo telefónico': d.phonePrefix.isEmpty ? '-' : d.phonePrefix,
      },
    );
  }

  factory CatalogEntry.fromRegion(Region r) {
    return CatalogEntry(
      id: r.id,
      title: r.name,
      subtitle: r.description,
      description: r.description,
      details: {'Código': '${r.id}'},
    );
  }

  factory CatalogEntry.fromPresident(President p) {
    final party = p.politicalParty.isEmpty ? '-' : p.politicalParty;
    return CatalogEntry(
      id: p.id,
      title: p.fullName,
      subtitle: p.periodLabel.isEmpty ? party : '${p.periodLabel}  ·  $party',
      imageUrl: p.image,
      description: p.description,
      details: {
        'Periodo': p.periodLabel.isEmpty ? '-' : p.periodLabel,
        'Partido político': party,
        'Inicio': p.startPeriodDate ?? '-',
        'Fin': p.endPeriodDate ?? '-',
      },
    );
  }

  factory CatalogEntry.fromAttraction(TouristicAttraction a) {
    final city = a.city?.name ?? '';
    return CatalogEntry(
      id: a.id,
      title: a.name,
      subtitle: city,
      imageUrl: a.firstImage,
      description: a.description,
      details: {
        'Ciudad': city.isEmpty ? '-' : city,
        'Latitud': a.latitude?.toString() ?? '-',
        'Longitud': a.longitude?.toString() ?? '-',
        'Imágenes disponibles': '${a.images.length}',
      },
    );
  }
}
