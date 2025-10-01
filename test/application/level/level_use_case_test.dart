import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/level/level_use_case.dart';
import 'package:lexxi/domain/level/repository/level_repository.dart';
import 'package:lexxi/domain/level/model/level.dart';

import 'level_use_case_test.mocks.dart';

@GenerateMocks([LevelRepository])
void main() {
  late LevelUseCase useCase;
  late MockLevelRepository mockRepository;

  setUp(() {
    mockRepository = MockLevelRepository();
    useCase = LevelUseCase(mockRepository);
  });

  group('LevelUseCase Tests', () {
    test('get debe retornar Level cuando existe', () async {
      // Arrange
      const id = '1';
      const score = '100';
      final level = Level(
        level: 'Nivel 1',
        currentColor: '#FF0000',
        typeName: 'Principiante',
      );

      when(mockRepository.get(id: id, score: score))
          .thenAnswer((_) async => level);

      // Act
      final result = await useCase.get(id: id, score: score);

      // Assert
      expect(result, isNotNull);
      expect(result?.level, 'Nivel 1');
      verify(mockRepository.get(id: id, score: score)).called(1);
    });

    test('get debe retornar null cuando no existe', () async {
      // Arrange
      const id = '1';
      const score = '0';

      when(mockRepository.get(id: id, score: score))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.get(id: id, score: score);

      // Assert
      expect(result, isNull);
      verify(mockRepository.get(id: id, score: score)).called(1);
    });
  });
}
