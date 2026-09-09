import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lexxi/aplication/auth/login/bloc/login_event.dart';
import 'package:lexxi/aplication/auth/login/bloc/login_state.dart';
import 'package:lexxi/aplication/auth/use_case/login_use_case.dart';
import 'package:lexxi/domain/auth/model/login_model.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);

    on<LoginReset>((event, emit) {
      emit(const LoginInitial());
    });
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final loginModel = LoginModel(event.email.trim(), event.password);

      if (!loginModel.isValid()) {
        emit(const LoginFailure('Correo o contraseña inválidos'));
        return;
      }

      print('================================');
      print('LOGIN');
      print('Tipo: ${event.type}');
      print('Email: ${event.email}');
      print('================================');

      final user = await _loginUseCase(loginModel, type: event.type);

      if (user == null) {
        emit(const LoginFailure('Correo o contraseña incorrectos'));
        return;
      }

      print('LOGIN EXITOSO');
      print('Usuario: ${user.email}');
      print('Tipo usuario: ${user.typeUser}');
      print('Tiene token: ${user.token != null}');

      emit(LoginSuccess(user, user.loginType ?? event.type));
    } catch (e, stackTrace) {
      print('ERROR LOGIN: $e');
      print(stackTrace);

      emit(LoginFailure(e.toString()));
    }
  }
}
