import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/exeptions/user_exception.dart';

void main() {
  group('LoginModel Tests', () {
    test('LoginModel debe crear una instancia válida con email y password correctos', () {
      // Arrange & Act
      final loginModel = LoginModel('test@example.com', 'password123');

      // Assert
      expect(loginModel.email, equals('test@example.com'));
      expect(loginModel.password, equals('password123'));
    });

    test('LoginModel debe lanzar UserException si el email está vacío', () {
      // Act & Assert
      expect(
        () => LoginModel('', 'password123'),
        throwsA(isA<UserException>()),
      );
    });

    test('LoginModel debe lanzar UserException si el password está vacío', () {
      // Act & Assert
      expect(
        () => LoginModel('test@example.com', ''),
        throwsA(isA<UserException>()),
      );
    });

    test('LoginModel debe lanzar UserException si ambos están vacíos', () {
      // Act & Assert
      expect(
        () => LoginModel('', ''),
        throwsA(isA<UserException>()),
      );
    });

    test('toJson debe retornar un Map con la estructura correcta', () {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'password123');

      // Act
      final json = loginModel.toJson();

      // Assert
      expect(json['email'], equals('test@example.com'));
      expect(json['password'], equals('password123'));
      expect(json['captcha'], equals(false));
    });

    test('isValid debe retornar true con email y password válidos', () {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'password123');

      // Act
      final isValid = loginModel.isValid();

      // Assert
      expect(isValid, isTrue);
    });

    test('isValid debe retornar false con email inválido', () {
      // Arrange
      final loginModel = LoginModel('invalid-email', 'password123');

      // Act
      final isValid = loginModel.isValid();

      // Assert
      expect(isValid, isFalse);
    });

    test('isValid debe validar diferentes formatos de email válidos', () {
      // Arrange
      final validEmails = [
        'test@example.com',
        'user.name@example.com',
        'user+tag@example.co.uk',
        'test123@test.com',
      ];

      // Act & Assert
      for (final email in validEmails) {
        final loginModel = LoginModel(email, 'password123');
        expect(loginModel.isValid(), isTrue,
            reason: '$email should be valid');
      }
    });

    test('isValid debe rechazar formatos de email inválidos', () {
      // Arrange
      final invalidEmails = [
        'invalid-email',
        '@example.com',
        'user@',
        'user@.com',
        'user space@example.com',
      ];

      // Act & Assert
      for (final email in invalidEmails) {
        final loginModel = LoginModel(email, 'password123');
        expect(loginModel.isValid(), isFalse,
            reason: '$email should be invalid');
      }
    });
  });
}
