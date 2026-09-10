class LoginModel {
  final String email;
  final String password;
  
  LoginModel(
    this.email,
    this.password,
  );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  Map<String, dynamic> toSafJson() {
    return {
      'email': email,
      'password': password,
      'captcha': false,
    };
  }

  bool isValid() {
    return _isEmailValid(email) && password.isNotEmpty;
  }

  bool _isEmailValid(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    return emailRegExp.hasMatch(email);
  }
}