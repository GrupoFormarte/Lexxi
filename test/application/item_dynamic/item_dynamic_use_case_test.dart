import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/domain/item_dynamic/repository/item_repository.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';

import 'item_dynamic_use_case_test.mocks.dart';

@GenerateMocks([IItemRepository])
void main() {
  late ItemDynamicUseCase useCase;
  late MockIItemRepository mockRepository;

  setUp(() {
    mockRepository = MockIItemRepository();
    useCase = ItemDynamicUseCase(mockRepository);
  });

  group('ItemDynamicUseCase Tests', () {
    test('createItem debe llamar al repositorio', () async {
      // Arrange
      const collection = 'items';
      final item = Item(value: 'Test', code: '001', name: 'Test Item');

      when(mockRepository.createItem(collection: collection, item: item))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase.createItem(collection: collection, item: item);

      // Assert
      verify(mockRepository.createItem(collection: collection, item: item))
          .called(1);
    });

    test('getItemById debe retornar item cuando existe', () async {
      // Arrange
      const collection = 'items';
      const id = '1';
      final item = Item(value: 'Test', code: '001', name: 'Test Item', id: id);

      when(mockRepository.getItemById(collection: collection, id: id))
          .thenAnswer((_) async => item);

      // Act
      final result = await useCase.getItemById(collection: collection, id: id);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, id);
      verify(mockRepository.getItemById(collection: collection, id: id))
          .called(1);
    });

    test('getAllItems debe retornar lista de items', () async {
      // Arrange
      const collection = 'items';
      final items = [
        Item(value: 'Item 1', code: '001', name: 'First'),
        Item(value: 'Item 2', code: '002', name: 'Second'),
      ];

      when(mockRepository.getAllItems(collection: collection))
          .thenAnswer((_) async => items);

      // Act
      final result = await useCase.getAllItems(collection: collection);

      // Assert
      expect(result, hasLength(2));
      verify(mockRepository.getAllItems(collection: collection)).called(1);
    });

    test('updateItem debe llamar al repositorio', () async {
      // Arrange
      const collection = 'items';
      final item = Item(value: 'Updated', code: '001', name: 'Updated Item');

      when(mockRepository.updateItem(collection: collection, item: item))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase.updateItem(collection: collection, item: item);

      // Assert
      verify(mockRepository.updateItem(collection: collection, item: item))
          .called(1);
    });

    test('deleteItem debe llamar al repositorio', () async {
      // Arrange
      const collection = 'items';
      const id = '1';

      when(mockRepository.deleteItem(collection: collection, id: id))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase.deleteItem(collection: collection, id: id);

      // Assert
      verify(mockRepository.deleteItem(collection: collection, id: id))
          .called(1);
    });

    test('searchByField debe retornar items filtrados', () async {
      // Arrange
      const collection = 'items';
      const field = 'name';
      const value = 'Test';
      final items = [
        Item(value: 'Test', code: '001', name: 'Test Item'),
      ];

      when(mockRepository.searchByField(
              collection: collection, field: field, value: value))
          .thenAnswer((_) async => items);

      // Act
      final result = await useCase.searchByField(
          collection: collection, field: field, value: value);

      // Assert
      expect(result, hasLength(1));
      verify(mockRepository.searchByField(
              collection: collection, field: field, value: value))
          .called(1);
    });

    test('getChildrents debe retornar lista de items hijos', () async {
      // Arrange
      const collection = 'items';
      final ids = ['1', '2'];
      final item1 = Item(value: 'Item 1', code: '001', name: 'First', id: '1');
      final item2 =
          Item(value: 'Item 2', code: '002', name: 'Second', id: '2');

      when(mockRepository.getItemById(collection: collection, id: '1'))
          .thenAnswer((_) async => item1);
      when(mockRepository.getItemById(collection: collection, id: '2'))
          .thenAnswer((_) async => item2);

      // Act
      final result =
          await useCase.getChildrents(collection: collection, ids: ids);

      // Assert
      expect(result, hasLength(2));
      verify(mockRepository.getItemById(collection: collection, id: '1'))
          .called(1);
      verify(mockRepository.getItemById(collection: collection, id: '2'))
          .called(1);
    });

    test('getChildrents debe manejar errores y continuar', () async {
      // Arrange
      const collection = 'items';
      final ids = ['1', '2', '3'];
      final item1 = Item(value: 'Item 1', code: '001', name: 'First', id: '1');
      final item3 = Item(value: 'Item 3', code: '003', name: 'Third', id: '3');

      when(mockRepository.getItemById(collection: collection, id: '1'))
          .thenAnswer((_) async => item1);
      when(mockRepository.getItemById(collection: collection, id: '2'))
          .thenThrow(Exception('Item not found'));
      when(mockRepository.getItemById(collection: collection, id: '3'))
          .thenAnswer((_) async => item3);

      // Act
      final result =
          await useCase.getChildrents(collection: collection, ids: ids);

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, '1');
      expect(result[1].id, '3');
    });

    test('getSimulacro debe retornar lista de IDs', () async {
      // Arrange
      const grado = '11';
      const cantidad = 5;
      final ids = ['id1', 'id2', 'id3', 'id4', 'id5'];

      when(mockRepository.getSimulacro(grado: grado, cantidad: cantidad))
          .thenAnswer((_) async => ids);

      // Act
      final result =
          await useCase.getSimulacro(grado: grado, cantidad: cantidad);

      // Assert
      expect(result, hasLength(5));
      verify(mockRepository.getSimulacro(grado: grado, cantidad: cantidad))
          .called(1);
    });

    test('getItemsByIdsBulk debe retornar items por lote', () async {
      // Arrange
      const collection = 'items';
      final ids = ['1', '2', '3'];
      const grado = '10';
      final items = [
        Item(value: 'Item 1', code: '001', name: 'First'),
        Item(value: 'Item 2', code: '002', name: 'Second'),
        Item(value: 'Item 3', code: '003', name: 'Third'),
      ];

      when(mockRepository.getItemsByIdsBulk(
              collection: collection, ids: ids, grado: grado))
          .thenAnswer((_) async => items);

      // Act
      final result = await useCase.getItemsByIdsBulk(
          collection: collection, ids: ids, grado: grado);

      // Assert
      expect(result, hasLength(3));
      verify(mockRepository.getItemsByIdsBulk(
              collection: collection, ids: ids, grado: grado))
          .called(1);
    });
  });
}
