import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/academic_level/academic_level_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/academic_level/model/academic_level.dart';

import 'academic_level_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late AcademicLevelRepositoryImpl repository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    repository = AcademicLevelRepositoryImpl(mockApiService);
  });

  group('AcademicLevelRepositoryImpl Tests', () {
    test('getLevelById debe retornar AcademicLevelModel cuando existe',
        () async {
      // Arrange
      const id = 'grado10';
      final levelData = {
        'id_grado': 'grado10',
        'levelMax': '100',
        'types_levels': [
          {
            'name': 'Principiante',
            'color': 'FF0000',
            'min': '0',
            'max': '50',
            'levels': [
              {'level': 'Nivel 1', 'puntaje': '25'},
              {'level': 'Nivel 2', 'puntaje': '50'},
            ],
          }
        ],
      };

      when(mockApiService.getById(collectionName: 'academic_levels', id: id))
          .thenAnswer((_) async => levelData);

      // Act
      final result = await repository.getLevelById(id);

      // Assert
      expect(result, isNotNull);
      expect(result!.idGrado, 'grado10');
      expect(result.levelMax, '100');
      expect(result.typesLevels, hasLength(1));
      verify(mockApiService.getById(collectionName: 'academic_levels', id: id))
          .called(1);
    });

    test('getLevelById debe retornar null cuando no existe', () async {
      // Arrange
      const id = 'grado999';

      when(mockApiService.getById(collectionName: 'academic_levels', id: id))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getLevelById(id);

      // Assert
      expect(result, isNull);
      verify(mockApiService.getById(collectionName: 'academic_levels', id: id))
          .called(1);
    });
  });
}
