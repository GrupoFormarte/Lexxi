// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  dynamic id;
  String? name;
  String? secondName;
  String? lastName;
  String? secondLast;
  int? typeId;
  String? numberId;
  String? email;
  String? gender;
  int? active;
  String? phone;
  String? cellphone;
  String? address;
  String? neighborhood;
  String? birthday;
  String? company;
  String? companyPhone;
  String? profile;
  String? token;
  String? typeUser;
  int? institute;
  List<Grado>? grado;

  User({
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
    this.neighborhood,
    this.birthday,
    this.company,
    this.companyPhone,
    this.profile,
    this.token,
    this.typeUser,
    this.active,
    this.grado,
    this.institute,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? json["_id"],
        name: json["name"],
        institute: json["institute"],
        secondName: json["second_name"],
        lastName: json["last_name"],
        secondLast: json["second_last"],
        typeId: json["type_id"],
        typeUser: json["type_user"],
        numberId: json["identification_number"],
        email: json["email"],
        gender: json["gender"],
        phone: json["phone"],
        cellphone: json["cellphone"],
        address: json["address"],
        neighborhood: json["neighborhood"],
        birthday: json["birthday"],
        company: json["company"],
        companyPhone: json["company_phone"],
        profile: json["profile"],
        token: json["token"],
        active: json["active"],
        grado: json["grado"] == null
            ? []
            : List<Grado>.from(json["grado"]!.map((x) => Grado.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "second_name": secondName,
        "last_name": lastName,
        "second_last": secondLast,
        "type_id": typeId,
        "type_user": typeUser,
        "number_id": numberId,
        "email": email,
        "gender": gender,
        "phone": phone,
        "cellphone": cellphone,
        "address": address,
        "neighborhood": neighborhood,
        "birthday": birthday,
        "company": company,
        "company_phone": companyPhone,
        "profile": profile,
        "token": token,
        "active": active,
        "institute": institute,
        "grado": grado == null
            ? []
            : List<dynamic>.from(grado!.map((x) => x.toJson())),
      };
}

class Grado {
  String? id;
  int? studentId;
  String? programCode;
  String? programName;
  String? shortName;
  int? status;

  Grado({
    this.id,
    this.studentId,
    this.programCode,
    this.programName,
    this.shortName,
    this.status,
  });

  factory Grado.fromJson(Map<String, dynamic> json) => Grado(
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
