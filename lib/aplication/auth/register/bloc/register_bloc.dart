import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_state.dart';
import 'package:lexxi/aplication/auth/use_case/register_use_case.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    try {
      await _registerUseCase(event.data);
      emit(const RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(_mapError(e)));
    }
  }

  String _mapError(Object e) {
    final message = e.toString().trim();

    if (message.contains('ID number already registered')) {
      return 'El documento ya existe';
    }
    if (message.contains('Email already registered')) {
      return 'El correo ya existe';
    }
    return message;
  }
}
