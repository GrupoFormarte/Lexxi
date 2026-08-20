import 'package:lexxi/domain/item_dynamic/model/item.dart';

class RegisterWizardData {
  final String name;
  final DateTime? birthday;
  final Item? department;
  final Item? city;
  final List<String> referralOptions;
  final String referralOther;
  final String? examGoal;

  final String email;
  final String password;

  const RegisterWizardData({
    this.name = '',
    this.birthday,
    this.department,
    this.city,
    this.referralOptions = const [],
    this.referralOther = '',
    this.examGoal,
    this.email = '',
    this.password = '',
  });

  RegisterWizardData copyWith({
    String? name,
    DateTime? birthday,
    Item? department,
    Item? city,
    List<String>? referralOptions,
    String? referralOther,
    String? examGoal,
    String? email,
    String? password,
  }) {
    return RegisterWizardData(
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      department: department ?? this.department,
      city: city ?? this.city,
      referralOptions: referralOptions ?? this.referralOptions,
      referralOther: referralOther ?? this.referralOther,
      examGoal: examGoal ?? this.examGoal,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}