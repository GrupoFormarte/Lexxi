// To parse this JSON data, do
//
//     final level = levelFromJson(jsonString);

import 'dart:convert';

Level levelFromJson(String str) => Level.fromJson(json.decode(str));

String levelToJson(Level data) => json.encode(data.toJson());

class Level {
    String? level;
    String? currentColor;
    String? typeName;
    String? previousColor;

    Level({
        this.level,
        this.currentColor,
        this.typeName,
        this.previousColor,
    });

    factory Level.fromJson(Map<String, dynamic> json) => Level(
        level: json["level"],
        currentColor: json["currentColor"],
        typeName: json["typeName"],
        previousColor: json["previousColor"],
    );

    Map<String, dynamic> toJson() => {
        "level": level,
        "currentColor": currentColor,
        "typeName": typeName,
        "previousColor": previousColor,
    };
}
