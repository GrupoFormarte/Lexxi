// To parse this JSON data, do
//
//     final pregunta = preguntaFromJson(jsonString);

import 'dart:convert';

import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';

DetallePregunta preguntaFromJson(String str) =>
    DetallePregunta.fromJson(json.decode(str));

String preguntaToJson(DetallePregunta data) => json.encode(data.toJson());

class DetallePregunta {
  String? id;
  String? cod;
  String? componente;
  String? competencia;
  String? periodo;
  String? grado;
  String? area;
  String? asignatura;
  String? tipo;
  String? cantRespuesta;
  String? pregunta;
  String? respuestaCorrecta;
  ComponenteEducativo? preguntaComponent;
  List<ComponenteEducativo> respuestasComponete;
  List<String> respuestas;

  DetallePregunta({
    this.id,
    this.cod,
    this.componente,
    this.competencia,
    this.periodo,
    this.grado,
    this.area,
    this.asignatura,
    this.preguntaComponent,
    this.tipo,
    this.cantRespuesta,
    this.pregunta,
    this.respuestaCorrecta,
    this.respuestasComponete = const [],
    this.respuestas = const [],
  });

  factory DetallePregunta.fromJson(Map<String, dynamic> json) =>
      DetallePregunta(
        id: json["id"],
        cod: json["cod"],
        componente: json["componente"],
        competencia: json["competencia"],
        periodo: json["periodo"],
        grado: json["grado"],
        area: json["area"],
        asignatura: json["asignatura"],
        tipo: json["tipo"],
        respuestaCorrecta: json["pregunta_correcta"],
        cantRespuesta: json["cant_respuesta"],
        pregunta: json["pregunta"],
        respuestas: json["respuestas"] == null
            ? []
            : List<String>.from(json["respuestas"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cod": cod,
        "componente": componente,
        "competencia": competencia,
        "periodo": periodo,
        "grado": grado,
        "area": area,
        "asignatura": asignatura,
        "tipo": tipo,
        "cant_respuesta": cantRespuesta,
        "pregunta": pregunta,
        "pregunta_correcta": respuestaCorrecta,
        "respuestas": respuestas == null
            ? []
            : List<dynamic>.from(respuestas.map((x) => x)),
      };

  Map<String, dynamic> toJsonNonNull() {
    Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (cod != null) data['cod'] = cod;
    if (componente != null) data['componente'] = componente;
    if (competencia != null) data['competencia'] = competencia;
    if (periodo != null) data['periodo'] = periodo;
    if (grado != null) data['grado'] = grado;
    if (area != null) data['area'] = area;
    if (asignatura != null) data['asignatura'] = asignatura;
    if (tipo != null) data['tipo'] = tipo;
    if (cantRespuesta != null) data['cant_respuesta'] = cantRespuesta;
    if (pregunta != null) data['pregunta'] = pregunta;
    // Para listas, asegurarse de que no sean nulas y, si no lo son, incluirlas
    data['respuestas'] = List<dynamic>.from(respuestas.map((x) => x));
    return data;
  }
}
