import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/student/model/student.dart';

void main() {
  group('Student Model Tests', () {
    test('Student.fromJson debe crear instancia desde JSON', () {
      // Arrange
      final json = {
        'id_student': '123',
        'nombre': 'Juan Perez',
        'idInstituto': '1',
        'score_total': '100',
        'position': 1,
        'name': 'Juan',
        'second_name': 'Carlos',
        'last_name': 'Perez',
        'second_last_name': 'Lopez',
        'document_type_id': 1,
        'document_type': 'CC',
        'identification_number': '12345678',
        'email': 'juan@test.com',
        'cellphone': '3001234567',
        'grados': [],
      };

      // Act
      final student = Student.fromJson(json);

      // Assert
      expect(student.idStudent, '123');
      expect(student.nombre, 'Juan Perez');
      expect(student.email, 'juan@test.com');
      expect(student.score, '100');
      expect(student.position, 1);
    });

    test('Student.toJson debe convertir a JSON correctamente', () {
      // Arrange
      final student = Student(
        idStudent: '123',
        nombre: 'Maria Garcia',
        idInstituto: '1',
        score: '95',
        email: 'maria@test.com',
      );

      // Act
      final json = student.toJson();

      // Assert
      expect(json['id_student'], '123');
      expect(json['nombre'], 'Maria Garcia');
      expect(json['email'], 'maria@test.com');
    });

    test('Student.fromJson debe manejar grados vacios', () {
      // Arrange
      final json = {
        'id_student': '456',
        'nombre': 'Pedro',
      };

      // Act
      final student = Student.fromJson(json);

      // Assert
      expect(student.grados, isEmpty);
    });

    test('Student.fromJson debe manejar config nulo', () {
      // Arrange
      final json = {
        'id_student': '789',
        'nombre': 'Ana',
      };

      // Act
      final student = Student.fromJson(json);

      // Assert
      expect(student.config, isNull);
    });
  });
}
