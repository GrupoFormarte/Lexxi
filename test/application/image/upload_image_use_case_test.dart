import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/image/upload_image_use_case.dart';
import 'package:lexxi/domain/image/repository/image_repository.dart';

import 'upload_image_use_case_test.mocks.dart';

@GenerateMocks([ImageRepository])
void main() {
  late UploadImageUseCase useCase;
  late MockImageRepository mockRepository;

  setUp(() {
    mockRepository = MockImageRepository();
    useCase = UploadImageUseCase(mockRepository);
  });

  group('UploadImageUseCase Tests', () {
    test('execute debe subir imagen y retornar URL', () async {
      // Arrange
      final imageBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      const fileName = 'test_image.jpg';
      const expectedUrl = 'https://example.com/uploads/test_image.jpg';

      when(mockRepository.uploadImageBase64(imageBytes, fileName))
          .thenAnswer((_) async => expectedUrl);

      // Act
      final result = await useCase.execute(imageBytes, fileName);

      // Assert
      expect(result, expectedUrl);
      verify(mockRepository.uploadImageBase64(imageBytes, fileName)).called(1);
    });

    test('uploadImageBase64 debe subir imagen en base64 y retornar URL',
        () async {
      // Arrange
      final imageBytes = Uint8List.fromList([10, 20, 30, 40, 50]);
      const fileName = 'photo.png';
      const expectedUrl = 'https://example.com/images/photo.png';

      when(mockRepository.uploadImageBase64(imageBytes, fileName))
          .thenAnswer((_) async => expectedUrl);

      // Act
      final result = await useCase.uploadImageBase64(imageBytes, fileName);

      // Assert
      expect(result, expectedUrl);
      verify(mockRepository.uploadImageBase64(imageBytes, fileName)).called(1);
    });

    test('execute debe lanzar excepción cuando falla la subida', () async {
      // Arrange
      final imageBytes = Uint8List.fromList([1, 2, 3]);
      const fileName = 'error_image.jpg';

      when(mockRepository.uploadImageBase64(imageBytes, fileName))
          .thenThrow(Exception('Upload failed'));

      // Act & Assert
      expect(
        () => useCase.execute(imageBytes, fileName),
        throwsException,
      );
      verify(mockRepository.uploadImageBase64(imageBytes, fileName)).called(1);
    });
  });
}
