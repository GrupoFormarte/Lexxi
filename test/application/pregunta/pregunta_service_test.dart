import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/pregunta/service/pregunta_service.dart';
import 'package:lexxi/domain/pregunta/repositories/pregunta_repository.dart';
import 'package:lexxi/domain/pregunta/models/pregunta_model.dart';
import 'package:lexxi/domain/pregunta/exeptions/user_exception.dart';

import 'pregunta_service_test.mocks.dart';

@GenerateMocks([PreguntaRepository])
void main() {
  late PreguntaService preguntaService;
  late MockPreguntaRepository mockRepository;

  setUp(() {
    mockRepository = MockPreguntaRepository();
    preguntaService = PreguntaService(mockRepository);
  });

  group('PreguntaService Tests', () {
    test('getPreguntas debe retornar lista de preguntas', () async {
      // Arrange
      final mockPreguntas = <Question>[];

      when(mockRepository.getPreguntas('grado/10', dificultad: 'facil'))
          .thenAnswer((_) async => mockPreguntas);

      // Act
      final result = await preguntaService.getPreguntas('10', dificultad: 'facil');

      // Assert
      expect(result, isNotNull);
      verify(mockRepository.getPreguntas('grado/10', dificultad: 'facil')).called(1);
    });

    test('getPreguntas debe usar parametros por defecto', () async {
      // Arrange
      when(mockRepository.getPreguntas('grado/11', dificultad: 'facil'))
          .thenAnswer((_) async => []);

      // Act
      final result = await preguntaService.getPreguntas('11');

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getPreguntas('grado/11', dificultad: 'facil')).called(1);
    });

    test('getPreguntas debe lanzar UserException cuando hay error', () async {
      // Arrange
      when(mockRepository.getPreguntas(any, dificultad: anyNamed('dificultad')))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => preguntaService.getPreguntas('10'),
        throwsA(isA<UserException>()),
      );
    });

    test('getPreguntas debe aceptar diferentes tipos de pregunta', () async {
      // Arrange
      when(mockRepository.getPreguntas('asignatura/matematicas', dificultad: 'dificil'))
          .thenAnswer((_) async => []);

      // Act
      await preguntaService.getPreguntas('matematicas',
          dificultad: 'dificil',
          tipoPregunta: 'asignatura');

      // Assert
      verify(mockRepository.getPreguntas('asignatura/matematicas', dificultad: 'dificil')).called(1);
    });

    test('registrarPreguntaMala debe llamar al repositorio', () async {
      // Arrange
      const preguntaId = 123;
      when(mockRepository.registrarPreguntaMala(preguntaId))
          .thenAnswer((_) async => null);

      // Act
      await preguntaService.registrarPreguntaMala(preguntaId);

      // Assert
      verify(mockRepository.registrarPreguntaMala(preguntaId)).called(1);
    });

    test('registrarPreguntaMala debe propagar excepciones', () async {
      // Arrange
      when(mockRepository.registrarPreguntaMala(any))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => preguntaService.registrarPreguntaMala(1),
        throwsException,
      );
    });
  });
}
