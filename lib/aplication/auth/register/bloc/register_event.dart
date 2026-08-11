import 'package:equatable/equatable.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final RegisterModel data;

  const RegisterSubmitted(this.data);

  @override
  List<Object?> get props => [data];
}
