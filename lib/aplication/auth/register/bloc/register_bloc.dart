import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lexxi/aplication/auth/auth_error_message_mapper.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_state.dart';
import 'package:lexxi/aplication/auth/use_case/register_use_case.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/model/register_wizard_data.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterState()) {
    on<RegisterNameSubmitted>((event, emit) {
      emit(
        state.copyWith(
          data: state.data.copyWith(name: event.name),
          step: state.step + 1,
          status: RegisterStatus.idle,
          errorMessage: null,
        ),
      );
    });

    on<RegisterBirthdaySubmitted>((event, emit) {
      emit(
        state.copyWith(
          data: state.data.copyWith(birthday: event.birthday),
          step: state.step + 1,
          errorMessage: null,
        ),
      );
    });

    on<RegisterLocationSubmitted>((event, emit) {
      emit(
        state.copyWith(
          data: state.data.copyWith(
            department: event.department,
            city: event.city,
          ),
          step: state.step + 1,
          errorMessage: null,
        ),
      );
    });

    on<RegisterReferralSubmitted>((event, emit) {
      emit(
        state.copyWith(
          data: state.data.copyWith(
            referralOptions: event.options,
            referralOther: event.otherText,
          ),
          step: state.step + 1,
          errorMessage: null,
        ),
      );
    });

    on<RegisterExamGoalSubmitted>((event, emit) {
      emit(
        state.copyWith(
          data: state.data.copyWith(examGoal: event.examGoal),
          step: state.step + 1,
          errorMessage: null,
        ),
      );
    });

    on<RegisterCredentialsSubmitted>(_onCredentialsSubmitted);

    on<RegisterStepBack>((event, emit) {
      if (state.isFirstStep) return;
      emit(
        state.copyWith(
          step: state.step - 1,
          status: RegisterStatus.idle,
          errorMessage: null,
        ),
      );
    });
  }

  Future<void> _onCredentialsSubmitted(
    RegisterCredentialsSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final data = state.data.copyWith(
      email: event.email,
      password: event.password,
    );

    emit(
      state.copyWith(
        data: data,
        status: RegisterStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final model = _buildRegisterModel(data);
      await _registerUseCase(model);
      emit(state.copyWith(data: data, status: RegisterStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: _mapError(e),
        ),
      );
    }
  }

  RegisterModel _buildRegisterModel(RegisterWizardData data) {
    return RegisterModel.fromWizard(data);
  }

  String _mapError(Object e) {
    return AuthErrorMessageMapper.map(e);
  }
}
