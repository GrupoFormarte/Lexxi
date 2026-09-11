import 'package:equatable/equatable.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}
class RegisterNameSubmitted extends RegisterEvent {
  final String name;
  const RegisterNameSubmitted(this.name);

  @override
  List<Object?> get props => [name];
}

class RegisterBirthdaySubmitted extends RegisterEvent {
  final DateTime birthday;
  const RegisterBirthdaySubmitted(this.birthday);

  @override
  List<Object?> get props => [birthday];
}

class RegisterLocationSubmitted extends RegisterEvent {
  final Item department;
  final Item city;
  const RegisterLocationSubmitted({
    required this.department,
    required this.city,
  });

  @override
  List<Object?> get props => [department, city];
}
class RegisterReferralSubmitted extends RegisterEvent {
  final List<String> options;
  final String otherText;
  const RegisterReferralSubmitted({
    required this.options,
    this.otherText = '',
  });

  @override
  List<Object?> get props => [options, otherText];
}

class RegisterExamGoalSubmitted extends RegisterEvent {
  final String examGoal;
  const RegisterExamGoalSubmitted(this.examGoal);

  @override
  List<Object?> get props => [examGoal];
}

class RegisterCredentialsSubmitted extends RegisterEvent {
  final String email;
  final String password;
  const RegisterCredentialsSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterStepBack extends RegisterEvent {
  const RegisterStepBack();
}