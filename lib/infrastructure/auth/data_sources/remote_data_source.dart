import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lexxi/domain/auth/exeptions/user_exception.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

@injectable
class RemoteDataSource {
  final String _baseUrl = 'https://app.formarte.co';
  final String _userSaf = 'https://stage-api.plataformapodium.com/api';
  // final String _userSaf = 'https://newdev.formarte.co/api';
  // final String _baseUrl = 'http://192.168.1.62/api';
  // final String _baseUrl = 'https://q1vcfcrh-8088.use2.devtunnels.ms/api';

  RemoteDataSource() {
    if (kDebugMode) {
      // _baseUrl = "https://apidev.formarte.co/api";
      // _baseUrl = "https://3575-190-248-145-70.ngrok-free.app";
    }
  }

  Future register(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_baseUrl/users/register');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      final respon = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return respon;
      } else {
        final errorMessage = _getErrorMessage(response.statusCode,
            nameMethod: 'register', e: response.body);

        throw UserException(respon['message']);
      }
    } catch (e) {
      final errorMessage =
          _getErrorMessage(500, nameMethod: 'register', e: e.toString());
      throw UserException(e.toString());
    }
  }

  Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_baseUrl/users/login/');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    final respon = jsonDecode(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final jwtData = jwtDecode(respon['data']['token']);
      jwtData.payload['token'] = respon['data']['token'];
      respon['data']['user']['token'] = respon['data']['token'];
      final Map<String, dynamic> userData = respon['data']['user'];
      // log(userData.toString());
      return userData;
    } else {
      final dat = loginSaf(data);
      return dat;
    }
  }

  Future<Map<String, dynamic>?> loginSaf(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$_userSaf/auth/login');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    final respon = jsonDecode(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final jwtData = jwtDecode(respon['token']);
      jwtData.payload['token'] = respon['token'];
      final data = await getDataUser(jwtData.payload);
      if (data != null) {
        data['institute'] = jwtData.payload['institute'];
      }
      print(data);
      return data;
    } else {
      final errorMessage = _getErrorMessage(response.statusCode,
          nameMethod: '${response.body}--login');
      throw UserException(
          respon['message']); // Retorna null en lugar de lanzar una excepción
    }
  }

  Future<Map<String, dynamic>?> getDataUser(Map<String, dynamic> data) async {
    final token = data['token'];
    var headers = {
      'Authorization': 'Bearer $token',
      "Content-Type": 'application/json'
    };
    final response = await http.get(
      Uri.parse('$_userSaf/user/${data["id"]}'),
      headers: headers,
    );
    final respon = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return respon;
    }
    return null;
  }

  Future<List<dynamic>> _enrolls(int idS) async {
    var request =
        http.Request('GET', Uri.parse('$_baseUrl/module/enrolls/student/$idS'));
    http.StreamedResponse response = await request.send();
    try {
      final respon = jsonDecode(await response.stream.bytesToString());
      return respon['enrollments'];
    } catch (e) {
      final errorMessage =
          _getErrorMessage(response.statusCode, nameMethod: '_enrolls');
      throw UserException(errorMessage);
    }
  }

  Future<bool> newPassword(
      String password, String newPassword, String token) async {
    var headers = {
      'Authorization': 'Bear $token',
      "Content-Type": 'application/json'
    };
    final Uri url = Uri.parse('$_baseUrl/auth/change-password/');
    var response = await http.post(url,
        body: jsonEncode({"password": password, "newPassword": newPassword}),
        headers: headers);
    // final respon = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final errorMessage =
          _getErrorMessage(response.statusCode, nameMethod: 'newPassword');
      throw UserException(
          errorMessage); // Retorna null en lugar de lanzar una excepción
    }
  }

  Future<Map<String, dynamic>?> getInfouUer(User user) async {
    var headers = {'Authorization': 'Bear ${user.token}'};
    final Uri url = Uri.parse('$_baseUrl/user/profile/');
    var response = await http.get(url, headers: headers);
    final respon = jsonDecode(response.body)['user'];
    if (response.statusCode == 200) {
      respon['token'] = user.token;
      respon['grado'] = await _enrolls(respon['id']);
      return respon;
    } else {
      final errorMessage = _getErrorMessage(response.statusCode,
          e: response.body, nameMethod: 'getInfouUer');
      throw UserException(errorMessage);
    }
  }

  String _getErrorMessage(int statusCode,
      {String e = "", String nameMethod = ""}) {
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
