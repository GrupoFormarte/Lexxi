import 'dart:convert';

import 'package:lexxi/utils/loogers_custom.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class ApiService {
  // String sU = "https://dev-mongo.plataformapodium.com";
  String baseUrl = 'https://app.formarte.co/api';
  // String baseUrl2 = "https://api.formarte.co/api";
  // String baseUrl = 'https://dev-mongo.plataformapodium.com/api';
  String baseUrl2 = "https://api.formarte.co/api";

  ApiService() {
    // if (kDebugMode) {
    //   baseUrl =
    //       "https://105kt18s-3000.use2.devtunnels.ms/api";
    //   baseUrl2 =
    //       "https://105kt18s-3000.use2.devtunnels.ms/api";
    // }
  }

  Future<Map<String, dynamic>?> create(
      {required String collectionName,
      required Map<String, dynamic> data}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$collectionName'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"data": data}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to create document: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createWithId(
      {required String collectionName,
      required String id,
      required Map<String, dynamic> data}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$collectionName/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print(
          'Failed to create document with ID: $baseUrl/$collectionName/$id - $data - ${response.body}');
      return null;
    }
  }

  Future<dynamic> post(
      {required Map<String, dynamic> data, required String endPoint}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endPoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    final resp = response.body;
    return json.decode(resp);
  }

  Future<List<Map<String, dynamic>>> getAll(
      {required String nameCollection}) async {
    final response = await http.get(Uri.parse('$baseUrl/$nameCollection'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      logger.e('Failed to load items');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getById(
      {required String collectionName, required String id}) async {
    final response = await http.get(Uri.parse('$baseUrl/$collectionName/$id'));
    print('$baseUrl/$collectionName/$id');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'Failed to get document by ID:${response.statusCode} - $baseUrl/$collectionName/$id - ${response.body}');
      return null;
    }
  }

  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    required String nameCollection,
  }) async {

    print([id,
data,
nameCollection]);
    final response = await http.put(
      Uri.parse('$baseUrl/$nameCollection/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  Future<bool> delete(String collectionName, String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/$collectionName/$id'));
    return response.statusCode == 200;
  }

  Future<List<dynamic>?> getAllBy(
      String collectionName, String category) async {
    final response = await http
        .get(Uri.parse('$baseUrl/$collectionName/category/$category'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to get documents by category: ${response.body}');
      return null;
    }
  }

  Future<List<dynamic>?> searchByField(
      String collectionName, String field, String value) async {
    try {
      print('$baseUrl/$collectionName/search/$field/$value');
      final response = await http
          .get(Uri.parse('$baseUrl/$collectionName/search/$field/$value'));

      if ((response.statusCode == 200) || (response.statusCode == 200)) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to search documents by field:$baseUrl/$collectionName/search/$field/$value = ${response.body}');
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getDataApi() async {
    final Uri url = Uri.parse('$baseUrl2/module/programs/');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      url,
      headers: headers,
      // body: jsonEncode(data),
    );
    final respon = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return respon[0]['program'];
    }
    return [];
  }

  Future<List<dynamic>> getAllItemsStateAndCity(String endPoint) async {
    final Uri url = Uri.parse('$baseUrl2/$endPoint');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      url,
      headers: headers,
      // body: jsonEncode(data),
    );
    final respon = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return respon;
    }
    return [];
  }

  Future<List<dynamic>?> searchByFields(
      {required String collectionName,
      required String query,
      required List<String> fields}) async {
    final queryString = fields.join(',');
    final response = await http.get(Uri.parse(
        '$baseUrl/$collectionName/multi-search/$query?fields=$queryString'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to search documents by fields: ${response.body}');
      return null;
    }
  }
}
