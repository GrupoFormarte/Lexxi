import 'dart:async' as _i3;

import 'package:lexxi/domain/auth/model/login_model.dart' as _i5;
import 'package:lexxi/domain/auth/model/register_model.dart' as _i6;
import 'package:lexxi/domain/auth/model/user.dart' as _i4;
import 'package:lexxi/domain/auth/repositories/login_repository.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

class MockLoginRepository extends _i1.Mock implements _i2.LoginRepository {
  MockLoginRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.User?> auth(_i5.LoginModel? login) =>
      (super.noSuchMethod(
            Invocation.method(#auth, [login]),
            returnValue: _i3.Future<_i4.User?>.value(),
          )
          as _i3.Future<_i4.User?>);

  @override
  _i3.Future<_i4.User?> authSaf(_i5.LoginModel? login) =>
      (super.noSuchMethod(
            Invocation.method(#authSaf, [login]),
            returnValue: _i3.Future<_i4.User?>.value(),
          )
          as _i3.Future<_i4.User?>);

  @override
  _i3.Future<_i4.User?> getUserLocal() =>
      (super.noSuchMethod(
            Invocation.method(#getUserLocal, []),
            returnValue: _i3.Future<_i4.User?>.value(),
          )
          as _i3.Future<_i4.User?>);

  @override
  _i3.Future<_i4.User?> getInfoUser(_i4.User? user) =>
      (super.noSuchMethod(
            Invocation.method(#getInfoUser, [user]),
            returnValue: _i3.Future<_i4.User?>.value(),
          )
          as _i3.Future<_i4.User?>);

  @override
  _i3.Future<void> registerUser(_i6.RegisterModel? user) =>
      (super.noSuchMethod(
            Invocation.method(#registerUser, [user]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<bool> changePassword(String? password, String? newPassword) =>
      (super.noSuchMethod(
            Invocation.method(#changePassword, [password, newPassword]),
            returnValue: _i3.Future<bool>.value(false),
          )
          as _i3.Future<bool>);
}
