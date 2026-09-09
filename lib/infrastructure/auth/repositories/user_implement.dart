import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/auth/exeptions/user_exception.dart';
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
      print('[UserImplement.auth] Iniciando login normal');

      final userData = await _remoteDataSource.login(
        login.toJson(),
      );

      return await _processLoginResponse(userData);
    } catch (e, stackTrace) {
      print('[UserImplement.auth] ERROR: $e');
      print('[UserImplement.auth] StackTrace: $stackTrace');

      logger.e(
        'Error en UserImplement auth: $e',
      );

      throw UserException(
        e.toString(),
      );
    }
  }

  @override
  Future<User?> authSaf(LoginModel login) async {
    try {
      print('[UserImplement.authSaf] Iniciando login SAF');

      final userData = await _remoteDataSource.loginSaf(
        login.toSafJson(),
      );

      return await _processLoginResponse(userData);
    } catch (e, stackTrace) {
      print('[UserImplement.authSaf] ERROR: $e');
      print('[UserImplement.authSaf] StackTrace: $stackTrace');

      logger.e(
        'Error en UserImplement authSaf: $e',
      );

      throw UserException(
        e.toString(),
      );
    }
  }


  Future<User?> _processLoginResponse(
    Map<String, dynamic>? userData,
  ) async {
    if (userData == null) {
      print(
        '[UserImplement] userData es null',
      );

      return null;
    }

    print(
      '[UserImplement] userData recibido: $userData',
    );

    // ----------------------------------------------------------
    // GRADOS
    // ----------------------------------------------------------

    userData['grado'] = [
      {
        "programName": "Preuniversitario UdeA",
        "programCode": "PUA",
        "shortName": "Pre Udea",
        "colecction": null,
        "id": "668d39d63abc9ff60a7979d2"
      },
      {
        "programName": "Preuniversitario Unal",
        "programCode": "PUN",
        "shortName": "Pre Unal",
        "colecction": null,
        "id": "668d39d63abc9ff60a7979d4"
      },
      {
        "programName": "Pre Saber",
        "programCode": "PSB",
        "shortName": "Pre Saber",
        "colecction": null,
        "id": "668d39d63abc9ff60a7979d6"
      }
    ];

    print(
      '[UserImplement] userData después de agregar grados: $userData',
    );


    await _localstorageShared.addToSharedPref(
      key: 'user',
      value: json.encode(userData),
    );


    print(
      '[UserImplement] Llamando a User.fromJson',
    );

    final user = User.fromJson(userData);

    print(
      '[UserImplement] Usuario creado exitosamente: ${user.email}',
    );

    print(
      '[UserImplement] Token: ${user.token != null ? 'EXISTE' : 'NO EXISTE'}',
    );

    return user;
  }


  @override
  Future<User?> getUserLocal() async {
    try {
      print(
        '[UserImplement.getUserLocal] Buscando usuario local',
      );

      final data = await _localstorageShared.readFromSharedPref(
        'user',
        String,
      );

      if (data == null) {
        print(
          '[UserImplement.getUserLocal] No existe usuario local',
        );

        return null;
      }

      final userData = json.decode(data);

      final user = User.fromJson(userData);

      print(
        '[UserImplement.getUserLocal] Usuario encontrado: ${user.email}',
      );

      return user;
    } catch (e, stackTrace) {
      print(
        '[UserImplement.getUserLocal] ERROR: $e',
      );

      print(stackTrace);

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

      return u;
    } catch (e) {
      await _localstorageShared.deleteFromSharedPref(
        'user',
      );

      throw UserException(
        e.toString(),
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  @override
  Future<void> logout() async {
    print(
      '[UserImplement.logout] Cerrando sesión',
    );

    await _localstorageShared.deleteFromSharedPref(
      'user',
    );

    print(
      '[UserImplement.logout] Usuario local eliminado',
    );
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

    print(userData);

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
        throw responRegister['message'];
      }

      return responRegister;
    } catch (e) {
      logger.e('$e');

      throw e.toString();
    }
  }
}