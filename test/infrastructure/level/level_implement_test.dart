import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/level/level_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/level/model/level.dart';

import 'level_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late LevelImplement repository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    repository = LevelImplement(mockApiService);
  });

  group('LevelImplement Tests', () {
    test('get debe retornar Level cuando existe', () async {
      // Arrange
      const id = '1';
      const score = '100';
      final levelData = {
        'level': 'Nivel 1',
        'currentColor': '#FF0000',
        'typeName': 'Principiante',
      };

      when(mockApiService.getById(
              collectionName: 'academic_levels', id: '$id/$score'))
          .thenAnswer((_) async => levelData);

      // Act
      final result = await repository.get(id: id, score: score);

      // Assert
      expect(result, isNotNull);
      expect(result!.level, 'Nivel 1');
      expect(result.currentColor, '#FF0000');
      verify(mockApiService.getById(
              collectionName: 'academic_levels', id: '$id/$score'))
          .called(1);
    });

    test('get debe retornar null cuando no existe', () async {
      // Arrange
      const id = '1';
      const score = '0';

      when(mockApiService.getById(
              collectionName: 'academic_levels', id: '$id/$score'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.get(id: id, score: score);

      // Assert
      expect(result, isNull);
      verify(mockApiService.getById(
              collectionName: 'academic_levels', id: '$id/$score'))
          .called(1);
    });
  });
}
