import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  static final _client = http.Client();
  static const _timeout = Duration(seconds: 60);

  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$kApiBase$endpoint');
    final response = await _client.get(uri).timeout(_timeout);
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    }
    throw Exception('Error ${response.statusCode}: $endpoint');
  }

  static Future<List<dynamic>> getPartidosHoy() =>
      get('/partidos/hoy').then((d) => d as List);

  static Future<List<dynamic>> getPartidosProximos({int dias = 20}) =>
      get('/partidos/proximos?dias=$dias').then((d) => d as List);

  static Future<List<dynamic>> getPartidosFecha(String fecha) =>
      get('/partidos/fecha/$fecha').then((d) => d as List);

  static Future<Map<String, dynamic>> getGrupo(String letra) =>
      get('/grupos/$letra').then((d) => d as Map<String, dynamic>);

  static Future<List<dynamic>> getHistorico() =>
      get('/historico/').then((d) => d as List);

  static Future<Map<String, dynamic>> getMundialDetalle(int anyo) =>
      get('/historico/$anyo').then((d) => d as Map<String, dynamic>);

  static Future<List<dynamic>> getSelecciones() =>
      get('/selecciones/').then((d) => d as List);

  static Future<Map<String, dynamic>> getSeleccionDetalle(int selId) =>
      get('/selecciones/$selId').then((d) => d as Map<String, dynamic>);

  static Future<Map<String, dynamic>> getClima(int estadioId) =>
      get('/clima/estadio/$estadioId').then((d) => d as Map<String, dynamic>);

  static Future<Map<String, dynamic>> getLive(int partidoId) =>
      get('/partidos/$partidoId/live').then((d) => d as Map<String, dynamic>);
}
