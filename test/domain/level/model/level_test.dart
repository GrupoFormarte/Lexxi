import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/level/model/level.dart';

void main() {
  group('Level Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'level': 'Nivel 1',
        'currentColor': '#FF5733',
        'typeName': 'Principiante',
        'previousColor': '#00FF00',
      };

      // Act
      final level = Level.fromJson(json);

      // Assert
      expect(level.level, 'Nivel 1');
      expect(level.currentColor, '#FF5733');
      expect(level.typeName, 'Principiante');
      expect(level.previousColor, '#00FF00');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final level = Level(
        level: 'Nivel 2',
        currentColor: '#0000FF',
        typeName: 'Intermedio',
        previousColor: '#FF0000',
      );

      // Act
      final json = level.toJson();

      // Assert
      expect(json['level'], 'Nivel 2');
      expect(json['currentColor'], '#0000FF');
      expect(json['typeName'], 'Intermedio');
      expect(json['previousColor'], '#FF0000');
    });

    test('debe crear instancia con constructor', () {
      // Arrange & Act
      final level = Level(
        level: 'Nivel 3',
        currentColor: '#FFFF00',
        typeName: 'Avanzado',
        previousColor: '#0000FF',
      );

      // Assert
      expect(level.level, 'Nivel 3');
      expect(level.currentColor, '#FFFF00');
      expect(level.typeName, 'Avanzado');
      expect(level.previousColor, '#0000FF');
    });

    test('debe manejar valores nulos', () {
      // Arrange & Act
      final level = Level();

      // Assert
      expect(level.level, isNull);
      expect(level.currentColor, isNull);
      expect(level.typeName, isNull);
      expect(level.previousColor, isNull);
    });
  });
}
