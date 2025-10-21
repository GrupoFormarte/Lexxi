import 'dart:convert';

import 'package:lexxi/config/env_config.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class ApiService {
  // Las URLs ahora se obtienen desde las variables de entorno
  String get baseUrl => EnvConfig.baseUrl;
  String get baseUrl2 => EnvConfig.baseUrl2;

  bool _tokenLoaded = false;

  ApiService();

  /// Ensure token is loaded before making requests
  Future<void> _ensureTokenLoaded() async {
    if (!_tokenLoaded) {
      await EnvConfig.loadTokenForMongo();
      _tokenLoaded = true;
    }
  }

  Future<Map<String, dynamic>?> create({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    await _ensureTokenLoaded();
    final response = await http.post(
      Uri.parse('$baseUrl/$collectionName'),
      headers: EnvConfig.defaultHeaders,
      body: jsonEncode({"data": data}),
    );
    print(['CREATE -- $baseUrl/$collectionName']);
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> createWithId({
    required String collectionName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _ensureTokenLoaded();
    final response = await http.post(
      Uri.parse('$baseUrl/$collectionName/$id'),
      headers: EnvConfig.defaultHeaders,
      body: jsonEncode(data),
    );
    print(['CRATE-BY-ID -- $baseUrl/$collectionName/$id']);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> post({
    required Map<String, dynamic> data,
    required String endPoint,
  }) async {
    await _ensureTokenLoaded();
    final response = await http.post(
      Uri.parse('$baseUrl/$endPoint'),
      headers: EnvConfig.defaultHeaders,
      body: json.encode(data),
    );
    print('POST -- $baseUrl/$endPoint');
    final resp = response.body;
    print(  ['RESPONSE-POST', resp]);
    return json.decode(resp);
  }

  Future<List<Map<String, dynamic>>> getAll({
    required String nameCollection,
  }) async {
    await _ensureTokenLoaded();
    final response = await http.get(
      Uri.parse('$baseUrl/$nameCollection'),
      headers: EnvConfig.defaultHeaders,
    );
    print('$baseUrl/$nameCollection');
print(json.decode(response.body));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      logger.e('Failed to load items');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getById({
    required String collectionName,
    required String id,
  }) async {
    await _ensureTokenLoaded();
    final response = await http.get(
      Uri.parse('$baseUrl/$collectionName/$id'),
      headers: EnvConfig.defaultHeaders,
    );
    // print(EnvConfig.defaultHeaders);
    print('GETBYID -- $baseUrl/$collectionName/$id');
print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return null;
    }
  }

  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    required String nameCollection,
  }) async {
    await _ensureTokenLoaded();
    final response = await http.put(
      Uri.parse('$baseUrl/$nameCollection/$id'),
      headers: EnvConfig.defaultHeaders,
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  Future<bool> delete(String collectionName, String id) async {
    await _ensureTokenLoaded();
    final response = await http.delete(
      Uri.parse('$baseUrl/$collectionName/$id'),
      headers: EnvConfig.defaultHeaders,
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>?> getAllBy(
    String collectionName,
    String category,
  ) async {
    await _ensureTokenLoaded();
    final response = await http.get(
      Uri.parse('$baseUrl/$collectionName/category/$category'),
      headers: EnvConfig.defaultHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> searchByField(
    String collectionName,
    String field,
    String value,
  ) async {
    try {
      await _ensureTokenLoaded();
      final response = await http.get(
        Uri.parse('$baseUrl/$collectionName/search/$field/$value'),
        headers: EnvConfig.defaultHeaders,
      );

      print(  ['SEARCH-BY-FIELD -- $baseUrl/$collectionName/search/$field/$value']);

      if ((response.statusCode == 200) || (response.statusCode == 200)) {
        return jsonDecode(response.body)['data'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getDataApi() async {
    await _ensureTokenLoaded();
    final Uri url = Uri.parse('$baseUrl2/module/programs/');
    final response = await http.get(
      url,
      headers: EnvConfig.defaultHeaders,
      // body: jsonEncode(data),
    );
    final respon = jsonDecode(response.body)['data'];
    if (response.statusCode == 200 || response.statusCode == 201) {
      return respon[0]['program'];
    }
    return [];
  }

  Future<List<dynamic>> getAllItemsStateAndCity(String endPoint) async {
    await _ensureTokenLoaded();
    final Uri url = Uri.parse('https://api-colombia.com/api/v1/Department/$endPoint');
    final response = await http.get(
      url,
      headers: EnvConfig.defaultHeaders,
      // body: jsonEncode(data),
    );
    final respon = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return respon;
    }
    return [];
  }

  Future<List<dynamic>?> searchByFields({
    required String collectionName,
    required String query,
    required List<String> fields,
  }) async {
    await _ensureTokenLoaded();
    final queryString = fields.join(',');
    final response = await http.get(
      Uri.parse(
        '$baseUrl/$collectionName/multi-search/$query?fields=$queryString',
      ),
      headers: EnvConfig.defaultHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return null;
    }
  }
}
