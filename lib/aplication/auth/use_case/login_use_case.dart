import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';

@injectable
class LoginUseCase {
  final LoginRepository _repository;

  LoginUseCase(this._repository);

  Future<User?> call(LoginModel login) {
    return _repository.auth(login);
  }
}
