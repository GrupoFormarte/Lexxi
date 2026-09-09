import 'package:equatable/equatable.dart';
import 'package:lexxi/domain/auth/model/login_type.dart';
import 'package:lexxi/domain/auth/model/user.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;
  final LoginType type;

  const LoginSuccess(
    this.user,
    this.type,
  );

  @override
  List<Object?> get props => [user, type];
}
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}