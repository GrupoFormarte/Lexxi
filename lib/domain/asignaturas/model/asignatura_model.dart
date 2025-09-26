// To parse this JSON data, do
//
//     final asignatura = asignaturaFromJson(jsonString);

import 'dart:convert';

Asignatura asignaturaFromJson(String str) => Asignatura.fromJson(json.decode(str));

String asignaturaToJson(Asignatura data) => json.encode(data.toJson());

class Asignatura {
    int? id;
    String? value;
    int? gradoId;
    DateTime? createdAt;
    DateTime? updatedAt;

    Asignatura({
        this.id,
        this.value,
        this.gradoId,
        this.createdAt,
        this.updatedAt,
    });

    factory Asignatura.fromJson(Map<String, dynamic> json) => Asignatura(
        id: json["id"],
        value: json["value"],
        gradoId: json["grado_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "grado_id": gradoId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
