import 'dart:convert';

import 'package:lexxi/domain/auth/exeptions/user_exception.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';
import 'package:lexxi/infrastructure/auth/data_sources/local_data_source/localstorage_shared.dart';
import 'package:lexxi/infrastructure/auth/data_sources/remote_data_source.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRepository)
class UserImplement implements LoginRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalstorageShared _localstorageShared;

  UserImplement(this._remoteDataSource, this._localstorageShared);

  @override
  Future<User?> auth(LoginModel login) async {
    try {
      final userData = await _remoteDataSource.login(login.toJson());
      if (userData == null) return null;
      /* 
      gabrieldelarosagaray@gmail.com
      1102835545
      */
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
      await _localstorageShared.addToSharedPref(
          key: 'user', value: json.encode(userData));

      final user = User.fromJson(userData);

      return user;
    } catch (e) {
      throw UserException(e.toString());
    }
  }

  @override
  Future<User?> getUserLocal() async {
    try {
      final userData = json
          .decode(await _localstorageShared.readFromSharedPref('user', String));

      return User.fromJson(userData);
    } catch (e) {
      throw UserException(e.toString());
    }
  }

  @override
  Future<User?> getInfoUser(User user) async {
    try {
      final userData = await _remoteDataSource.getInfouUer(user);
      if (userData == null) return null;

      final u = User.fromJson(userData);
      if (u.active != 1) {
        throw UserException("Esta cuenta no esta activada ");
      }
      if (u.grado!.isEmpty) {
        // throw UserException("No te han asignado grado ");
      }
      await _localstorageShared.addToSharedPref(
          key: 'user', value: json.encode(userData));

      return u;
    } catch (e) {
      _localstorageShared.deleteFromSharedPref('user');
      throw UserException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _localstorageShared.deleteFromSharedPref('user');
  }

  @override
  Future<bool> changePassword(String password, String newPassword) async {
    final userData = json
        .decode(await _localstorageShared.readFromSharedPref('user', String));
          print(userData);

    final u = User.fromJson(userData);
    return _remoteDataSource.newPassword(password, newPassword, u.token!);
  }

  @override
  Future<void> registerUser(RegisterModel user) async {
    try {
      final responRegister = await _remoteDataSource.register(user.toJson());
      if (responRegister["error"] ?? false) {
        throw responRegister['message'];
      }

      return responRegister;
    } catch (e) {
      logger.e("$e");
      throw e.toString();
    }
  }
}
