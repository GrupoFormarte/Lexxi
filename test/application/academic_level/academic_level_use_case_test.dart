import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/academic_level/academic_level_use_case.dart';
import 'package:lexxi/domain/academic_level/repository/academic_level_repository.dart';
import 'package:lexxi/domain/academic_level/model/academic_level.dart';

import 'academic_level_use_case_test.mocks.dart';

@GenerateMocks([AcademicLevelRepository])
void main() {
  late AcademicLevelUseCase useCase;
  late MockAcademicLevelRepository mockRepository;

  setUp(() {
    mockRepository = MockAcademicLevelRepository();
    useCase = AcademicLevelUseCase(mockRepository);
  });

  group('AcademicLevelUseCase Tests', () {
    test('getAcademicLevelById debe retornar AcademicLevel cuando existe',
        () async {
      // Arrange
      const id = '1';
      final academicLevel = AcademicLevelModel(
        idGrado: id,
        typesLevels: [],
      );

      when(mockRepository.getLevelById(id))
          .thenAnswer((_) async => academicLevel);

      // Act
      final result = await useCase.getAcademicLevelById(id: id);

      // Assert
      expect(result, isNotNull);
      expect(result?.idGrado, id);
      verify(mockRepository.getLevelById(id)).called(1);
    });

    test('getAcademicLevelById debe retornar null cuando no existe', () async {
      // Arrange
      const id = '999';

      when(mockRepository.getLevelById(id)).thenAnswer((_) async => null);

      // Act
      final result = await useCase.getAcademicLevelById(id: id);

      // Assert
      expect(result, isNull);
      verify(mockRepository.getLevelById(id)).called(1);
    });
  });
}
