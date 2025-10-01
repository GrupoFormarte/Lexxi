import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/image/model/image_model.dart';

void main() {
  group('ImageModel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'filename': 'https://example.com/image.jpg',
      };

      // Act
      final image = ImageModel.fromJson(json);

      // Assert
      expect(image.url, 'https://example.com/image.jpg');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final image = ImageModel(url: 'https://example.com/photo.png');

      // Act
      final json = image.toJson();

      // Assert
      expect(json['url'], 'https://example.com/photo.png');
    });

    test('debe crear instancia con constructor', () {
      // Arrange & Act
      final image = ImageModel(url: 'https://example.com/test.jpg');

      // Assert
      expect(image.url, 'https://example.com/test.jpg');
    });
  });
}
