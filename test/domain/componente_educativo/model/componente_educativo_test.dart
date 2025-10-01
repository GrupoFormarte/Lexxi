import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';

void main() {
  group('ComponenteEducativo Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'id_recurso': 'recurso123',
        'tipo_recurso': 'leccion',
        'id': 'comp456',
        'componente': [
          {'insert': 'Texto de prueba'},
        ],
      };

      // Act
      final componente = ComponenteEducativo.fromJson(json);

      // Assert
      expect(componente.idRecurso, 'recurso123');
      expect(componente.tipoRecurso, 'leccion');
      expect(componente.id, 'comp456');
      expect(componente.componente, isNotEmpty);
    });

    test('fromJson debe manejar _id alternativo', () {
      // Arrange
      final json = {
        '_id': 'comp789',
        'id_recurso': 'recurso456',
        'tipo_recurso': 'ejercicio',
        'componente': <Map<String, dynamic>>[],
      };

      // Act
      final componente = ComponenteEducativo.fromJson(json);

      // Assert
      expect(componente.id, 'comp789');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final componente = ComponenteEducativo(
        idRecurso: 'recurso789',
        tipoRecurso: 'video',
        id: 'comp111',
        componente: [
          {'insert': 'Contenido'},
        ],
      );

      // Act
      final json = componente.toJson();

      // Assert
      expect(json['id_recurso'], 'recurso789');
      expect(json['tipo_recurso'], 'video');
      expect(json['id'], 'comp111');
      expect(json['componente'], isNotEmpty);
    });

    test('toListMap debe convertir lista correctamente', () {
      // Arrange
      final componente = ComponenteEducativo();
      final componentes = [
        {'insert': 'Texto 1'},
        {'insert': 'Texto 2'},
      ];

      // Act
      final result = componente.toListMap(componentes);

      // Assert
      expect(result.length, 2);
      expect(result[0]['insert'], 'Texto 1');
      expect(result[1]['insert'], 'Texto 2');
    });

    test('debe crear instancia con valores por defecto', () {
      // Arrange & Act
      final componente = ComponenteEducativo();

      // Assert
      expect(componente.componente, isEmpty);
      expect(componente.idRecurso, isNull);
      expect(componente.tipoRecurso, isNull);
      expect(componente.id, isNull);
    });

    test('debe crear instancia con componente personalizado', () {
      // Arrange & Act
      final componente = ComponenteEducativo(
        idRecurso: 'rec123',
        tipoRecurso: 'leccion',
        componente: [
          {'insert': 'Test'},
        ],
      );

      // Assert
      expect(componente.componente.length, 1);
      expect(componente.idRecurso, 'rec123');
    });
  });

  group('Componente Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {'key': 'value'};

      // Act
      final componente = Componente.fromJson(json);

      // Assert
      expect(componente, isNotNull);
    });

    test('toJson debe retornar mapa vacío', () {
      // Arrange
      final componente = Componente();

      // Act
      final json = componente.toJson();

      // Assert
      expect(json, isEmpty);
    });
  });
}
