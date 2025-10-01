import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/asignatura/service/asignatura_service.dart';
import 'package:lexxi/domain/asignaturas/repositories/asignatura_repository.dart';
import 'package:lexxi/domain/asignaturas/model/asignatura_model.dart';
import 'package:lexxi/domain/asignaturas/model/resultado_asignatura.dart';

import 'asignatura_service_test.mocks.dart';

@GenerateMocks([AsignaturaRepository])
void main() {
  late AsignaturaService asignaturaService;
  late MockAsignaturaRepository mockRepository;

  setUp(() {
    mockRepository = MockAsignaturaRepository();
    asignaturaService = AsignaturaService(mockRepository);
  });

  group('AsignaturaService Tests', () {
    test('getAsignaturas debe retornar lista de asignaturas', () async {
      // Arrange
      final mockAsignaturas = [
        Asignatura(id: 1, value: 'Matemáticas', gradoId: 1),
        Asignatura(id: 2, value: 'Español', gradoId: 1),
      ];

      when(mockRepository.getAsignatura('1'))
          .thenAnswer((_) async => mockAsignaturas);

      // Act
      final result = await asignaturaService.getAsignaturas('1');

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, equals(2));
      expect(result[0].value, equals('Matemáticas'));
      verify(mockRepository.getAsignatura('1')).called(1);
    });

    test('getAsignaturas debe retornar lista vacía cuando no hay asignaturas',
        () async {
      // Arrange
      when(mockRepository.getAsignatura('1')).thenAnswer((_) async => []);

      // Act
      final result = await asignaturaService.getAsignaturas('1');

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getAsignatura('1')).called(1);
    });

    test('guardarResultadoAsignatura debe llamar al repositorio', () async {
      // Arrange
      final resultado = ResultadoAsignatura(
        idAsignatura: '1',
        idEstudiante: '100',
        puntaje: 85.5,
        asignaturaValue: 'Matematicas',
      );

      when(mockRepository.guardarResultadoAsignatura(resultado))
          .thenAnswer((_) async => null);

      // Act
      await asignaturaService.guardarResultadoAsignatura(resultado);

      // Assert
      verify(mockRepository.guardarResultadoAsignatura(resultado)).called(1);
    });

    test('getResultadoAsignatura debe retornar lista de resultados', () async {
      // Arrange
      final mockResultados = <ResultadoAsignatura>[];

      when(mockRepository.getResultadoAsignatura(100))
          .thenAnswer((_) async => mockResultados);

      // Act
      final result = await asignaturaService.getResultadoAsignatura(100);

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getResultadoAsignatura(100)).called(1);
    });

    test('getResultadoAsignatura debe manejar errores del repositorio',
        () async {
      // Arrange
      when(mockRepository.getResultadoAsignatura(100))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => asignaturaService.getResultadoAsignatura(100),
        throwsException,
      );
    });
  });
}
