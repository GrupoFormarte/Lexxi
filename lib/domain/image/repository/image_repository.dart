import 'dart:typed_data';

abstract class ImageRepository {
  Future<String> uploadImage(Uint8List imageFile,String fileName,String token);
    Future<String> uploadImageBase64(Uint8List fileBytes, String fileName);
}