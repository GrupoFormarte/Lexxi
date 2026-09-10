class UserException implements Exception {
  final String message;

  UserException(this.message);

  @override
  String toString() => message;
}

class NormalLoginFailedException extends UserException {
  NormalLoginFailedException(super.message);
}