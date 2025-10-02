import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/image/image_implement.dart';

import 'image_implement_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ImageImplement implementation;

  setUp(() {
    implementation = ImageImplement();
  });

  group('ImageImplement Tests', () {
    test('convertBase64ToUint8List debe convertir base64 a Uint8List',
        () async {
      // Arrange
      final testString = 'Hello World';
      final base64String = base64Encode(utf8.encode(testString));

      // Act
      final result = implementation.convertBase64ToUint8List(base64String);

      // Assert
      expect(result, isA<Uint8List>());
      expect(utf8.decode(result), testString);
    });

    test('convertBase64ToUint8List debe lanzar excepción con base64 inválido',
        () {
      // Arrange
      const invalidBase64 = 'invalid@base64!';

      // Act & Assert
      expect(
        () => implementation.convertBase64ToUint8List(invalidBase64),
        throwsA(isA<FormatException>()),
      );
    });

    test('getMimeTypeFromFileName debe retornar tipo MIME correcto', () {
      // Act
      final jpegMime = implementation.getMimeTypeFromFileName('image.jpg');
      final pngMime = implementation.getMimeTypeFromFileName('image.png');
      final pdfMime = implementation.getMimeTypeFromFileName('document.pdf');

      // Assert
      expect(jpegMime, 'image/jpeg');
      expect(pngMime, 'image/png');
      expect(pdfMime, 'application/pdf');
    });

    test('getMimeTypeFromFileName debe retornar null para extensión desconocida',
        () {
      // Act
      final unknownMime =
          implementation.getMimeTypeFromFileName('file.unknown');

      // Assert
      expect(unknownMime, isNull);
    });

    test('getMimeTypeFromFileName debe manejar diferentes casos', () {
      // Act
      final result1 = implementation.getMimeTypeFromFileName('Image.JPG');
      final result2 = implementation.getMimeTypeFromFileName('photo.jpeg');
      final result3 = implementation.getMimeTypeFromFileName('icon.gif');

      // Assert
      expect(result1, isNotNull);
      expect(result2, 'image/jpeg');
      expect(result3, 'image/gif');
    });
  });
}
