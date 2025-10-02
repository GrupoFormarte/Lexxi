import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/componente_educativo/componente_educativo_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';

import 'componente_educativo_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late ComponenteEducativoImplement implementation;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    implementation = ComponenteEducativoImplement(mockApiService);
  });

  group('ComponenteEducativoImplement Tests', () {
    test('create debe retornar el ID del componente creado', () async {
      // Arrange
      final componente = ComponenteEducativo(
        id: 'comp123',
        idRecurso: 'recurso456',
        tipoRecurso: 'ejercicio',
        componente: <Map<String, dynamic>>[],
      );

      when(mockApiService.create(
        data: anyNamed('data'),
        collectionName: anyNamed('collectionName'),
      )).thenAnswer((_) async => {'_id': 'comp123'});

      // Act
      final result = await implementation.create(
        data: componente,
        collection: 'componentes_educativos',
      );

      // Assert
      expect(result, 'comp123');
      verify(mockApiService.create(
        data: componente.toJson(),
        collectionName: 'componentes_educativos',
      )).called(1);
    });

    test('getAll debe retornar lista de componentes educativos', () async {
      // Arrange
      final mockData = [
        {
          '_id': 'comp1',
          'id_recurso': 'recurso1',
          'tipo_recurso': 'ejercicio',
          'componente': <Map<String, dynamic>>[],
        },
        {
          '_id': 'comp2',
          'id_recurso': 'recurso2',
          'tipo_recurso': 'lectura',
          'componente': <Map<String, dynamic>>[],
        },
      ];

      when(mockApiService.getAll(
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getAll(
        collection: 'componentes_educativos',
      );

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, 'comp1');
      expect(result[0].idRecurso, 'recurso1');
      expect(result[1].id, 'comp2');
      verify(mockApiService.getAll(
        nameCollection: 'componentes_educativos',
      )).called(1);
    });

    test('getById debe retornar componente educativo', () async {
      // Arrange
      final mockData = {
        '_id': 'comp1',
        'id_recurso': 'recurso1',
        'tipo_recurso': 'ejercicio',
        'componente': <Map<String, dynamic>>[],
      };

      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getById(
        id: 'comp1',
        collection: 'componentes_educativos',
      );

      // Assert
      expect(result.id, 'comp1');
      expect(result.idRecurso, 'recurso1');
      expect(result.tipoRecurso, 'ejercicio');
      verify(mockApiService.getById(
        collectionName: 'componentes_educativos',
        id: 'comp1',
      )).called(1);
    });

    test('update debe llamar al servicio API', () async {
      // Arrange
      final componente = ComponenteEducativo(
        id: 'comp1',
        idRecurso: 'recurso1',
        tipoRecurso: 'ejercicio',
        componente: <Map<String, dynamic>>[],
      );

      when(mockApiService.update(
        id: anyNamed('id'),
        data: anyNamed('data'),
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.update(
        data: componente,
        id: 'comp1',
        collection: 'componentes_educativos',
      );

      // Assert
      verify(mockApiService.update(
        id: 'comp1',
        data: componente.toJson(),
        nameCollection: 'componentes_educativos',
      )).called(1);
    });

    test('search debe retornar lista de componentes filtrados', () async {
      // Arrange
      final mockData = [
        {
          '_id': 'comp1',
          'id_recurso': 'recurso1',
          'tipo_recurso': 'ejercicio',
          'componente': <Map<String, dynamic>>[],
        },
      ];

      when(mockApiService.searchByFields(
        collectionName: anyNamed('collectionName'),
        query: anyNamed('query'),
        fields: anyNamed('fields'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.search(
        collection: 'componentes_educativos',
        searchTerm: 'ejercicio',
        fields: ['tipo_recurso'],
      );

      // Assert
      expect(result, hasLength(1));
      expect(result[0].tipoRecurso, 'ejercicio');
      verify(mockApiService.searchByFields(
        collectionName: 'componentes_educativos',
        query: 'ejercicio',
        fields: ['tipo_recurso'],
      )).called(1);
    });
  });
}
