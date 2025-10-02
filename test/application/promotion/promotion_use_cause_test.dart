import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/promotion/promotion_use_cause.dart';
import 'package:lexxi/domain/promotion/repositories/promotion_repositorie.dart';
import 'package:lexxi/domain/promotion/model/promotion.dart';

import 'promotion_use_cause_test.mocks.dart';

@GenerateMocks([PromotionRepositorie])
void main() {
  late PromotionUseCause useCase;
  late MockPromotionRepositorie mockRepository;

  setUp(() {
    mockRepository = MockPromotionRepositorie();
    useCase = PromotionUseCause(mockRepository);
  });

  group('PromotionUseCause Tests', () {
    test('get debe retornar PromotionModel cuando existe', () async {
      // Arrange
      final promotion = PromotionModel(
        id: '1',
        title: 'Promoción Test',
        description: 'Descripción test',
        fileUrl: 'https://example.com/image.jpg',
        fileType: 'image',
        buttonText: 'Ver más',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
      );

      when(mockRepository.get()).thenAnswer((_) async => promotion);

      // Act
      final result = await useCase.get();

      // Assert
      expect(result, isNotNull);
      expect(result.id, '1');
      expect(result.title, 'Promoción Test');
      verify(mockRepository.get()).called(1);
    });

    test('get debe retornar default promotion cuando no hay promociones activas',
        () async {
      // Arrange
      final defaultPromotion = PromotionModel.defaultPromotion();

      when(mockRepository.get()).thenAnswer((_) async => defaultPromotion);

      // Act
      final result = await useCase.get();

      // Assert
      expect(result, isNotNull);
      expect(result.id, 'default');
      expect(result.title, '¡No hay promociones activas!');
      verify(mockRepository.get()).called(1);
    });
  });
}
