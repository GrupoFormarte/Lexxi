import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/academic_level/model/academic_level.dart';

void main() {
  group('AcademicLevelModel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'id_grado': 'grado1',
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

      // Act
      final model = AcademicLevelModel.fromJson(json);

      // Assert
      expect(model.idGrado, 'grado1');
      expect(model.levelMax, '100');
      expect(model.typesLevels.length, 1);
      expect(model.typesLevels.first.name, 'Principiante');
    });

    test('fromJson debe manejar types_levels vacío', () {
      // Arrange
      final json = {
        'id_grado': 'grado2',
      };

      // Act
      final model = AcademicLevelModel.fromJson(json);

      // Assert
      expect(model.typesLevels, isEmpty);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final levels = [
        Level(level: 'Nivel 1', puntaje: '30'),
        Level(level: 'Nivel 2', puntaje: '60'),
      ];
      final typeLevel = TypeLevel(
        name: 'Intermedio',
        color: '00FF00',
        min: '0',
        max: '60',
        levels: levels,
      );
      final model = AcademicLevelModel(
        idGrado: 'grado3',
        typesLevels: [typeLevel],
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id_grado'], 'grado3');
      expect(json['levelMax'], '60');
      expect(json['types_levels'], isNotEmpty);
    });

    test('compare debe retornar TypeLevel correcto', () {
      // Arrange
      final levels1 = [
        Level(level: 'Nivel 1', puntaje: '25'),
        Level(level: 'Nivel 2', puntaje: '50'),
      ];
      final levels2 = [
        Level(level: 'Nivel 3', puntaje: '75'),
        Level(level: 'Nivel 4', puntaje: '100'),
      ];
      final typeLevel1 = TypeLevel(
        name: 'Principiante',
        color: 'FF0000',
        min: '0',
        max: '50',
        levels: levels1,
      );
      final typeLevel2 = TypeLevel(
        name: 'Avanzado',
        color: '0000FF',
        min: '51',
        max: '100',
        levels: levels2,
      );
      final model = AcademicLevelModel(
        typesLevels: [typeLevel1, typeLevel2],
      );

      // Act
      final result = model.compare('30');

      // Assert
      expect(result, isNotNull);
      expect(result!.name, 'Principiante');
    });

    test('compare debe retornar primer TypeLevel si puntaje menor al mínimo',
        () {
      // Arrange
      final levels = [
        Level(level: 'Nivel 1', puntaje: '50'),
      ];
      final typeLevel = TypeLevel(
        name: 'Principiante',
        color: 'FF0000',
        min: '25',
        max: '50',
        levels: levels,
      );
      final model = AcademicLevelModel(typesLevels: [typeLevel]);

      // Act
      final result = model.compare('10');

      // Assert
      expect(result, isNotNull);
      expect(result!.name, 'Principiante');
    });
  });

  group('TypeLevel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'name': 'Intermedio',
        'color': '00FF00',
        'min': '20',
        'max': '60',
        'levels': [
          {'level': 'Nivel 1', 'puntaje': '40'},
          {'level': 'Nivel 2', 'puntaje': '60'},
        ],
      };

      // Act
      final typeLevel = TypeLevel.fromJson(json);

      // Assert
      expect(typeLevel.name, 'Intermedio');
      expect(typeLevel.color, '00FF00');
      expect(typeLevel.min, '20');
      expect(typeLevel.max, '60');
      expect(typeLevel.levels.length, 2);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final levels = [
        Level(level: 'Nivel 1', puntaje: '20'),
        Level(level: 'Nivel 2', puntaje: '40'),
      ];
      final typeLevel = TypeLevel(
        name: 'Avanzado',
        color: '0000FF',
        min: '10',
        max: '40',
        levels: levels,
      );

      // Act
      final json = typeLevel.toJson();

      // Assert
      expect(json['name'], 'Avanzado');
      expect(json['color'], '0000FF');
      expect(json['min'], '20');
      expect(json['max'], '40');
      expect(json['levels'], isNotEmpty);
    });

    test('getColor debe retornar Color válido', () {
      // Arrange
      final levels = [Level(level: 'Nivel 1', puntaje: '50')];
      final typeLevel = TypeLevel(
        name: 'Test',
        color: 'FF5733',
        levels: levels,
      );

      // Act
      final color = typeLevel.getColor();

      // Assert
      expect(color.value, 0xFFFF5733);
    });

    test('findLevelByPuntaje debe retornar Level correcto', () {
      // Arrange
      final levels = [
        Level(level: 'Nivel 1', puntaje: '25'),
        Level(level: 'Nivel 2', puntaje: '50'),
        Level(level: 'Nivel 3', puntaje: '75'),
      ];
      final typeLevel = TypeLevel(
        name: 'Test',
        color: 'FF0000',
        levels: levels,
      );

      // Act
      final result = typeLevel.findLevelByPuntaje('40');

      // Assert
      expect(result, isNotNull);
      expect(result!.level, 'Nivel 2');
    });

    test('findLevelByPuntaje debe retornar primer nivel si puntaje menor',
        () {
      // Arrange
      final levels = [
        Level(level: 'Nivel 1', puntaje: '50'),
        Level(level: 'Nivel 2', puntaje: '100'),
      ];
      final typeLevel = TypeLevel(
        name: 'Test',
        color: 'FF0000',
        levels: levels,
      );

      // Act
      final result = typeLevel.findLevelByPuntaje('10');

      // Assert
      expect(result, isNotNull);
      expect(result!.level, 'Nivel 1');
    });

    test('findLevelByPuntaje debe retornar último nivel si puntaje mayor', () {
      // Arrange
      final levels = [
        Level(level: 'Nivel 1', puntaje: '50'),
        Level(level: 'Nivel 2', puntaje: '100'),
      ];
      final typeLevel = TypeLevel(
        name: 'Test',
        color: 'FF0000',
        levels: levels,
      );

      // Act
      final result = typeLevel.findLevelByPuntaje('150');

      // Assert
      expect(result, isNotNull);
      expect(result!.level, 'Nivel 2');
    });

    test('operator == debe comparar TypeLevel correctamente', () {
      // Arrange
      final levels = [Level(level: 'Nivel 1', puntaje: '50')];
      final typeLevel1 = TypeLevel(
        name: 'Test',
        color: 'FF0000',
        min: '0',
        max: '50',
        levels: levels,
      );
      final typeLevel2 = TypeLevel(
        name: 'Test',
        color: 'FF0000',
        min: '0',
        max: '50',
        levels: levels,
      );

      // Act & Assert
      expect(typeLevel1 == typeLevel2, true);
    });
  });

  group('Level Tests (dentro de academic_level)', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'level': 'Nivel A',
        'puntaje': '85',
      };

      // Act
      final level = Level.fromJson(json);

      // Assert
      expect(level.level, 'Nivel A');
      expect(level.puntaje, '85');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final level = Level(
        level: 'Nivel B',
        puntaje: '95',
      );

      // Act
      final json = level.toJson();

      // Assert
      expect(json['level'], 'Nivel B');
      expect(json['puntaje'], '95');
    });

    test('operator == debe comparar Level correctamente', () {
      // Arrange
      final level1 = Level(level: 'Nivel 1', puntaje: '50');
      final level2 = Level(level: 'Nivel 1', puntaje: '50');

      // Act & Assert
      expect(level1 == level2, true);
    });

    test('operator == debe detectar diferencias', () {
      // Arrange
      final level1 = Level(level: 'Nivel 1', puntaje: '50');
      final level2 = Level(level: 'Nivel 2', puntaje: '60');

      // Act & Assert
      expect(level1 == level2, false);
    });
  });
}
