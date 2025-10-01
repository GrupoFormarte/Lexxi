import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/asignaturas/model/resultado_asignatura.dart';

void main() {
  group('ResultadoAsignatura Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'id_estudiante': 'est123',
        'id_asignatura': 'asig456',
        'puntaje': 85.5,
        'asignatura_value': 'Matemáticas',
      };

      // Act
      final resultado = ResultadoAsignatura.fromJson(json);

      // Assert
      expect(resultado.idEstudiante, 'est123');
      expect(resultado.idAsignatura, 'asig456');
      expect(resultado.puntaje, 85.5);
      expect(resultado.asignaturaValue, 'Matemáticas');
    });

    test('fromJson debe parsear puntaje como double desde string', () {
      // Arrange
      final json = {
        'id_estudiante': 'est789',
        'id_asignatura': 'asig101',
        'puntaje': '92.3',
        'asignatura_value': 'Ciencias',
      };

      // Act
      final resultado = ResultadoAsignatura.fromJson(json);

      // Assert
      expect(resultado.puntaje, 92.3);
    });

    test('fromJson debe parsear puntaje como double desde int', () {
      // Arrange
      final json = {
        'id_estudiante': 'est456',
        'id_asignatura': 'asig789',
        'puntaje': 75,
        'asignatura_value': 'Historia',
      };

      // Act
      final resultado = ResultadoAsignatura.fromJson(json);

      // Assert
      expect(resultado.puntaje, 75.0);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final resultado = ResultadoAsignatura(
        idEstudiante: 'est111',
        idAsignatura: 'asig222',
        puntaje: 88.7,
        asignaturaValue: 'Español',
      );

      // Act
      final json = resultado.toJson();

      // Assert
      expect(json['id_estudiante'], 'est111');
      expect(json['id_asignatura'], 'asig222');
      expect(json['puntaje'], 88.7);
      expect(json['asignatura_value'], 'Español');
    });

    test('debe crear instancia con constructor', () {
      // Arrange & Act
      final resultado = ResultadoAsignatura(
        idEstudiante: 'est333',
        idAsignatura: 'asig444',
        puntaje: 95.0,
        asignaturaValue: 'Física',
      );

      // Assert
      expect(resultado.idEstudiante, 'est333');
      expect(resultado.idAsignatura, 'asig444');
      expect(resultado.puntaje, 95.0);
      expect(resultado.asignaturaValue, 'Física');
    });

    test('debe manejar valores nulos', () {
      // Arrange & Act
      final resultado = ResultadoAsignatura();

      // Assert
      expect(resultado.idEstudiante, isNull);
      expect(resultado.idAsignatura, isNull);
      expect(resultado.puntaje, isNull);
      expect(resultado.asignaturaValue, isNull);
    });
  });
}
