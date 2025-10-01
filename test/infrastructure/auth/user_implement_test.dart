import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/auth/repositories/user_implement.dart';
import 'package:lexxi/infrastructure/auth/data_sources/remote_data_source.dart';
import 'package:lexxi/infrastructure/auth/data_sources/local_data_source/localstorage_shared.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/exeptions/user_exception.dart';

import 'user_implement_test.mocks.dart';

@GenerateMocks([RemoteDataSource, LocalstorageShared])
void main() {
  late UserImplement userImplement;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalstorageShared mockLocalStorage;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalStorage = MockLocalstorageShared();
    userImplement = UserImplement(mockRemoteDataSource, mockLocalStorage);
  });

  group('UserImplement Tests', () {
    test('auth debe retornar User y guardar en localStorage cuando login es exitoso',
        () async {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'password123');
      final mockUserData = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'token': 'test_token',
        'active': 1,
      };

      when(mockRemoteDataSource.login(any))
          .thenAnswer((_) async => mockUserData);
      when(mockLocalStorage.addToSharedPref(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => true);

      // Act
      final result = await userImplement.auth(loginModel);

      // Assert
      expect(result, isNotNull);
      expect(result?.email, equals('test@example.com'));
      expect(result?.name, equals('Test User'));
      verify(mockRemoteDataSource.login(any)).called(1);
      verify(mockLocalStorage.addToSharedPref(
        key: 'user',
        value: anyNamed('value'),
      )).called(1);
    });

    test('auth debe retornar null cuando remoteDataSource retorna null',
        () async {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'wrong_password');

      when(mockRemoteDataSource.login(any)).thenAnswer((_) async => null);

      // Act
      final result = await userImplement.auth(loginModel);

      // Assert
      expect(result, isNull);
      verify(mockRemoteDataSource.login(any)).called(1);
      verifyNever(mockLocalStorage.addToSharedPref(
        key: anyNamed('key'),
        value: anyNamed('value'),
      ));
    });

    test('auth debe lanzar UserException cuando hay error en remote',
        () async {
      // Arrange
      final loginModel = LoginModel('test@example.com', 'password123');

      when(mockRemoteDataSource.login(any))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => userImplement.auth(loginModel),
        throwsA(isA<UserException>()),
      );
    });

    test('getUserLocal debe retornar User desde localStorage', () async {
      // Arrange
      final mockUserData = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
      };
      final userJson = jsonEncode(mockUserData);

      when(mockLocalStorage.readFromSharedPref('user', String))
          .thenAnswer((_) async => userJson);

      // Act
      final result = await userImplement.getUserLocal();

      // Assert
      expect(result, isNotNull);
      expect(result?.email, equals('test@example.com'));
      verify(mockLocalStorage.readFromSharedPref('user', String)).called(1);
    });

    test('getUserLocal debe lanzar UserException cuando no hay datos',
        () async {
      // Arrange
      when(mockLocalStorage.readFromSharedPref('user', String))
          .thenThrow(Exception('No data'));

      // Act & Assert
      expect(
        () => userImplement.getUserLocal(),
        throwsA(isA<UserException>()),
      );
    });

    test('logout debe eliminar datos del localStorage', () async {
      // Arrange
      when(mockLocalStorage.deleteFromSharedPref('user'))
          .thenAnswer((_) async => true);

      // Act
      await userImplement.logout();

      // Assert
      verify(mockLocalStorage.deleteFromSharedPref('user')).called(1);
    });

    test('getInfoUser debe lanzar excepción si el usuario no está activo',
        () async {
      // Arrange
      final user = User(id: 1, email: 'test@example.com', active: 0);
      final mockUserData = {
        'id': 1,
        'email': 'test@example.com',
        'active': 0,
        'grado': [],
      };

      when(mockRemoteDataSource.getInfouUer(any))
          .thenAnswer((_) async => mockUserData);
      when(mockLocalStorage.deleteFromSharedPref(any))
          .thenAnswer((_) async => null);

      // Act & Assert
      expect(
        () => userImplement.getInfoUser(user),
        throwsA(isA<UserException>()),
      );
    });

    test('getInfoUser debe retornar usuario y guardarlo cuando está activo',
        () async {
      // Arrange
      final user = User(id: 1, email: 'test@example.com');
      final mockUserData = {
        'id': 1,
        'email': 'test@example.com',
        'active': 1,
        'grado': [],
      };

      when(mockRemoteDataSource.getInfouUer(any))
          .thenAnswer((_) async => mockUserData);
      when(mockLocalStorage.addToSharedPref(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => true);

      // Act
      final result = await userImplement.getInfoUser(user);

      // Assert
      expect(result, isNotNull);
      expect(result?.active, equals(1));
      verify(mockRemoteDataSource.getInfouUer(any)).called(1);
      verify(mockLocalStorage.addToSharedPref(
        key: 'user',
        value: anyNamed('value'),
      )).called(1);
    });
  });
}
