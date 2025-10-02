import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/detalle_preguntas/preguntas_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/detalle_pregunta/model/pregunta.dart';

import 'preguntas_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late DetallePreguntaImplement implementation;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    implementation = DetallePreguntaImplement(mockApiService);
  });

  group('DetallePreguntaImplement Tests', () {
    test('createPregunta debe retornar el ID de la pregunta creada', () async {
      // Arrange
      final preguntaData = {
        'pregunta': '¿Cuál es la capital de Colombia?',
        'respuestas': ['Bogotá', 'Medellín', 'Cali'],
      };

      when(mockApiService.create(
        data: anyNamed('data'),
        collectionName: anyNamed('collectionName'),
      )).thenAnswer((_) async => {'_id': 'pregunta123'});

      // Act
      final result = await implementation.createPregunta(preguntaData);

      // Assert
      expect(result, 'pregunta123');
      verify(mockApiService.create(
        data: preguntaData,
        collectionName: 'detail_preguntas',
      )).called(1);
    });

    test('createPreguntaWithId debe llamar al servicio API', () async {
      // Arrange
      final preguntaData = {
        'pregunta': '¿Cuál es la capital de Colombia?',
      };

      when(mockApiService.createWithId(
        data: anyNamed('data'),
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.createPreguntaWithId(preguntaData, 'pregunta123');

      // Assert
      verify(mockApiService.createWithId(
        data: preguntaData,
        collectionName: 'detail_preguntas',
        id: 'pregunta123',
      )).called(1);
    });

    test('getAllPreguntas debe retornar lista de preguntas', () async {
      // Arrange
      final mockData = [
        {
          'id': 'pregunta1',
          'pregunta': '¿Cuál es la capital de Colombia?',
          'respuestas': ['Bogotá'],
        },
        {
          'id': 'pregunta2',
          'pregunta': '¿Cuál es la capital de México?',
          'respuestas': ['Ciudad de México'],
        },
      ];

      when(mockApiService.getAll(
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getAllPreguntas();

      // Assert
      expect(result, hasLength(2));
      expect(result[0], isA<DetallePregunta>());
      expect(result[1], isA<DetallePregunta>());
      verify(mockApiService.getAll(
        nameCollection: 'detail_preguntas',
      )).called(1);
    });

    test('getPreguntaById debe retornar pregunta', () async {
      // Arrange
      final mockData = {
        'pregunta': '¿Cuál es la capital de Colombia?',
        'respuestas': ['Bogotá'],
      };

      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getPreguntaById('pregunta1');

      // Assert
      expect(result, isA<DetallePregunta>());
      expect(result.id, 'pregunta1');
      verify(mockApiService.getById(
        collectionName: 'detail_preguntas',
        id: 'pregunta1',
      )).called(1);
    });

    test('updatePregunta debe llamar al servicio API', () async {
      // Arrange
      final preguntaData = {
        'pregunta': '¿Cuál es la capital de Colombia actualizada?',
      };

      when(mockApiService.update(
        id: anyNamed('id'),
        data: anyNamed('data'),
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.updatePregunta('pregunta1', preguntaData);

      // Assert
      verify(mockApiService.update(
        id: 'pregunta1',
        data: preguntaData,
        nameCollection: 'detail_preguntas',
      )).called(1);
    });
  });
}
