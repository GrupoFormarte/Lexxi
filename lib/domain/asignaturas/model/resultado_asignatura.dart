import 'dart:convert';

ResultadoAsignatura resultadoAsignaturaFromJson(String str) => ResultadoAsignatura.fromJson(json.decode(str));

String resultadoAsignaturaToJson(ResultadoAsignatura data) => json.encode(data.toJson());

class ResultadoAsignatura {
    String? idEstudiante;
    String? idAsignatura;
    double? puntaje;
    String? asignaturaValue;

    ResultadoAsignatura({
        this.idEstudiante,
        this.idAsignatura,
        this.puntaje,
        this.asignaturaValue,
    });

    factory ResultadoAsignatura.fromJson(Map<String, dynamic> json) => ResultadoAsignatura(
        idEstudiante: json["id_estudiante"],
        idAsignatura: json["id_asignatura"],
        puntaje:double.parse(json["puntaje"].toString()) ,
        asignaturaValue: json["asignatura_value"],
    );

    Map<String, dynamic> toJson() => {
        "id_estudiante": idEstudiante,
        "id_asignatura": idAsignatura,
        "puntaje": puntaje,
        "asignatura_value": asignaturaValue,
    };
}
