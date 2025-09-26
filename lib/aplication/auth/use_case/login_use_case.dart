import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';


@injectable
class LoginUseCase {
  final LoginRepository _loginRepository;

  LoginUseCase(this._loginRepository);

  Future<User?> execute(LoginModel login) async {
    try {
      return await _loginRepository.auth(login);
    } catch (e) {
      print('Error de autenticación: $e');

      return null;
    }
  }
}
