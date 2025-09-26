// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserViewModel userFromJson(String str) =>
    UserViewModel.fromJson(json.decode(str));

String userToJson(UserViewModel data) => json.encode(data.toJson());

class UserViewModel {
  dynamic id;
  String? name;
  String? secondName;
  String? lastName;
  String? secondLast;
  int? typeId;
  String? numberId;
  String? email;
  String? gender;
  String? phone;
  String? cellphone;
  String? address;
  dynamic locateDistrict;
  String? neighborhood;
  String? birthday;
  String? company;
  String? companyPhone;
  String? profile;
  String? token;
  List<Grado2>? grado;

  UserViewModel({
    this.id,
    this.name,
    this.secondName,
    this.lastName,
    this.secondLast,
    this.typeId,
    this.numberId,
    this.email,
    this.gender,
    this.phone,
    this.cellphone,
    this.address,
    this.locateDistrict,
    this.neighborhood,
    this.birthday,
    this.company,
    this.companyPhone,
    this.profile,
    this.token,
    this.grado,
  });

  factory UserViewModel.fromJson(Map<String, dynamic> json) => UserViewModel(
        id: json["id"],
        name: json["name"],
        secondName: json["second_name"],
        lastName: json["last_name"],
        secondLast: json["second_last"],
        typeId: json["type_id"],
        numberId: json["number_id"],
        email: json["email"],
        gender: json["gender"],
        phone: json["phone"],
        cellphone: json["cellphone"],
        address: json["address"],
        locateDistrict: json["locate_district"],
        neighborhood: json["neighborhood"],
        birthday: json["birthday"],
        company: json["company"],
        companyPhone: json["company_phone"],
        profile: json["photo"],
        token: json["token"],
        grado: json["grado"] == null
            ? []
            : List<Grado2>.from(json["grado"]!.map((x) => Grado2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "second_name": secondName,
        "last_name": lastName,
        "second_last": secondLast,
        "type_id": typeId,
        "number_id": numberId,
        "email": email,
        "gender": gender,
        "phone": phone,
        "cellphone": cellphone,
        "address": address,
        "locate_district": locateDistrict,
        "neighborhood": neighborhood,
        "birthday": birthday,
        "company": company,
        "company_phone": companyPhone,
        "profile": profile,
        "token": token,
        "grado": grado == null
            ? []
            : List<dynamic>.from(grado!.map((x) => x.toJson())),
      };
  List<Grado2> getActiveGrados() {
    return grado?.where((g) => g.status == 1).toList() ?? [];
  }
}

class Grado2 {
  String? id;
  int? studentId;
  String? programCode;
  String? programName;
  String? shortName;
  int? status;

  Grado2({
    this.id,
    this.studentId,
    this.programCode,
    this.programName,
    this.shortName,
    this.status,
  });

  factory Grado2.fromJson(Map<String, dynamic> json) => Grado2(
        id: json["id"],
        studentId: json["studentId"],
        programCode: json["programCode"],
        programName: json["programName"],
        shortName: json["shortName"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentId": studentId,
        "programCode": programCode,
        "programName": programName,
        "shortName": shortName,
        "status": status,
      };
}
