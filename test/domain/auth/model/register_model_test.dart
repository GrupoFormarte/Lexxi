import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/model/register_wizard_data.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';

void main() {
  group('RegisterModel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'name': 'Juan',
        'birthday': '1990-01-01',
        'department': 'Cundinamarca',
        'local_district': 'Bogotá',
        'how_did_you_know_us': ['Instagram', 'Un amigo'],
        'how_did_you_know_us_other': '',
        'exam_goal': 'saber11',
        'email': 'juan@example.com',
        'password': '123456',
        'type_user': 'student',
      };

      // Act
      final register = RegisterModel.fromJson(json);

      // Assert
      expect(register.name, 'Juan');
      expect(register.birthday, '1990-01-01');
      expect(register.department, 'Cundinamarca');
      expect(register.localDistrict, 'Bogotá');
      expect(register.howDidYouKnowUs, ['Instagram', 'Un amigo']);
      expect(register.howDidYouKnowUsOther, '');
      expect(register.examGoal, 'saber11');
      expect(register.email, 'juan@example.com');
      expect(register.password, '123456');
      expect(register.typeUser, 'student');
    });

    test('fromJson debe usar "student" por defecto si no viene type_user', () {
      // Arrange
      final json = {
        'name': 'María',
        'email': 'maria@example.com',
      };

      // Act
      final register = RegisterModel.fromJson(json);

      // Assert
      expect(register.typeUser, 'student');
    });

    test('fromJson debe manejar how_did_you_know_us nulo', () {
      // Arrange
      final json = {
        'name': 'Pedro',
        'email': 'pedro@example.com',
      };

      // Act
      final register = RegisterModel.fromJson(json);

      // Assert
      expect(register.howDidYouKnowUs, isNull);
    });

    test('fromWizard debe mapear todos los campos del wizard', () {
      // Arrange
      final department = Item(name: 'Cundinamarca', codeDep: '25');
      final city = Item(name: 'Bogotá', codeDep: '25');
      final wizardData = RegisterWizardData(
        name: 'Ana',
        birthday: DateTime(2000, 5, 9),
        department: department,
        city: city,
        referralOptions: const ['Instagram', 'TikTok'],
        referralOther: 'Radio',
        examGoal: 'saber_pro',
        email: 'ana@example.com',
        password: '123456',
      );

      // Act
      final register = RegisterModel.fromWizard(wizardData);

      // Assert
      expect(register.name, 'Ana');
      expect(register.birthday, '2000-05-09');
      expect(register.department, 'Cundinamarca');
      expect(register.localDistrict, 'Bogotá');
      expect(register.howDidYouKnowUs, ['Instagram', 'TikTok']);
      expect(register.howDidYouKnowUsOther, 'Radio');
      expect(register.examGoal, 'saber_pro');
      expect(register.email, 'ana@example.com');
      expect(register.password, '123456');
      expect(register.typeUser, 'student');
    });

    test('fromWizard debe manejar campos opcionales vacíos', () {
      const wizardData = RegisterWizardData(
        name: 'Ana',
        email: 'ana@example.com',
        password: '123456',
      );

      // Act
      final register = RegisterModel.fromWizard(wizardData);

      // Assert
      expect(register.birthday, '');
      expect(register.department, '');
      expect(register.localDistrict, '');
      expect(register.typeUser, 'student');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final register = RegisterModel(
        name: 'Ana',
        birthday: '1999-03-20',
        department: 'Antioquia',
        localDistrict: 'Medellín',
        howDidYouKnowUs: const ['Google'],
        howDidYouKnowUsOther: '',
        examGoal: 'saber_tyt',
        email: 'ana@example.com',
        password: 'secreta123',
        typeUser: 'student',
      );

      // Act
      final json = register.toJson();

      // Assert
      expect(json['name'], 'Ana');
      expect(json['birthday'], '1999-03-20');
      expect(json['department'], 'Antioquia');
      expect(json['localDistrict'], 'Medellín');
      expect(json['howDidYouKnowUs'], ['Google']);
      expect(json['howDidYouKnowUsOther'], '');
      expect(json['examGoal'], 'saber_tyt');
      expect(json['email'], 'ana@example.com');
      expect(json['password'], 'secreta123');
      expect(json['typeUser'], 'student');
    });

    test('toJson -> fromJson debe hacer round-trip sin perder datos', () {
      // Arrange
      final original = RegisterModel(
        name: 'Luis',
        birthday: '1995-07-15',
        department: 'Valle',
        localDistrict: 'Cali',
        howDidYouKnowUs: const ['Facebook', 'Colegio'],
        howDidYouKnowUsOther: 'Feria universitaria',
        examGoal: 'saber11',
        email: 'luis@example.com',
        password: 'abcdef',
        typeUser: 'student',
      );

      // Act
      final roundTripped = RegisterModel.fromJson(original.toJson());

      // Assert
      expect(roundTripped.name, original.name);
      expect(roundTripped.birthday, original.birthday);
      expect(roundTripped.department, original.department);
      expect(roundTripped.localDistrict, original.localDistrict);
      expect(roundTripped.howDidYouKnowUs, original.howDidYouKnowUs);
      expect(roundTripped.howDidYouKnowUsOther, original.howDidYouKnowUsOther);
      expect(roundTripped.examGoal, original.examGoal);
      expect(roundTripped.email, original.email);
      expect(roundTripped.password, original.password);
      expect(roundTripped.typeUser, original.typeUser);
    });
  });
}