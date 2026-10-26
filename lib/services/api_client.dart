import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/env.dart';

/// Error controlado de la capa de servicios. Su mensaje se puede
/// mostrar directamente al usuario en el estado "error" de la UI.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Cliente HTTP generico con cache en memoria.
///
/// La API publica limita algunos endpoints a 60 solicitudes por minuto
/// por IP y sus datos cambian poco, por eso cada lista se guarda en
/// memoria la primera vez que se pide.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  /// Hace GET a `{API_BASE_URL}/{endpoint}` y convierte cada elemento
  /// del arreglo JSON con [fromJson].
  Future<List<T>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.containsKey(endpoint)) {
      return _cache[endpoint]!.map(fromJson).toList();
    }

    final uri = Uri.parse('${Env.apiBaseUrl}/$endpoint');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is! List) {
          throw const ApiException('La respuesta del servidor no tiene el formato esperado.');
        }
        final items = decoded.whereType<Map<String, dynamic>>().toList();
        _cache[endpoint] = items;
        return items.map(fromJson).toList();
      }

      if (response.statusCode == 429) {
        throw const ApiException(
            'Demasiadas solicitudes. Espera un minuto e intenta de nuevo.');
      }
      throw ApiException(
          'El servidor respondio con un error (${response.statusCode}).');
    } on SocketException {
      throw const ApiException('Sin conexion a internet. Revisa tu red.');
    } on TimeoutException {
      throw const ApiException('El servidor tardo demasiado en responder.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor.');
    } on FormatException {
      throw const ApiException('No se pudo interpretar la respuesta del servidor.');
    }
  }
}
