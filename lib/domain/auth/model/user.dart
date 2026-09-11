// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:lexxi/domain/auth/model/login_type.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  dynamic id;
  String? name;
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
  LoginType? loginType;

  User({
    this.id,
    this.name,
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
    this.loginType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      print('[User.fromJson] Iniciando parseo de usuario');
      print('[User.fromJson] JSON recibido: $json');

      // Parsear grado con manejo de errores
      List<Grado>? gradoList;
      try {
        if (json["grado"] != null) {
          print('[User.fromJson] Parseando grados: ${json["grado"]}');
          gradoList = List<Grado>.from(json["grado"]!.map((x) {
            print('[User.fromJson] Parseando grado individual: $x');
            return Grado.fromJson(x);
          }));
        } else {
          gradoList = [];
        }
      } catch (e, stackTrace) {
        print('[User.fromJson] ERROR al parsear grados: $e');
        print('[User.fromJson] StackTrace: $stackTrace');
        gradoList = [];
      }

      print('[User.fromJson] Creando objeto User');
      return User(
        id: json["id"] ?? json["_id"],
        name: json["name"],
        institute: json["institute"],
        typeUser: json["type_user"],
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
        grado: gradoList,
        loginType: json["_login_type"] == "saf"
          ? LoginType.saf
          : json["_login_type"] == "normal"
            ? LoginType.normal
            : null,
      );
    } catch (e, stackTrace) {
      print('[User.fromJson] ERROR CRÍTICO: $e');
      print('[User.fromJson] StackTrace: $stackTrace');
      print('[User.fromJson] JSON que causó el error: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type_user": typeUser,
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
        "_login_type": loginType?.name,
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

  factory Grado.fromJson(Map<String, dynamic> json) {
    try {
      print('[Grado.fromJson] Parseando grado con datos: $json');

      final grado = Grado(
        id: json["id"]?.toString(),
        studentId: json["studentId"],
        programCode: json["programCode"]?.toString(),
        programName: json["programName"]?.toString(),
        shortName: json["shortName"]?.toString(),
        status: json["status"],
      );

      print('[Grado.fromJson] Grado parseado exitosamente: id=${grado.id}, programCode=${grado.programCode}');
      return grado;
    } catch (e, stackTrace) {
      print('[Grado.fromJson] ERROR al parsear grado: $e');
      print('[Grado.fromJson] StackTrace: $stackTrace');
      print('[Grado.fromJson] JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentId": studentId,
        "programCode": programCode,
        "programName": programName,
        "shortName": shortName,
        "status": status,
      };
}
