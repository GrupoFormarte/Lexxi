import 'package:equatable/equatable.dart';
import 'package:lexxi/domain/auth/model/register_wizard_data.dart';

enum RegisterStatus { idle, loading, success, failure }

class RegisterState extends Equatable {
  final int step;
  final RegisterWizardData data;
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({
    this.step = 0,
    this.data = const RegisterWizardData(),
    this.status = RegisterStatus.idle,
    this.errorMessage,
  });

  static const int totalSteps = 6;

  bool get isFirstStep => step == 0;
  bool get isLastStep => step == totalSteps - 1;

  RegisterState copyWith({
    int? step,
    RegisterWizardData? data,
    RegisterStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      step: step ?? this.step,
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [step, data, status, errorMessage];
}