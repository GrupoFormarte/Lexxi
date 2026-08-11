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
    on<LoginReset>((event, emit) => emit(const LoginInitial()));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final loginModel = LoginModel(event.email, event.password);

      if (!loginModel.isValid()) {
        emit(const LoginFailure('Faltan campos por llenar'));
        return;
      }

      final user = await _loginUseCase(loginModel);

      if (user == null) {
        emit(const LoginFailure('Correo o contraseña incorrectos'));
        return;
      }

      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
