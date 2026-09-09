import 'package:equatable/equatable.dart';
import 'package:lexxi/domain/auth/model/login_type.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final LoginType type;

  const LoginSubmitted({
    required this.email,
    required this.password,
    this.type = LoginType.normal,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        type,
      ];
}

class LoginReset extends LoginEvent {
  const LoginReset();
}