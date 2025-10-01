import 'package:lexxi/domain/auth/exeptions/user_exception.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthService {
  final LoginRepository _loginRepository;

  AuthService(this._loginRepository);

  Future<User?> execute(LoginModel login) async {
    try {
      return await _loginRepository.auth(login);
    } catch (e) {
      // throw UserException(e);
    }
    return null;
  }

  Future<User?> getUserLocal() async {
    try {
      return await _loginRepository.getUserLocal();
    } catch (e) {
      throw UserException(e.toString());
    }
  }

  Future<User?> getInfoUser(User user) async {
    try {
      return await _loginRepository.getInfoUser(user);
    } catch (e) {
      throw UserException(e.toString());
    }
  }

  Future<bool> changePassword(String password, String newPassword) {
    return _loginRepository.changePassword(password, newPassword);
  }

  Future<void> register(RegisterModel data) async {
    return _loginRepository.registerUser(data);
  }

  Future<void> logout() async {
    await _loginRepository.logout();
  }
}
