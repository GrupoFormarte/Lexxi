import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/login_type.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';

@injectable
class LoginUseCase {
  final LoginRepository _repository;

  LoginUseCase(this._repository);

  Future<User?> call(
    LoginModel model, {
    LoginType type = LoginType.normal,
  }) async {
    switch (type) {
      case LoginType.normal:
        return await _repository.auth(model);

      case LoginType.saf:
        return await _repository.authSaf(model);
    }
  }
}