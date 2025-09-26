import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lexxi/domain/image/repository/image_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';

@LazySingleton(as: ImageRepository)
class ImageImplement implements ImageRepository {
  final String _baseUrl = 'https://app.formarte.co/images';
  // String _baseUrl = 'http://localhost:3000/images';

  ImageImplement() {
    if (kDebugMode) {
      // _baseUrl = "http://localhost:3000/images";
    }
  }

/*  
 @override
  Future<String> uploadImage(String base64Image) async {
    var uri = Uri.parse('$_baseUrl/upload');
    var request = http.Request('POST', uri);
    request.body = json.encode({'file': base64Image});
    request.headers.addAll({'Content-Type': 'application/json'});
    var response = await request.send();
    final r = await response.stream.bytesToString();
    try {
      return r;
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  } */

  @override
  Future<String> uploadImage(
      Uint8List fileBytes, String fileName, String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    try {
      // Obtener el tipo MIME del archivo
      String? mimeType = getMimeTypeFromFileName(fileName);
      if (mimeType == null) {
        throw Exception('No se pudo determinar el tipo MIME del archivo');
      }
      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'));

      request.files.add(http.MultipartFile.fromBytes(
        'file[]',
        fileBytes,
        filename:
            fileName, // Usa el nombre del archivo con la extensión adecuada
        contentType: MediaType.parse(mimeType), // Asegurar el tipo MIME
      ));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final resp = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final map = jsonDecode(resp);
        return map['uploadedFilesInfo'][0]['objectUrl'];
      } else {
        throw Exception('Error al subir el archivo: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<String> uploadImageBase64(Uint8List fileBytes, String fileName) async {
    try {
      String base64Image = base64Encode(fileBytes);

      var uri = Uri.parse('$_baseUrl/upload');
      var request = http.Request('POST', uri);

      request.body = json.encode({
        'image': base64Image,
      });

      request.headers.addAll({'Content-Type': 'application/json'});

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final map = jsonDecode(responseData);

        return map['data']['url'];
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading base64 image: $e');
    }
  }

  Uint8List convertBase64ToUint8List(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw FormatException(
          "La cadena proporcionada no es un Base64 válido: $e");
    }
  }

  String? getMimeTypeFromFileName(String fileName) {
    return lookupMimeType(fileName);
  }
}
