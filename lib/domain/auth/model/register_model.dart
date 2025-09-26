// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  int? typeId;
  String? numberId;
  String? name;
  String? secondName;
  String? lastName;
  String? secondLast;
  String? email;
  String? cellpone;
  String? localDistrict;
  String? gender;
  String? birthday;
  String? programa;
  String? typeUser;
  Enroll? enroll;

  RegisterModel(
      {this.typeId,
      this.numberId,
      this.name,
      this.secondName,
      this.lastName,
      this.secondLast,
      this.email,
      this.cellpone,
      this.localDistrict,
      this.gender,
      this.birthday,
      this.typeUser,
      this.enroll,
      this.programa});

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        typeId: json["type_id"],
        numberId: json["number_id"],
        name: json["name"],
        secondName: json["second_name"],
        lastName: json["last_name"],
        secondLast: json["second_last"],
        email: json["email"],
        cellpone: json["cellpone"],
        localDistrict: json["local_district"],
        gender: json["gender"],
        birthday: json["birthday"],
        programa: json["programa"],
        typeUser: json["type_user"],
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
        "cellphone": cellpone,
        "locate_district": localDistrict,
        "gender": gender,
        "birthday": birthday,
        "programa": programa,
        "type_user": typeUser,
        "enroll": enroll?.toJson(),
      };
}

class Enroll {
  int? programId;

  Enroll({
    this.programId,
  });

  factory Enroll.fromJson(Map<String, dynamic> json) => Enroll(
        programId: json["program_id"],
      );

  Map<String, dynamic> toJson() => {
        "program_id": programId,
      };
}
