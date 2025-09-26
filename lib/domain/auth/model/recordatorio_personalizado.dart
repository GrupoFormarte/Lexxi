// To parse this JSON data, do
//
//     final config = configFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Config configFromJson(String str) => Config.fromJson(json.decode(str));

String configToJson(Config data) => json.encode(data.toJson());

class Config {
  String idStudent;
  NotificationConfig? notification;

  Config({
    required this.idStudent,
    this.notification,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        idStudent: json['idStudent'] ?? '',
        notification: json["notification"] == null
            ? null
            : NotificationConfig.fromJson(json["notification"]),
      );

  Map<String, dynamic> toJson() => {
        "notification": notification?.toJson(),
      };
}

class NotificationConfig {
  bool sonido;
  bool recordatorio;
  RecordatorioPersonalizado? recordatorioPersonalizado;

  NotificationConfig({
    this.sonido=true,
    this.recordatorio=true,
    this.recordatorioPersonalizado,
  });

  factory NotificationConfig.fromJson(Map<String, dynamic> json) => NotificationConfig(
        sonido: json["sonido"],
        recordatorio: json["recordatorio"],
        recordatorioPersonalizado: json["recordatorio_personalizado"] == null
            ? null
            : RecordatorioPersonalizado.fromJson(
                json["recordatorio_personalizado"]),
      );

  Map<String, dynamic> toJson() => {
        "sonido": sonido,
        "recordatorio": recordatorio,
        "recordatorio_personalizado": recordatorioPersonalizado?.toJson(),
      };
}

class RecordatorioPersonalizado {
  bool status;
  String time;

  RecordatorioPersonalizado({
    this.status=false,
    this.time="10:00 PM",
  });

  factory RecordatorioPersonalizado.fromJson(Map<String, dynamic> json) =>
      RecordatorioPersonalizado(
        status: json["status"],
        time: json["time"],
      );
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm(); // Formato de 12 horas con AM/PM
    return format.format(dt);
  }

  TimeOfDay parseTimeOfDay() {
    final format = DateFormat.jm(); // Formato de 12 horas con AM/PM
    final dt = format.parseLoose(time); // Usa parseLoose para una coincidencia más flexible
    return TimeOfDay.fromDateTime(dt);
  }
  Map<String, dynamic> toJson() => {
        "status": status,
        "time": time,
      };
}
