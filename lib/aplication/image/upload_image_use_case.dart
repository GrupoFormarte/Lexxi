import 'dart:typed_data';

import 'package:lexxi/domain/image/repository/image_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadImageUseCase {
  final ImageRepository repository;

  UploadImageUseCase(this.repository);

  Future<String> execute(Uint8List imageFile, String fileName) async {
    
      return await repository.uploadImageBase64(imageFile, fileName);
    // return await repository.uploadImage(imageFile, fileName, dataUser!.token!);
  }

  Future<String> uploadImageBase64(Uint8List fileBytes, String fileName) async {
    return await repository.uploadImageBase64(fileBytes, fileName);
  }
}
