import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/aplication/auth/auth_error_message_mapper.dart';

void main() {
  group('AuthErrorMessageMapper', () {
    test('mapea errores de correo duplicado', () {
      expect(
        AuthErrorMessageMapper.map(Exception('Email already registered')),
        'El correo ya está registrado',
      );
    });

    test('mapea credenciales inválidas', () {
      expect(
        AuthErrorMessageMapper.map(Exception('Invalid credentials')),
        'El correo o la contraseña son incorrectos',
      );
    });

    test('oculta mensajes técnicos desconocidos', () {
      expect(
        AuthErrorMessageMapper.map(
          Exception('SQL connection details and internal stack trace'),
        ),
        'No pudimos completar la solicitud. Inténtalo de nuevo',
      );
    });
  });
}