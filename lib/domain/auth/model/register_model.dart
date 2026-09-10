import 'package:lexxi/domain/auth/model/register_wizard_data.dart';
class RegisterModel {
  static const int defaultTypeId = 4;
  String? name;
  String? email;
  String? password;
  String? typeUser;
  String? birthday;
  String? department;
  String? localDistrict;
  List<String>? howDidYouKnowUs;
  String? howDidYouKnowUsOther;
  String? examGoal;

  RegisterModel({
    this.name,
    this.birthday,
    this.department,
    this.localDistrict,
    this.howDidYouKnowUs,
    this.howDidYouKnowUsOther,
    this.examGoal,
    this.email,
    this.password,
    this.typeUser,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    final referralOptions =
        json["howDidYouKnowUs"] ?? json["how_did_you_know_us"];

    return RegisterModel(
      name: json["name"]?.toString(),
      birthday: json["birthday"]?.toString(),
      department: json["department"]?.toString(),
      localDistrict: (json["localDistrict"] ?? json["local_district"])
          ?.toString(),
      howDidYouKnowUs: referralOptions is List
          ? referralOptions
                .where((value) => value != null)
                .map((value) => value.toString())
                .toList()
          : null,
      howDidYouKnowUsOther:
          (json["howDidYouKnowUsOther"] ?? json["how_did_you_know_us_other"])
              ?.toString(),
      examGoal: (json["examGoal"] ?? json["exam_goal"])?.toString(),
      email: json["email"]?.toString(),
      password: json["password"]?.toString(),
      typeUser: (json["typeUser"] ?? json["type_user"] ?? 'student').toString(),
    );
  }

  factory RegisterModel.fromWizard(RegisterWizardData data) {
    final birthday = data.birthday != null
        ? "${data.birthday!.year}-${data.birthday!.month.toString().padLeft(2, '0')}-${data.birthday!.day.toString().padLeft(2, '0')}"
        : '';

    return RegisterModel(
      name: data.name,
      birthday: birthday,
      department: data.department?.name ?? '',
      localDistrict: data.city?.name ?? '',
      howDidYouKnowUs: data.referralOptions,
      howDidYouKnowUsOther: data.referralOther,
      examGoal: data.examGoal,
      email: data.email,
      password: data.password,
      typeUser: 'Student',
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "birthday": birthday,
    "department": department,
    "localDistrict": localDistrict,
    "howDidYouKnowUs": howDidYouKnowUs,
    "howDidYouKnowUsOther": howDidYouKnowUsOther,
    "examGoal": examGoal,
    "email": email,
    "password": password,
    "typeUser": typeUser,
  };
}