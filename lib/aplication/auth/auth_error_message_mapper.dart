class AuthErrorMessageMapper {
  const AuthErrorMessageMapper._();

  static String map(Object error) {
    final message = error.toString().trim();
    final normalized = message.toLowerCase();

    if (_containsAny(normalized, [
      'email already registered',
      'email already exists',
      'correo ya existe',
      'correo ya está registrado',
      'correo ya esta registrado',
    ])) {
      return 'El correo ya está registrado';
    }

    if (_containsAny(normalized, [
      'id number already registered',
      'id number already exists',
      'document already registered',
      'documento ya existe',
      'documento ya está registrado',
      'documento ya esta registrado',
    ])) {
      return 'El documento ya está registrado';
    }

    if (_containsAny(normalized, [
      'invalid credentials',
      'incorrect credentials',
      'invalid email or password',
      'invalid password',
      'credenciales inválidas',
      'credenciales invalidas',
      'correo o contraseña incorrectos',
    ])) {
      return 'El correo o la contraseña son incorrectos';
    }

    if (_containsAny(normalized, [
      'timeout',
      'network error',
      'socketexception',
      'failed host lookup',
      'connection refused',
    ])) {
      return 'No pudimos conectarnos. Revisa tu conexión e inténtalo de nuevo';
    }

    return 'No pudimos completar la solicitud. Inténtalo de nuevo';
  }

  static bool _containsAny(String message, List<String> values) {
    return values.any(message.contains);
  }
}
