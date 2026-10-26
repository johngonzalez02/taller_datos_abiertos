// Funciones auxiliares para leer valores del JSON de forma segura.
// La API a veces devuelve numeros como texto (ej. latitude: "5.88")
// o campos en null, por eso no se usa un cast directo.

int? asInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String asString(dynamic value) => value?.toString() ?? '';
