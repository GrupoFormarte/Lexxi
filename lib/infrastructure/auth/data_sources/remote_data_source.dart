import 'dart:convert';
import 'dart:developer';

import 'package:lexxi/config/env_config.dart';
import 'package:lexxi/domain/core/exceptions/user_exception.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

@injectable
class RemoteDataSource {
  String get _baseUrl => EnvConfig.authBaseUrl;
  String get _urlSaf => EnvConfig.authSafUrl;

  String urlExample = 'http://localhost:3000/api';

  RemoteDataSource();

  Future register(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_baseUrl/auth/register-app');
    final Map<String, String> headers = EnvConfig.defaultHeaders;
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      final respon = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return respon;
      } else {
        final msg =
            respon['message']?.toString() ??
            respon['error']?.toString() ??
            'Error desconocido';
        _getErrorMessage(
          response.statusCode,
          nameMethod: 'register',
          e: response.body,
        );
        throw UserException(msg);
      }
    } catch (e) {
      _getErrorMessage(500, nameMethod: 'register', e: e.toString());
      throw UserException(e.toString());
    }
  }

  Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login');

    final Map<String, String> headers = {'Content-Type': 'application/json'};

    try {
      log('========== LOGIN PRINCIPAL ==========');
      log('URL: $url');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      log('STATUS CODE: ${response.statusCode}');

      final respon = jsonDecode(response.body);

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 202) {
        final message =
            respon['message']?.toString() ??
            respon['error']?.toString() ??
            'Credenciales inválidas';

        throw NormalLoginFailedException(message);
      }

      final token = respon['token'] ?? respon['data']?['token'];

      if (token == null || token is! String) {
        throw UserException('El login no devolvió un token válido');
      }

      final jwtData = jwtDecode(token);

      jwtData.payload['token'] = token;

      final user = respon['data']?['user'];

      if (user == null) {
        throw UserException(
          'El login no devolvió la información del usuario',
        );
      }

      user['token'] = token;
      user['_login_type'] = 'normal';

      await EnvConfig.setTokenForMongo(token);

      return Map<String, dynamic>.from(user);
    } catch (e, stackTrace) {
      log('❌ ERROR LOGIN: $e');
      log('STACKTRACE: $stackTrace');

      if (e is UserException) rethrow;
      throw UserException(e.toString());
    }
  }

  Future<Map<String, dynamic>?> loginSaf(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_urlSaf/auth/login');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    final decodedResponse = jsonDecode(response.body);
    final respon = decodedResponse is Map<String, dynamic>
        ? decodedResponse
        : <String, dynamic>{};
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final token = respon['token'];
      if (token is! String || token.isEmpty) {
        throw UserException('El login SAF no devolvió un token válido');
      }

      final jwtData = jwtDecode(token);
      jwtData.payload['token'] = token;
      final data = await getDataUser(jwtData.payload);

      final tokenMongo = await getTokenApiMongo(
        jwtData.payload['id'],
        token,
      );

      await EnvConfig.setTokenForMongo(tokenMongo);

      if (data != null) {
        data['institute'] = jwtData.payload['institute'];
        data['_login_type'] = 'saf';
      }
      log(data.toString());
      return data;
    } else {
      final message =
          respon['message']?.toString() ??
          respon['error']?.toString() ??
          _getErrorMessage(response.statusCode, nameMethod: 'login SAF');
      throw UserException(message);
    }
  }

  Future<Map<String, dynamic>?> getDataUser(Map<String, dynamic> data) async {
    final token = data['token'];
    var headers = {
      'Authorization': 'Bearer $token',
      "Content-Type": 'application/json',
    };
    final response = await http.get(
      Uri.parse('$_urlSaf/user/${data["id"]}'),
      headers: headers,
    );
    final respon = jsonDecode(response.body);
    print(['---', respon]);

    if (response.statusCode == 200) {
      respon['token'] = token;
      return respon;
    }
    return null;
  }

  Future<String?> getTokenApiMongo(int id, String token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final Uri url = Uri.parse('${EnvConfig.baseUrl}/auth/podium-login');
      final response = await http.post(
        url,
        body: jsonEncode({'userId': '$id', 'token': token}),
        headers: headers,
      );
      print(['${EnvConfig.baseUrl}/auth/podium-login']);

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data']['token'];
      }

      throw UserException(
        _getErrorMessage(
          response.statusCode,
          nameMethod: 'getTokenReport',
          e: responseData['message'] ?? 'Failed to get report token',
        ),
      );
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException('Network error: ${e.toString()}');
    }
  }

  Future<List<dynamic>> _enrolls(int idS) async {
    final request = http.Request(
      'GET',
      Uri.parse('$_baseUrl/module/enrolls/student/$idS'),
    );
    final response = await request.send();
    try {
      final respon = jsonDecode(await response.stream.bytesToString());
      return respon['enrollments'];
    } catch (e) {
      final errorMessage = _getErrorMessage(
        response.statusCode,
        nameMethod: '_enrolls',
      );
      throw UserException(errorMessage);
    }
  }

  Future<bool> newPassword(
    String password,
    String newPassword,
    String token,
  ) async {
    var headers = {
      'Authorization': 'Bearer $token',
      "Content-Type": 'application/json',
    };
    final Uri url = Uri.parse('$_urlSaf/auth/change-password');
    var response = await http.post(
      url,
      body: jsonEncode({
        "current_password": password,
        "new_password": newPassword,
      }),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final errorMessage = _getErrorMessage(
        response.statusCode,
        nameMethod: 'newPassword',
      );
      throw UserException(
        errorMessage,
      );
    }
  }

  Future<Map<String, dynamic>?> getInfouUer(User user) async {
    var headers = {'Authorization': 'Bearer ${user.token}'};
    final Uri url = Uri.parse('$_baseUrl/user/profile/');
    var response = await http.get(url, headers: headers);
    final respon = jsonDecode(response.body)['user'];
    if (response.statusCode == 200) {
      respon['token'] = user.token;
      respon['grado'] = await _enrolls(respon['id']);
      return respon;
    } else {
      final errorMessage = _getErrorMessage(
        response.statusCode,
        e: response.body,
        nameMethod: 'getInfouUer',
      );
      throw UserException(errorMessage);
    }
  }

  String _getErrorMessage(
    int statusCode, {
    String e = "",
    String nameMethod = "",
  }) {
    switch (statusCode) {
      case 400:
        return 'Solicitud incorrecta $nameMethod\n $e';
      case 401:
        return 'No autorizado $nameMethod\n $e';
      case 403:
        return 'Prohibido $nameMethod\n $e';
      case 404:
        return 'No se encontró la página $nameMethod\n $e';
      default:
        return 'Error desconocido: $nameMethod $statusCode $e';
    }
  }
}