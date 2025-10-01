import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';

void main() {
  group('Item Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'value': 'Item 1',
        'code': 'I001',
        'name': 'Nombre Item',
        'shortName': 'NI',
        'id': 'id123',
        'childrents': ['child1', 'child2'],
        'colecction': 'items',
        'code_dep': 'DEP001',
      };

      // Act
      final item = Item.fromJson(json);

      // Assert
      expect(item.value, 'Item 1');
      expect(item.code, 'I001');
      expect(item.name, 'Nombre Item');
      expect(item.shortName, 'NI');
      expect(item.id, 'id123');
      expect(item.childrents.length, 2);
      expect(item.colecction, 'items');
      expect(item.codeDep, 'DEP001');
    });

    test('fromJson debe manejar _id alternativo', () {
      // Arrange
      final json = {
        '_id': 'alt_id',
        'value': 'Item 2',
        'code': 'I002',
        'name': 'Nombre',
      };

      // Act
      final item = Item.fromJson(json);

      // Assert
      expect(item.id, 'alt_id');
    });

    test('fromJson debe manejar childrents vacío', () {
      // Arrange
      final json = {
        'value': 'Item 3',
        'code': 'I003',
        'name': 'Nombre',
      };

      // Act
      final item = Item.fromJson(json);

      // Assert
      expect(item.childrents, isEmpty);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final item = Item(
        value: 'Item 4',
        code: 'I004',
        name: 'Nombre Item',
        shortName: 'NI',
        id: 'id456',
        childrents: ['child1', 'child2', 'child3'],
        colecction: 'collection',
      );

      // Act
      final json = item.toJson();

      // Assert
      expect(json['value'], 'Item 4');
      expect(json['code'], 'I004');
      expect(json['name'], 'Nombre Item');
      expect(json['id'], 'id456');
      expect(json['childrents'], isNotEmpty);
      expect(json['childrents'].length, 3);
    });

    test('hasChildren debe verificar si contiene un hijo', () {
      // Arrange
      final item = Item(
        value: 'Item',
        code: 'I005',
        name: 'Nombre',
        childrents: ['child1', 'child2', 'child3'],
      );

      // Act & Assert
      expect(item.hasChildren('child1'), true);
      expect(item.hasChildren('child2'), true);
      expect(item.hasChildren('child4'), false);
    });

    test('getRandomChildren debe retornar todos si n >= childrents.length', () {
      // Arrange
      final item = Item(
        value: 'Item',
        code: 'I006',
        name: 'Nombre',
        childrents: ['child1', 'child2', 'child3'],
      );

      // Act
      final random = item.getRandomChildren(n: 5);

      // Assert
      expect(random.length, 3);
      expect(random.contains('child1'), true);
      expect(random.contains('child2'), true);
      expect(random.contains('child3'), true);
    });

    test('getRandomChildren debe retornar n elementos aleatorios', () {
      // Arrange
      final item = Item(
        value: 'Item',
        code: 'I007',
        name: 'Nombre',
        childrents: ['child1', 'child2', 'child3', 'child4', 'child5'],
      );

      // Act
      final random = item.getRandomChildren(n: 3);

      // Assert
      expect(random.length, 3);
      for (var child in random) {
        expect(item.childrents.contains(child), true);
      }
    });

    test('getRandomChildren debe retornar lista vacía si childrents vacío', () {
      // Arrange
      final item = Item(
        value: 'Item',
        code: 'I008',
        name: 'Nombre',
        childrents: [],
      );

      // Act
      final random = item.getRandomChildren(n: 2);

      // Assert
      expect(random, isEmpty);
    });
  });
}
