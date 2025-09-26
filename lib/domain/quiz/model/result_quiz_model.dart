// To parse this JSON data, do
//
//     final resultQuizModel = resultQuizModelFromJson(jsonString);

import 'dart:convert';

ResultQuizModel resultQuizModelFromJson(String str) =>
    ResultQuizModel.fromJson(json.decode(str));

String resultQuizModelToJson(ResultQuizModel data) =>
    json.encode(data.toJson());

class ResultQuizModel {
  bool? isSimulacro;
  String? rute;
  int respuestaCo = 0;
  List<Respuesta>? respuestas;

  ResultQuizModel({
    this.isSimulacro,
    this.rute,
    this.respuestas,
  });

  factory ResultQuizModel.fromJson(Map<String, dynamic> json) =>
      ResultQuizModel(
        isSimulacro: json["isSimulacro"],
        rute: json["rute"],
        respuestas: json["respuestas"] == null
            ? []
            : List<Respuesta>.from(
                json["respuestas"]!.map((x) => Respuesta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSimulacro": isSimulacro,
        "rute": rute,
        "respuestas": respuestas == null
            ? []
            : List<dynamic>.from(respuestas!.map((x) => x.toJson())),
      };

  String preguntasCorrectas() {
    return _contarRespuestas(true).toString();
  }

  String calcularPorcentajeRespuestasVerdaderas() {
    if (respuestas!.isEmpty) {
      return '0.0'; // Evitar división por cero
    }

    int cantidadRespuestasVerdaderas = _contarRespuestas(true);
    int cantidadTotalRespuestas = respuestas!.length;

    double porcentajeVerdaderas =
        (cantidadRespuestasVerdaderas / cantidadTotalRespuestas) * 100.0;

    return porcentajeVerdaderas.toString();
  }

  String calcularPorcentajeRespuestasNulas() {
    if (respuestas!.isEmpty) {
      return '0.0'; // Evitar división por cero
    }
    int cantidadRespuestasNulas = _contarRespuestasNorespondidas();
    int cantidadTotalRespuestas = respuestas!.length;
    double porcentajeVerdaderas =
        (cantidadRespuestasNulas / cantidadTotalRespuestas) * 100.0;
    if (porcentajeVerdaderas < 100.0) {
      porcentajeVerdaderas = 100.0 - porcentajeVerdaderas;
    }

    return porcentajeVerdaderas.toString();
  }

  String preguntasInCorrectas() {
    return _contarRespuestas(false).toString();
  }

  int _contarRespuestas(bool estadoPregunta) {
    return respuestas!
        .where((respuesta) => respuesta.respuesta == estadoPregunta)
        .length;
  }

  int _contarRespuestasNorespondidas() {
    return respuestas!.where((respuesta) => respuesta.respuesta == null).length;
  }

// Función para agrupar las respuestas por asignatura y calcular el porcentaje de respuestas correctas
  List<AsignaturaPorcentaje> calcularPorcentajeRespuestas() {
    final Map<String, List<Respuesta>> asignaturasAgrupadas = {};

    for (var respuesta in respuestas!) {
      final asignatura = respuesta.asignatura;
      if (!asignaturasAgrupadas.containsKey(asignatura)) {
        asignaturasAgrupadas[asignatura] = [respuesta];
      } else {
        asignaturasAgrupadas[asignatura]!.add(respuesta);
      }
    }

    final List<AsignaturaPorcentaje> asignaturasConPorcentaje = [];
    for (var asignatura in asignaturasAgrupadas.keys) {
      final respuestas = asignaturasAgrupadas[asignatura]!;
      final totalRespuestas = respuestas.length;
      final respuestasCorrectas =
          respuestas.where((r) => r.respuesta == true).length;
      final porcentajeCorrectas = (respuestasCorrectas / totalRespuestas) * 100;
      asignaturasConPorcentaje.add(
        AsignaturaPorcentaje(
            asignatura: asignatura,
            idAsignatura: respuestas[0].idPregunta,
            porcentajeCorrectas: porcentajeCorrectas),
      );
    }

    return asignaturasConPorcentaje;
  }

  List<AsignaturaPorcentaje>
      calcularPromedioRespuestasCorrectasPorAsignatura() {
    if (respuestas!.isEmpty) {
      return []; // No hay respuestas para calcular el promedio
    }

    final Map<String, List<Respuesta>> asignaturasAgrupadas = {};

    for (var respuesta in respuestas!) {
      final asignatura = respuesta.asignatura;
      if (!asignaturasAgrupadas.containsKey(asignatura)) {
        asignaturasAgrupadas[asignatura] = [respuesta];
      } else {
        asignaturasAgrupadas[asignatura]!.add(respuesta);
      }
    }

    final List<AsignaturaPorcentaje> asignaturasConPromedio = [];
    for (var asignatura in asignaturasAgrupadas.keys) {
      final respuestas = asignaturasAgrupadas[asignatura]!;
      final totalRespuestas = respuestas.length;
      final respuestasCorrectas =
          respuestas.where((r) => r.respuesta == true).length;

      double porcentajeCorrectas = respuestasCorrectas / totalRespuestas * 100;
      // Calcular la nota basada en porcentajeCorrectas
      double nota = calcularNota(porcentajeCorrectas);
      asignaturasConPromedio.add(
        AsignaturaPorcentaje(
          asignatura: asignatura,
          nota: nota,
          porcentajeCorrectas: porcentajeCorrectas,
          idAsignatura: respuestas[0].idPregunta,
        ),
      );
    }

    return asignaturasConPromedio;
  }

  double calcularNotaFinal() {
    if (respuestas!.isEmpty) {
      return 0.0; // No hay respuestas para calcular la nota final
    }

    final Map<String, List<Respuesta>> asignaturasAgrupadas = {};

    for (var respuesta in respuestas!) {
      final asignatura = respuesta.asignatura;
      if (!asignaturasAgrupadas.containsKey(asignatura)) {
        asignaturasAgrupadas[asignatura] = [respuesta];
      } else {
        asignaturasAgrupadas[asignatura]!.add(respuesta);
      }
    }

    double totalNotas = 0.0;
    int totalAsignaturas = 0;

    for (var respuestasPorAsignatura in asignaturasAgrupadas.values) {
      final totalRespuestas = respuestasPorAsignatura.length;
      final respuestasCorrectas =
          respuestasPorAsignatura.where((r) => r.respuesta == true).length;
      respuestaCo += respuestasCorrectas;
      double porcentajeCorrectas = respuestasCorrectas / totalRespuestas * 100;

      // Calcular la nota basada en porcentajeCorrectas
      double nota = calcularNota(porcentajeCorrectas);

      totalNotas += nota;
      totalAsignaturas++;
    }

    // Calcular el promedio de las notas
    return totalAsignaturas > 0 ? totalNotas / totalAsignaturas : 0.0;
  }

  double calcularNota(double porcentajeCorrectas) {
    // Asumiendo que cada 20% equivale a 1.0 punto
    int tramos = (porcentajeCorrectas / 20).floor();

    // Limitar la nota a 5.0
    double nota = tramos.toDouble();
    return nota > 5.0 ? 5.0 : nota;
  }
}

class Respuesta {
  String idPregunta;
  String asignatura;
  String? idEstudiante;
  String? idInstituto;
  String? idAsignatura;
  String? idGrado;
  String? dateCreated;
  bool? respuesta;

  Respuesta(
      {required this.idPregunta,
      required this.asignatura,
      this.idAsignatura,
      this.idGrado,
      this.idEstudiante,
      this.respuesta,
      this.idInstituto,
      this.dateCreated});

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
      idPregunta: json["idPregunta"],
      asignatura: json["asignatura"],
      idInstituto: json["idInstituto"],
      idAsignatura: json["idAsignatura"],
      idGrado: json["idGrado"],
      idEstudiante: json["idEstudiante"],
      respuesta: json["respuesta"],
      dateCreated: json["dateCreated"]);

  Map<String, dynamic> toJson() => {
        "idPregunta": idPregunta,
        "asignatura": asignatura,
        "idAsignatura": idAsignatura,
        "idGrado": idGrado,
        "idInstituto": idInstituto,
        "idEstudiante": idEstudiante,
        "dateCreated": dateCreated,
        "respuesta": respuesta,
      };
}

class AsignaturaPorcentaje {
  String asignatura;
  double nota;
  double porcentajeCorrectas;
  String idAsignatura;

  AsignaturaPorcentaje({
    required this.asignatura,
    this.nota = 0,
    required this.porcentajeCorrectas,
    required this.idAsignatura,
  });
}
