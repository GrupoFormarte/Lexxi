import 'package:lexxi/domain/auth/exeptions/user_exception.dart';

class LoginModel {
  final String email;
  final String password;

  LoginModel(this.email, this.password){

      if (email.isEmpty || password.isEmpty) {
      throw UserException('El email y la contraseña no pueden estar vacíos');
    }
  }

  Map<String, dynamic> toJson() =>
      {"email": email, "password": password, "captcha": false};

  bool isValid() {
    return _isEmailValid(email) && password.isNotEmpty;
  }

  bool _isEmailValid(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }
}
