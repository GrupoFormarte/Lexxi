import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/student/model/resltado_pregunta.dart';

void main() {
  group('ResultadoPregunta Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'idPregunta': 'preg123',
        'asignatura': 'Matemáticas',
        'idEstudiante': 'est456',
        'respuesta': true,
      };

      // Act
      final resultado = ResultadoPregunta.fromJson(json);

      // Assert
      expect(resultado.idPregunta, 'preg123');
      expect(resultado.asignatura, 'Matemáticas');
      expect(resultado.idEstudiante, 'est456');
      expect(resultado.respuesta, true);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final resultado = ResultadoPregunta(
        idPregunta: 'preg789',
        asignatura: 'Ciencias',
        idEstudiante: 'est101',
        respuesta: false,
      );

      // Act
      final json = resultado.toJson();

      // Assert
      expect(json['idPregunta'], 'preg789');
      expect(json['asignatura'], 'Ciencias');
      expect(json['idEstudiante'], 'est101');
      expect(json['respuesta'], false);
    });

    test('debe crear instancia con constructor', () {
      // Arrange & Act
      final resultado = ResultadoPregunta(
        idPregunta: 'preg555',
        asignatura: 'Español',
        idEstudiante: 'est222',
        respuesta: true,
      );

      // Assert
      expect(resultado.idPregunta, 'preg555');
      expect(resultado.asignatura, 'Español');
      expect(resultado.idEstudiante, 'est222');
      expect(resultado.respuesta, true);
    });

    test('debe manejar respuesta false', () {
      // Arrange & Act
      final resultado = ResultadoPregunta(
        idPregunta: 'preg999',
        asignatura: 'Historia',
        idEstudiante: 'est888',
        respuesta: false,
      );

      // Assert
      expect(resultado.respuesta, false);
    });
  });
}
