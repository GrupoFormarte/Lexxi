// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  String? idStudent;
  String? nombre;
  String? idInstituto;
  String? score;
  String? idMongo;
  String? photo;
  int? position;
  List<Grado>? grados;
  Config? config;

  // Nuevos campos
  String? name;
  String? secondName;
  String? lastName;
  String? secondLastName;
  int? documentTypeId;
  String? documentType;
  String? identificationNumber;
  String? email;
  String? cellphone;

  Student({
    this.idInstituto,
    this.nombre,
    this.idStudent,
    this.score,
    this.position,
    this.config,
    this.grados,
    this.idMongo,
    this.name,
    this.secondName,
    this.lastName,
    this.secondLastName,
    this.documentTypeId,
    this.documentType,
    this.identificationNumber,
    this.email,
    this.photo,
    this.cellphone,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        idStudent: json["id_student"],
        nombre: json["nombre"],
        idInstituto: json["idInstituto"],
        idMongo: json["_id"],
        score: json["score_total"],
        position: json["position"],
        config: json['config'] == null ? null : Config.fromJson(json['config']),
        grados: json["grados"] == null
            ? []
            : List<Grado>.from(json["grados"]!.map((x) => Grado.fromJson(x))),
        // Nuevos campos
        photo: json["photo"],
        name: json["name"],
        secondName: json["second_name"],
        lastName: json["last_name"],
        secondLastName: json["second_last_name"],
        documentTypeId: json["document_type_id"],
        documentType: json["document_type"],
        identificationNumber: json["identification_number"]?.toString(),
        email: json["email"],
        cellphone: json["cellphone"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id_student": idStudent,
        "score_total": score,
        "nombre": nombre,
        "photo":photo,
        "idInstituto": idInstituto,
        "position": position,
        "config": config?.toJson(),
        "grados": grados == null
            ? []
            : List<dynamic>.from(grados!.map((x) => x.toJson())),
        // Nuevos campos
        "name": name,
        "second_name": secondName,
        "last_name": lastName,
        "second_last_name": secondLastName,
        "document_type_id": documentTypeId,
        "document_type": documentType,
        "identification_number": identificationNumber,
        "email": email,
        "cellphone": cellphone,
      };

  Grado? getGrado(String? grado) {
    for (var i in grados ?? []) {
      if (i.grado == grado) {
        return i;
      }
    }
    return null;
  }

  // Método para obtener el nivel del grado y la asignatura por ID de asignatura
  String? getAsignaturaDetails(String asignaturaId, String gradoName) {
    String? level;
    for (Grado? grado in grados ?? []) {
      if (gradoName == grado!.grado) {
        for (Asignatura? asignatura in grado.asignaturas ?? []) {
          if (asignatura?.asignaturaId != null &&
              asignatura!.asignaturaId!.contains(asignaturaId)) {
            level = asignatura.level;
          }
        }
      }
    }
    return level;
  }

  String? getScoreAsiggnature(String asignaturaId, String gradoName) {
    String? score;

    print(['getScoreAsiggnature', asignaturaId, gradoName]);
    for (Grado? grado in grados ?? []) {
      if (gradoName == grado!.grado) {
        for (Asignatura? asignatura in grado.asignaturas ?? []) {
          if (asignatura?.asignaturaId != null &&
              asignatura!.asignaturaId!.contains(asignaturaId)) {
            score = asignatura.score.toString();
          }
        }
      }
    }
    return score;
  }

  Color? getCurrentColor(String asignaturaId, String gradoName,
      {bool currentColor = true}) {
    Color? color;
    String codeColor = "0xff8B0001";
    for (Grado? grado in grados ?? []) {
      if (gradoName == grado!.grado) {
        for (Asignatura? asignatura in grado.asignaturas ?? []) {
          if (asignatura?.asignaturaId == asignaturaId) {
            codeColor = asignatura!.currentColor == null
                ? codeColor
                : "0xff${asignatura.currentColor}";

            color = currentColor
                ? Color(int.parse(codeColor))
                : (asignatura.previewColor == null
                    ? null
                    : Color(int.parse(codeColor)));
          }
        }
      }
    }
    return color;
  }

  String getLevel(university, score) {
    if (university == 'Pre Udea') {
      if (score <= 33) {
        return 'nivel_0';
      } else if (score <= 66) {
        return 'nivel_1';
      } else {
        return 'nivel_3';
      }
    } else if (university == 'Pre Unal') {
      if (score <= 330) {
        return 'nivel_0';
      } else if (score <= 660) {
        return 'nivel_1';
      } else {
        return 'nivel_3';
      }
    } else if (university == 'Icfes') {
      if (score <= 165) {
        return 'nivel_0';
      } else if (score <= 330) {
        return 'nivel_1';
      } else {
        return 'nivel_3';
      }
    } else {
      return 'nivel_0';
    }
  }
}

class Grado {
  String? grado;
  String? idGrado;
  dynamic scoreSimulacro;
  List<HistoryTime> historyTime;
  List<Asignatura>? asignaturas;
  List<ProgressHistory> progressHistory;
  List<HistoryPosition> historyPosition;

  Grado(
      {this.grado,
      this.idGrado,
      this.scoreSimulacro = 0.0,
      this.asignaturas,
      this.historyPosition = const [],
      this.progressHistory = const [],
      this.historyTime = const []});

  Map<String, String> obtenerMejorYPeorTiempo() {
    if (historyTime.isEmpty) {
      return {"mejor": "00:00", "peor": "00:00"};
    }

    // Convierte un string de tiempo a total de segundos
    int convertirATotalSegundos(String time) {
      final partes = time.split(':').map(int.parse).toList();
      if (partes.length == 2) {
        return partes[0] * 60 + partes[1]; // mm:ss
      } else if (partes.length == 3) {
        return partes[0] * 3600 + partes[1] * 60 + partes[2]; // hh:mm:ss
      }
      return 0;
    }

    // Convierte total de segundos a formato mm:ss
    String formatearDesdeSegundos(int totalSegundos) {
      final minutos = totalSegundos ~/ 60;
      final segundos = totalSegundos % 60;
      return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
    }

    final tiemposEnSegundos =
        historyTime.map((h) => convertirATotalSegundos(h.time)).toList();

    final mejor = tiemposEnSegundos.reduce((a, b) => a < b ? a : b);
    final peor = tiemposEnSegundos.reduce((a, b) => a > b ? a : b);

    return {
      "mejor": formatearDesdeSegundos(mejor),
      "peor": formatearDesdeSegundos(peor),
    };
  }

  RankingResumen calcularRankingResumen({
    required int totalUsuarios,
  }) {
    print(['isEmpty', historyPosition.isEmpty]);

    if (historyPosition.isEmpty) {
      return RankingResumen(
        posicionActual: 0,
        totalUsuarios: totalUsuarios,
        cambioPosicion: 0,
        tendencia: 'Sin datos',
      );
    }
    historyPosition.sort((a, b) => DateTime.parse(b.date)
        .compareTo(DateTime.parse(a.date))); // orden descendente por fecha
    final posicionActual = historyPosition[0].position;
    final posicionAnterior = historyPosition.length > 1
        ? historyPosition[1].position
        : posicionActual;

    final cambio = posicionAnterior - posicionActual;

    String tendencia;
    if (cambio > 0) {
      tendencia = 'Subió'; // Mejoró su ranking (ej. de 5 a 2)
    } else if (cambio < 0) {
      tendencia = 'Bajó'; // Empeoró su ranking (ej. de 2 a 5)
    } else {
      tendencia = 'Igual'; // No cambió
    }

    return RankingResumen(
      posicionActual: posicionActual,
      totalUsuarios: totalUsuarios,
      cambioPosicion: cambio.abs(), // Siempre positivo
      tendencia: tendencia,
    );
  }

  ResumenEntrenamiento obtenerResumenUltimaSesion() {
    if (progressHistory.isEmpty) {
      return ResumenEntrenamiento(
        preguntas: 0,
        duracion: formatDuration(Duration.zero),
        resultado: 'Sin datos',
      );
    }

    // Ordenar por fecha descendente
    progressHistory.sort((a, b) => b.date.compareTo(a.date));
    final ultima = progressHistory.first;

    return ResumenEntrenamiento(
      preguntas: int.tryParse(ultima.numberSession) ?? 0,
      duracion: ultima.duration,
      resultado: ultima.result,
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  factory Grado.fromJson(Map<String, dynamic> json) => Grado(
        grado: json["grado"],
        idGrado: json["idGrado"],
        historyPosition: json["historyPosition"] == null
            ? []
            : List<HistoryPosition>.from(json["historyPosition"]!
                .map((x) => HistoryPosition.fromJson(x))),
        progressHistory: json["progressHistory"] == null
            ? []
            : List<ProgressHistory>.from(json["progressHistory"]!
                .map((x) => ProgressHistory.fromJson(x))),
        historyTime: json["historyTime"] == null
            ? []
            : List<HistoryTime>.from(
                json["historyTime"]!.map((x) => HistoryTime.fromJson(x))),
        scoreSimulacro: json["scoreSimulacro"] ?? 0.0,
        asignaturas: json["asignaturas"] == null
            ? []
            : List<Asignatura>.from(
                json["asignaturas"]!.map((x) => Asignatura.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "grado": grado,
        "idGrado": idGrado,
        "scoreSimulacro": scoreSimulacro,
        "progressHistory":
            List<dynamic>.from(progressHistory.map((x) => x.toJson())),
        "historyTime": List<dynamic>.from(historyTime.map((x) => x.toJson())),
        "historyPosition":
            List<dynamic>.from(historyPosition.map((x) => x.toJson())),
        "asignaturas": asignaturas == null
            ? []
            : List<dynamic>.from(asignaturas!.map((x) => x.toJson())),
      };
}

class Asignatura {
  String? asignaturaId;
  String? asignatura;
  String? currentColor;
  String? previewColor;
  String level;
  int score;

  Asignatura({
    this.asignaturaId,
    this.asignatura,
    this.currentColor,
    this.previewColor,
    this.level = "nivel_0",
    this.score = 0,
  });

  factory Asignatura.fromJson(Map<String, dynamic> json) => Asignatura(
        asignaturaId: json["asignatura_id"],
        asignatura: json["asignatura"],
        level: json["level"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "asignatura_id": asignaturaId,
        "asignatura": asignatura,
        "level": level,
        "score": score,
      };
}

class HistoryTime {
  final String date;
  final String time;
  HistoryTime({
    required this.date,
    required this.time,
  });
  factory HistoryTime.fromJson(Map<String, dynamic> json) => HistoryTime(
        date: json["date"],
        time: json["time"],
      );
  Map<String, dynamic> toJson() => {
        "date": date,
        "time": time,
      };
}

class HistoryPosition {
  final String date;
  final int position;
  HistoryPosition({
    required this.date,
    required this.position,
  });
  factory HistoryPosition.fromJson(Map<String, dynamic> json) =>
      HistoryPosition(
        date: json["date"],
        position: json["position"],
      );
  Map<String, dynamic> toJson() => {
        "date": date,
        "position": position,
      };
}

class ProgressHistory {
  final String date;

  final String numberSession;
  final String duration;
  final String result;
  ProgressHistory({
    required this.date,
    required this.numberSession,
    required this.duration,
    required this.result,
  });
  factory ProgressHistory.fromJson(Map<String, dynamic> json) =>
      ProgressHistory(
        date: json["date"],
        numberSession: json["numberSession"],
        duration: json["duration"],
        result: json["result"],
      );
  Map<String, dynamic> toJson() => {
        "date": date,
        "numberSession": numberSession,
        "duration": duration,
        "result": result,
      };
}

class RankingResumen {
  final int posicionActual;
  final int totalUsuarios;
  final int cambioPosicion;
  final String tendencia; // NUEVO CAMPO

  RankingResumen({
    required this.posicionActual,
    required this.totalUsuarios,
    required this.cambioPosicion,
    required this.tendencia,
  });

  Map<String, dynamic> toJson() => {
        "posicionActual": posicionActual,
        "totalUsuarios": totalUsuarios,
        "cambioPosicion": cambioPosicion,
        "tendencia": tendencia,
      };
}

class ResumenEntrenamiento {
  final int preguntas;

  final String duracion;
  final String resultado;

  ResumenEntrenamiento({
    required this.preguntas,
    required this.duracion,
    required this.resultado,
  });
}
