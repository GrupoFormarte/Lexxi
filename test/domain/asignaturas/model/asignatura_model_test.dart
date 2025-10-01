import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/asignaturas/model/asignatura_model.dart';

void main() {
  group('Asignatura Model Tests', () {
    test('Asignatura.fromJson debe crear instancia desde JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'value': 'Matematicas',
        'grado_id': 10,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      };

      // Act
      final asignatura = Asignatura.fromJson(json);

      // Assert
      expect(asignatura.id, 1);
      expect(asignatura.value, 'Matematicas');
      expect(asignatura.gradoId, 10);
      expect(asignatura.createdAt, isNotNull);
      expect(asignatura.updatedAt, isNotNull);
    });

    test('Asignatura.toJson debe convertir a JSON correctamente', () {
      // Arrange
      final asignatura = Asignatura(
        id: 1,
        value: 'Espanol',
        gradoId: 11,
      );

      // Act
      final json = asignatura.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['value'], 'Espanol');
      expect(json['grado_id'], 11);
    });

    test('Asignatura.fromJson debe manejar fechas nulas', () {
      // Arrange
      final json = {
        'id': 1,
        'value': 'Ciencias',
        'grado_id': 9,
      };

      // Act
      final asignatura = Asignatura.fromJson(json);

      // Assert
      expect(asignatura.createdAt, isNull);
      expect(asignatura.updatedAt, isNull);
    });
  });
}
