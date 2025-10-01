import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/auth/use_case/login_use_case.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([LoginRepository])
void main() {
  late LoginUseCase loginUseCase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    loginUseCase = LoginUseCase(mockLoginRepository);
  });

  group('LoginUseCase Tests', () {
    test('execute debe retornar User cuando la autenticación es exitosa', () async {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'password123');
      final expectedUser = User(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        token: 'test_token',
      );

      when(mockLoginRepository.auth(loginModel))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await loginUseCase.execute(loginModel);

      // Assert
      expect(result, isNotNull);
      expect(result?.email, equals('test@example.com'));
      expect(result?.token, equals('test_token'));
      verify(mockLoginRepository.auth(loginModel)).called(1);
    });

    test('execute debe retornar null cuando la autenticación falla', () async {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'wrong_password');

      when(mockLoginRepository.auth(loginModel))
          .thenThrow(Exception('Authentication failed'));

      // Act
      final result = await loginUseCase.execute(loginModel);

      // Assert
      expect(result, isNull);
      verify(mockLoginRepository.auth(loginModel)).called(1);
    });

    test('execute debe manejar excepciones del repositorio', () async {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'password123');

      when(mockLoginRepository.auth(loginModel))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await loginUseCase.execute(loginModel);

      // Assert
      expect(result, isNull);
      verify(mockLoginRepository.auth(loginModel)).called(1);
    });

    test('execute debe llamar al repositorio con los datos correctos', () async {
      // Arrange
      final loginModel = LoginModel('user@test.com', 'secure123');
      final expectedUser = User(id: 2, email: 'user@test.com');

      when(mockLoginRepository.auth(loginModel))
          .thenAnswer((_) async => expectedUser);

      // Act
      await loginUseCase.execute(loginModel);

      // Assert
      verify(mockLoginRepository.auth(argThat(
        predicate<LoginModel>((model) =>
            model.email == 'user@test.com' && model.password == 'secure123'),
      ))).called(1);
    });
  });
}
