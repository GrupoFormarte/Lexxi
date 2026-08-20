import 'enroll.dart';

class RegisterModel {
  int? typeId;
  String? numberId;
  String? name;
  String? secondName;
  String? lastName;
  String? secondLast;
  String? email;
  String? password;
  String? cellpone;
  String? localDistrict;
  String? department;
  String? gender;
  String? birthday;
  String? programa;
  String? typeUser;
  List<String>? howDidYouKnowUs;
  String? howDidYouKnowUsOther;
  String? examGoal;
  Enroll? enroll;

  RegisterModel(
      {this.typeId,
      this.numberId,
      this.name,
      this.secondName,
      this.lastName,
      this.secondLast,
      this.email,
      this.password,
      this.cellpone,
      this.localDistrict,
      this.department,
      this.gender,
      this.birthday,
      this.typeUser,
      this.enroll,
      this.howDidYouKnowUs,
      this.howDidYouKnowUsOther,
      this.examGoal,
      this.programa});

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        typeId: json["type_id"],
        numberId: json["number_id"],
        name: json["name"],
        secondName: json["second_name"],
        lastName: json["last_name"],
        secondLast: json["second_last"],
        email: json["email"],
        password: json["password"],
        cellpone: json["cellpone"],
        localDistrict: json["local_district"],
        department: json["department"],
        gender: json["gender"],
        birthday: json["birthday"],
        programa: json["programa"],
        typeUser: json["type_user"],
        howDidYouKnowUs: json["how_did_you_know_us"] == null
            ? null
            : List<String>.from(json["how_did_you_know_us"]),
        howDidYouKnowUsOther: json["how_did_you_know_us_other"],
        examGoal: json["exam_goal"],
        enroll: json["enroll"] == null ? null : Enroll.fromJson(json["enroll"]),
      );

  Map<String, dynamic> toJson() => {
        "type_id": typeId,
        "number_id": numberId,
        "name": name,
        "second_name": secondName,
        "last_name": lastName,
        "second_last": secondLast,
        "email": email,
        "password": password,
        "cellpone": cellpone,
        "local_district": localDistrict,
        "department": department,
        "gender": gender,
        "birthday": birthday,
        "programa": programa,
        "type_user": typeUser,
        "how_did_you_know_us": howDidYouKnowUs,
        "how_did_you_know_us_other": howDidYouKnowUsOther,
        "exam_goal": examGoal,
        "enroll": enroll?.toJson(),
      };
}