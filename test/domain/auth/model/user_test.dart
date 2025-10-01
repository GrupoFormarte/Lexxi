import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/auth/model/user.dart';

void main() {
  group('User Model Tests', () {
    test('User.fromJson debe crear una instancia válida desde JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Juan',
        'second_name': 'Carlos',
        'last_name': 'Pérez',
        'second_last': 'López',
        'type_id': 1,
        'identification_number': '12345678',
        'email': 'juan@test.com',
        'gender': 'M',
        'phone': '1234567',
        'cellphone': '3001234567',
        'address': 'Calle 123',
        'neighborhood': 'Centro',
        'birthday': '1990-01-01',
        'company': 'Test Company',
        'company_phone': '1234567',
        'profile': 'student',
        'token': 'test_token',
        'type_user': 'student',
        'active': 1,
        'institute': 1,
        'grado': []
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, equals(1));
      expect(user.name, equals('Juan'));
      expect(user.email, equals('juan@test.com'));
      expect(user.token, equals('test_token'));
      expect(user.active, equals(1));
    });

    test('User.toJson debe convertir correctamente a JSON', () {
      // Arrange
      final user = User(
        id: 1,
        name: 'Juan',
        email: 'juan@test.com',
        token: 'test_token',
        active: 1,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], equals(1));
      expect(json['name'], equals('Juan'));
      expect(json['email'], equals('juan@test.com'));
      expect(json['token'], equals('test_token'));
      expect(json['active'], equals(1));
    });

    test('User.fromJson debe manejar _id alternativo', () {
      // Arrange
      final json = {
        '_id': '507f1f77bcf86cd799439011',
        'name': 'Test User',
        'email': 'test@test.com',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, equals('507f1f77bcf86cd799439011'));
    });

    test('User.fromJson debe manejar grado vacío', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Juan',
        'email': 'juan@test.com',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.grado, isEmpty);
    });

    test('User.fromJson debe parsear lista de grados correctamente', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Juan',
        'email': 'juan@test.com',
        'grado': [
          {
            'id': 'g1',
            'studentId': 1,
            'programCode': 'MAT101',
            'programName': 'Matemáticas',
            'shortName': 'MAT',
            'status': 1,
          }
        ]
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.grado, isNotEmpty);
      expect(user.grado!.length, equals(1));
      expect(user.grado![0].programCode, equals('MAT101'));
    });
  });

  group('Grado Model Tests', () {
    test('Grado.fromJson debe crear una instancia válida desde JSON', () {
      // Arrange
      final json = {
        'id': 'g1',
        'studentId': 1,
        'programCode': 'MAT101',
        'programName': 'Matemáticas',
        'shortName': 'MAT',
        'status': 1,
      };

      // Act
      final grado = Grado.fromJson(json);

      // Assert
      expect(grado.id, equals('g1'));
      expect(grado.studentId, equals(1));
      expect(grado.programCode, equals('MAT101'));
      expect(grado.programName, equals('Matemáticas'));
      expect(grado.shortName, equals('MAT'));
      expect(grado.status, equals(1));
    });

    test('Grado.toJson debe convertir correctamente a JSON', () {
      // Arrange
      final grado = Grado(
        id: 'g1',
        studentId: 1,
        programCode: 'MAT101',
        programName: 'Matemáticas',
        shortName: 'MAT',
        status: 1,
      );

      // Act
      final json = grado.toJson();

      // Assert
      expect(json['id'], equals('g1'));
      expect(json['studentId'], equals(1));
      expect(json['programCode'], equals('MAT101'));
      expect(json['programName'], equals('Matemáticas'));
      expect(json['shortName'], equals('MAT'));
      expect(json['status'], equals(1));
    });
  });
}
