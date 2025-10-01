import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';

void main() {
  group('RegisterModel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'type_id': 1,
        'number_id': '123456789',
        'name': 'Juan',
        'second_name': 'Carlos',
        'last_name': 'Pérez',
        'second_last': 'González',
        'email': 'juan@example.com',
        'cellpone': '3001234567',
        'local_district': 'Bogotá',
        'gender': 'M',
        'birthday': '1990-01-01',
        'programa': 'Ingeniería',
        'type_user': 'student',
      };

      // Act
      final register = RegisterModel.fromJson(json);

      // Assert
      expect(register.typeId, 1);
      expect(register.numberId, '123456789');
      expect(register.name, 'Juan');
      expect(register.secondName, 'Carlos');
      expect(register.lastName, 'Pérez');
      expect(register.secondLast, 'González');
      expect(register.email, 'juan@example.com');
      expect(register.cellpone, '3001234567');
      expect(register.localDistrict, 'Bogotá');
      expect(register.gender, 'M');
      expect(register.birthday, '1990-01-01');
      expect(register.programa, 'Ingeniería');
      expect(register.typeUser, 'student');
    });

    test('fromJson debe manejar enroll', () {
      // Arrange
      final json = {
        'name': 'María',
        'email': 'maria@example.com',
        'enroll': {
          'program_id': 5,
        }
      };

      // Act
      final register = RegisterModel.fromJson(json);

      // Assert
      expect(register.enroll, isNotNull);
      expect(register.enroll!.programId, 5);
    });

    test('fromJson debe manejar enroll nulo', () {
      // Arrange
      final json = {
        'name': 'Pedro',
        'email': 'pedro@example.com',
      };

      // Act
      final register = RegisterModel.fromJson(json);

      // Assert
      expect(register.enroll, isNull);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final register = RegisterModel(
        typeId: 2,
        numberId: '987654321',
        name: 'Ana',
        secondName: 'María',
        lastName: 'López',
        email: 'ana@example.com',
        cellpone: '3009876543',
        typeUser: 'teacher',
      );

      // Act
      final json = register.toJson();

      // Assert
      expect(json['type_id'], 2);
      expect(json['number_id'], '987654321');
      expect(json['name'], 'Ana');
      expect(json['second_name'], 'María');
      expect(json['last_name'], 'López');
      expect(json['email'], 'ana@example.com');
      expect(json['cellphone'], '3009876543');
      expect(json['type_user'], 'teacher');
    });

    test('toJson debe incluir enroll cuando existe', () {
      // Arrange
      final enroll = Enroll(programId: 3);
      final register = RegisterModel(
        name: 'Luis',
        email: 'luis@example.com',
        enroll: enroll,
      );

      // Act
      final json = register.toJson();

      // Assert
      expect(json['enroll'], isNotNull);
      expect(json['enroll']['program_id'], 3);
    });
  });

  group('Enroll Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'program_id': 7,
      };

      // Act
      final enroll = Enroll.fromJson(json);

      // Assert
      expect(enroll.programId, 7);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final enroll = Enroll(programId: 9);

      // Act
      final json = enroll.toJson();

      // Assert
      expect(json['program_id'], 9);
    });

    test('debe crear instancia con constructor', () {
      // Arrange & Act
      final enroll = Enroll(programId: 4);

      // Assert
      expect(enroll.programId, 4);
    });
  });
}
