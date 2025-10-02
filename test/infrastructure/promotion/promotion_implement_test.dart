import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/promotion/promotion_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/promotion/model/promotion.dart';

import 'promotion_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late PromotionImplement repository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    repository = PromotionImplement(mockApiService);
  });

  group('PromotionImplement Tests', () {
    test('get debe retornar promoción activa cuando existe', () async {
      // Arrange
      final now = DateTime.now();
      final promotionData = [
        {
          '_id': 'promo1',
          'title': 'Promoción Activa',
          'description': 'Descripción',
          'fileUrl': 'https://example.com/image.jpg',
          'fileType': 'image',
          'buttonText': 'Ver más',
          'startDate': now.subtract(Duration(days: 1)).toIso8601String(),
          'endDate': now.add(Duration(days: 30)).toIso8601String(),
        }
      ];

      when(mockApiService.getAll(nameCollection: 'promotion_alert'))
          .thenAnswer((_) async => promotionData);

      // Act
      final result = await repository.get();

      // Assert
      expect(result, isNotNull);
      expect(result.id, 'promo1');
      expect(result.title, 'Promoción Activa');
      verify(mockApiService.getAll(nameCollection: 'promotion_alert'))
          .called(1);
    });

    test('get debe retornar promoción por defecto cuando no hay activas',
        () async {
      // Arrange
      final past = DateTime.now().subtract(Duration(days: 10));
      final promotionData = [
        {
          '_id': 'promo1',
          'title': 'Promoción Expirada',
          'description': 'Descripción',
          'fileUrl': 'https://example.com/image.jpg',
          'fileType': 'image',
          'buttonText': 'Ver más',
          'startDate': past.subtract(Duration(days: 5)).toIso8601String(),
          'endDate': past.toIso8601String(),
        }
      ];

      when(mockApiService.getAll(nameCollection: 'promotion_alert'))
          .thenAnswer((_) async => promotionData);

      // Act
      final result = await repository.get();

      // Assert
      expect(result, isNotNull);
      expect(result.id, 'default');
      expect(result.title, '¡No hay promociones activas!');
      verify(mockApiService.getAll(nameCollection: 'promotion_alert'))
          .called(1);
    });

    test('get debe retornar promoción por defecto cuando lista vacía',
        () async {
      // Arrange
      when(mockApiService.getAll(nameCollection: 'promotion_alert'))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.get();

      // Assert
      expect(result, isNotNull);
      expect(result.id, 'default');
      verify(mockApiService.getAll(nameCollection: 'promotion_alert'))
          .called(1);
    });
  });
}
