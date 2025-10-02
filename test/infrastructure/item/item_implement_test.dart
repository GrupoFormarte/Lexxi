import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/item/item_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';

import 'item_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late ItemImplement implementation;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    implementation = ItemImplement(mockApiService);
  });

  group('ItemImplement Tests', () {
    test('createItem debe retornar el ID del item creado', () async {
      // Arrange
      final item = Item(
        id: 'item123',
        value: 'Test Item',
        code: 'TEST001',
      );

      when(mockApiService.create(
        data: anyNamed('data'),
        collectionName: anyNamed('collectionName'),
      )).thenAnswer((_) async => {'_id': 'item123'});

      // Act
      final result = await implementation.createItem(
        collection: 'items',
        item: item,
      );

      // Assert
      expect(result, 'item123');
      verify(mockApiService.create(
        data: item.toJson(),
        collectionName: 'items',
      )).called(1);
    });

    test('getAllItems debe retornar lista de items', () async {
      // Arrange
      final mockData = [
        {
          '_id': 'item1',
          'value': 'Item 1',
          'code': 'CODE1',
        },
        {
          '_id': 'item2',
          'value': 'Item 2',
          'code': 'CODE2',
        },
      ];

      when(mockApiService.getAll(
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getAllItems(collection: 'items');

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, 'item1');
      expect(result[1].id, 'item2');
      verify(mockApiService.getAll(
        nameCollection: 'items',
      )).called(1);
    });

    test('getItemById debe retornar item cuando existe', () async {
      // Arrange
      final mockData = {
        'value': 'Item 1',
        'code': 'CODE1',
      };

      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getItemById(
        collection: 'items',
        id: 'item1',
      );

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'item1');
      verify(mockApiService.getById(
        collectionName: 'items',
        id: 'item1',
      )).called(1);
    });

    test('getItemById debe retornar null cuando no existe', () async {
      // Arrange
      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => null);

      // Act
      final result = await implementation.getItemById(
        collection: 'items',
        id: 'item1',
      );

      // Assert
      expect(result, isNull);
    });

    test('updateItem debe llamar al servicio API', () async {
      // Arrange
      final item = Item(
        id: 'item1',
        value: 'Updated Item',
        code: 'CODE1',
      );

      when(mockApiService.update(
        id: anyNamed('id'),
        nameCollection: anyNamed('nameCollection'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.updateItem(
        collection: 'items',
        item: item,
      );

      // Assert
      verify(mockApiService.update(
        id: 'item1',
        nameCollection: 'items',
        data: item.toJson(),
      )).called(1);
    });

    test('deleteItem debe llamar al servicio API', () async {
      // Arrange
      when(mockApiService.delete(any, any)).thenAnswer((_) async => true);

      // Act
      await implementation.deleteItem(
        collection: 'items',
        id: 'item1',
      );

      // Assert
      verify(mockApiService.delete('items', 'item1')).called(1);
    });

    test('searchByField debe retornar items filtrados', () async {
      // Arrange
      final mockData = [
        {
          '_id': 'item1',
          'value': 'Item 1',
          'code': 'CODE1',
        },
      ];

      when(mockApiService.searchByField(any, any, any))
          .thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.searchByField(
        collection: 'items',
        field: 'code',
        value: 'CODE1',
      );

      // Assert
      expect(result, hasLength(1));
      expect(result[0].id, 'item1');
      verify(mockApiService.searchByField('items', 'code', 'CODE1')).called(1);
    });

    test('searchByField debe retornar lista vacía cuando no hay resultados',
        () async {
      // Arrange
      when(mockApiService.searchByField(any, any, any))
          .thenAnswer((_) async => null);

      // Act
      final result = await implementation.searchByField(
        collection: 'items',
        field: 'code',
        value: 'NONEXISTENT',
      );

      // Assert
      expect(result, isEmpty);
    });

    test('getItemsByIdsBulk debe retornar items por IDs', () async {
      // Arrange
      final mockData = [
        {
          '_id': 'item1',
          'value': 'Item 1',
          'code': 'CODE1',
        },
        {
          '_id': 'item2',
          'value': 'Item 2',
          'code': 'CODE2',
        },
      ];

      when(mockApiService.post(
        endPoint: anyNamed('endPoint'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getItemsByIdsBulk(
        collection: 'items/bulk',
        ids: ['item1', 'item2'],
        grado: '11',
      );

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, 'item1');
      expect(result[1].id, 'item2');
    });

    test('getSimulacro debe retornar lista de IDs', () async {
      // Arrange
      final mockData = {
        'data': ['id1', 'id2', 'id3']
      };

      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getSimulacro(
        grado: '11',
        cantidad: 3,
      );

      // Assert
      expect(result, hasLength(3));
      expect(result, ['id1', 'id2', 'id3']);
      verify(mockApiService.getById(
        collectionName: 'generate-simulacro',
        id: '11/3',
      )).called(1);
    });
  });
}
