import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/utils/loogers_custom.dart';

AcademicLevelModel academicLevelModelFromJson(String str) =>
    AcademicLevelModel.fromJson(json.decode(str));

String academicLevelModelToJson(AcademicLevelModel data) =>
    json.encode(data.toJson());

class AcademicLevelModel {
  String? idGrado;
  String? levelMax;
  List<TypeLevel> typesLevels;

  AcademicLevelModel({
    this.idGrado,
    this.levelMax,
    required this.typesLevels,
  });

  factory AcademicLevelModel.fromJson(Map<String, dynamic> json) =>
      AcademicLevelModel(
        idGrado: json["id_grado"],
        levelMax: json["levelMax"],
        typesLevels: json["types_levels"] == null
            ? []
            : List<TypeLevel>.from(
                json["types_levels"].map((x) => TypeLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_grado": idGrado,
        "levelMax": typesLevels.isNotEmpty
            ? typesLevels.last.levels.last.puntaje
            : null, // Manejo de listas vacías
        "types_levels": List<dynamic>.from(typesLevels.map((x) => x.toJson())),
      };

  TypeLevel? compare(String puntaje) {
    if (_parseInt(puntaje) < _parseInt(typesLevels.first.min!)) {
      return typesLevels.first;
    }
    for (var i in typesLevels) {
      if (_parseInt(puntaje) <= _parseInt(i.max!)) {
        return i;
      }
    }

    if (_parseInt(typesLevels.last.max!) > _parseInt(puntaje)) {
      return typesLevels.last;
    }
    return null;
  }
}

int _parseInt(String number) {
  int? intValue = int.tryParse(number);
  if (intValue != null) {
    return intValue;
  } else {
    double? doubleValue = double.tryParse(number);
    if (doubleValue != null) {
      return doubleValue.toInt();
    } else {
      throw FormatException('Formato de número inválido', number);
    }
  }
}

class TypeLevel {
  String? name;
  String? color;
  String? min;
  String? max;

  List<Level> levels;

  TypeLevel({
    this.name,
    this.color,
    this.min,
    this.max,
    required this.levels,
  });

  factory TypeLevel.fromJson(Map<String, dynamic> json) => TypeLevel(
        name: json["name"],
        color: json["color"],
        min: json["min"],
        max: json["max"],
        levels: json["levels"] == null
            ? []
            : List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "color": color,
        "min": levels.isNotEmpty ? levels.first.puntaje : null,
        "max": levels.isNotEmpty ? levels.last.puntaje : null,
        "levels": List<dynamic>.from(levels.map((x) => x.toJson())),
      };

  Color getColor() {
    return Color(int.parse("0xff$color"));
  }

  Level? findLevelByPuntaje(String puntaje) {
    if (_parseInt(puntaje) < _parseInt(levels.first.puntaje!)) {
      return levels.first;
    }

    for (var i in levels) {
      if (_parseInt(puntaje) <= _parseInt(i.puntaje!)) {
        return i;
      }
    }

    if (_parseInt(puntaje) > _parseInt(levels.last.puntaje!)) {
      return levels.last;
    }
    return null;
  }

  /// Implementación de igualdad basada en propiedades únicas
  @override
  bool operator ==(covariant TypeLevel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.color == color &&
        other.min == min &&
        other.max == max &&
        const ListEquality().equals(other.levels, levels);
  }

  @override
  int get hashCode =>
      name.hashCode ^
      color.hashCode ^
      min.hashCode ^
      max.hashCode ^
      const ListEquality().hash(levels);
}

class Level {
  String? level;
  String? puntaje;

  Level({
    this.level,
    this.puntaje,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        level: json["level"],
        puntaje: json["puntaje"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "puntaje": puntaje,
      };

  /// Implementación de igualdad basada en propiedades únicas
  @override
  bool operator ==(covariant Level other) {
    if (identical(this, other)) return true;

    return other.level == level && other.puntaje == puntaje;
  }

  @override
  int get hashCode => level.hashCode ^ puntaje.hashCode;
}
