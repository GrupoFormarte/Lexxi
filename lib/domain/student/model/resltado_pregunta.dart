// To parse this JSON data, do
//
//     final resultadoPregunta = resultadoPreguntaFromJson(jsonString);

import 'dart:convert';

ResultadoPregunta resultadoPreguntaFromJson(String str) => ResultadoPregunta.fromJson(json.decode(str));

String resultadoPreguntaToJson(ResultadoPregunta data) => json.encode(data.toJson());

class ResultadoPregunta {
    String idPregunta;
    String asignatura;
    String idEstudiante;
    bool respuesta;

    ResultadoPregunta({
     required   this.idPregunta,
     required   this.asignatura,
      required  this.idEstudiante,
     required   this.respuesta,
    });

    factory ResultadoPregunta.fromJson(Map<String, dynamic> json) => ResultadoPregunta(
        idPregunta: json["idPregunta"],
        asignatura: json["asignatura"],
        idEstudiante: json["idEstudiante"],
        respuesta: json["respuesta"],
    );

    Map<String, dynamic> toJson() => {
        "idPregunta": idPregunta,
        "asignatura": asignatura,
        "idEstudiante": idEstudiante,
        "respuesta": respuesta,
    };
}
