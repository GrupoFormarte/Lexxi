import 'package:lexxi/domain/auth/model/login_model.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/model/user.dart';

abstract class LoginRepository {
  Future<User?> auth(LoginModel login);

  Future<User?> getUserLocal();
  Future<User?> getInfoUser(User user);

  Future<void> registerUser(RegisterModel user);

  Future<void>logout();
  Future<bool>changePassword(String password,String newPassword);
}
