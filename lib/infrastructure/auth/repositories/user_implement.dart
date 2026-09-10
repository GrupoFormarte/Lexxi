import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/core/exceptions/user_exception.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';
import 'package:lexxi/infrastructure/auth/data_sources/local_data_source/localstorage_shared.dart';
import 'package:lexxi/infrastructure/auth/data_sources/remote_data_source.dart';
import 'package:lexxi/utils/loogers_custom.dart';

@LazySingleton(as: LoginRepository)
class UserImplement implements LoginRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalstorageShared _localstorageShared;

  UserImplement(
    this._remoteDataSource,
    this._localstorageShared,
  );

  @override
  Future<User?> auth(LoginModel login) async {
    try {
      final userData = await _remoteDataSource.login(login.toJson());

      return await _processLoginResponse(userData);
    } on NormalLoginFailedException catch (e) {
      logger.w('Login normal falló (${e.message}), probando SAF...');

      try {
        final safUserData = await _remoteDataSource.loginSaf(
          login.toSafJson(),
        );

        return await _processLoginResponse(safUserData);
      } catch (safError) {
        logger.e('Fallback SAF también falló: $safError');
        throw UserException(e.message);
      }
    } catch (e, stackTrace) {
      logger.e('Error en UserImplement auth: $e\n$stackTrace');

      throw UserException(e.toString());
    }
  }

  @override
  Future<User?> authSaf(LoginModel login) async {
    try {
      logger.d('Iniciando login SAF');

      final userData = await _remoteDataSource.loginSaf(
        login.toSafJson(),
      );

      return await _processLoginResponse(userData);
    } catch (e, stackTrace) {
      logger.e('Error en UserImplement authSaf: $e\n$stackTrace');

      if (e is UserException) rethrow;
      throw UserException(e.toString());
    }
  }


  Future<User?> _processLoginResponse(
    Map<String, dynamic>? userData,
  ) async {
    if (userData == null) {
      return null;
    }

    await _localstorageShared.addToSharedPref(
      key: 'user',
      value: json.encode(userData),
    );

    final user = User.fromJson(userData);

    logger.d(
      'Usuario autenticado: ${user.email} (token: ${user.token != null})',
    );

    return user;
  }


  @override
  Future<User?> getUserLocal() async {
    try {
      final data = await _localstorageShared.readFromSharedPref(
        'user',
        String,
      );

      if (data == null) {
        logger.d('No hay usuario local guardado');
        return null;
      }

      final userData = json.decode(data);

      final user = User.fromJson(userData);

      logger.d('Usuario local encontrado (id: ${user.id})');

      return user;
    } catch (e, stackTrace) {
      logger.e('Error en UserImplement getUserLocal: $e\n$stackTrace');

      throw UserException(
        e.toString(),
      );
    }
  }

  @override
  Future<User?> getInfoUser(User user) async {
    try {
      final userData = await _remoteDataSource.getInfouUer(
        user,
      );

      if (userData == null) {
        return null;
      }

      final u = User.fromJson(userData);

      if (u.active != 1) {
        throw UserException(
          'Esta cuenta no está activada',
        );
      }

      if (u.grado!.isEmpty) {
        // throw UserException("No te han asignado grado");
      }

      await _localstorageShared.addToSharedPref(
        key: 'user',
        value: json.encode(userData),
      );

      logger.d('Perfil actualizado (id: ${u.id}, grados: ${u.grado?.length})');

      return u;
    } catch (e, stackTrace) {
      logger.e('Error en UserImplement getInfoUser: $e\n$stackTrace');

      await _localstorageShared.deleteFromSharedPref(
        'user',
      );

      if (e is UserException) rethrow;
      throw UserException(
        e.toString(),
      );
    }
  }

  @override
  Future<void> logout() async {
    await _localstorageShared.deleteFromSharedPref(
      'user',
    );

    logger.d('Sesión cerrada');
  }

  @override
  Future<bool> changePassword(
    String password,
    String newPassword,
  ) async {
    final data = await _localstorageShared.readFromSharedPref(
      'user',
      String,
    );

    final userData = json.decode(data);

    final user = User.fromJson(userData);

    return _remoteDataSource.newPassword(
      password,
      newPassword,
      user.token!,
    );
  }


  @override
  Future<void> registerUser(
    RegisterModel user,
  ) async {
    try {
      final responRegister = await _remoteDataSource.register(
        user.toJson(),
      );

      if (responRegister["error"] ?? false) {
        throw UserException(
          responRegister['message']?.toString() ?? 'Error al registrar usuario',
        );
      }
    } on UserException catch (e) {
      logger.e('Error en UserImplement registerUser: ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error en UserImplement registerUser: $e');
      throw UserException(e.toString());
    }
  }
}