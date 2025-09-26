import 'dart:convert';

class Question {
  final int id;
  final String pregtextov;
  final String recutexto;
  final String asignatura;
  final String? recunombrev;
  final int asignaturId;

  final String pregmaterialrefuerzov;
  final List<Answer> answers;
  final int pregcorrecta;

  Question({
    required this.id,
    required this.pregtextov,
    required this.recutexto,
    required this.pregcorrecta,
    required this.asignatura,
    required this.asignaturId,
    required this.pregmaterialrefuerzov,
    required this.answers,
     this.recunombrev,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawAnswers = json['respuestas'] ?? [];
    final List<Answer> parsedAnswers =
        rawAnswers.map((answer) => Answer.fromJson(answer)).toList();

    return Question(
      id: json['id'] ?? 0,
      pregtextov: json['pregtextov'] ?? '',
      recutexto: json['recutexto'] ?? '',
      asignatura: json['asignatura'] ?? '',
      pregcorrecta: json['pregcorrecta'],
      recunombrev: json['recunombrev'],
      asignaturId: json['asignatura_id'],
      pregmaterialrefuerzov: json['pregmaterialrefuerzov'] ?? '',
      answers: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pregtextov': pregtextov,
      'recutexto': recutexto,
      'asignatura': asignatura,
      'pregcorrecta': pregcorrecta,
      'recunombrev': recunombrev,
      'asignaturId': asignaturId,
      'pregmaterialrefuerzov': pregmaterialrefuerzov,
      'respuestas': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class Answer {
  final int id;
  final int preguntaId;
  final String resptextov;
  final String responidentificadorv;
  final dynamic respmaterialrefuerzov;
  final dynamic respdiagnosticov;
  final dynamic respnivelacercionn;
  final dynamic resppuntosn;
  final dynamic resppropiedadesj;
  final int opprrespuestacorrectab;
  final dynamic opprvalorrespuestad;
  final int opciordenn;
  final dynamic gradidn;
  final dynamic gradnombrev;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Answer({
    required this.id,
    required this.preguntaId,
    required this.resptextov,
    required this.responidentificadorv,
    required this.respmaterialrefuerzov,
    required this.respdiagnosticov,
    required this.respnivelacercionn,
    required this.resppuntosn,
    required this.resppropiedadesj,
    required this.opprrespuestacorrectab,
    required this.opprvalorrespuestad,
    required this.opciordenn,
    required this.gradidn,
    required this.gradnombrev,
    this.createdAt,
    this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] ?? 0,
      preguntaId: json['pregunta_id'] ?? 0,
      resptextov: json['resptextov'] ?? '',
      responidentificadorv: json['responidentificadorv'] ?? '',
      respmaterialrefuerzov: json['respmaterialrefuerzov'],
      respdiagnosticov: json['respdiagnosticov'],
      respnivelacercionn: json['respnivelacercionn'],
      resppuntosn: json['resppuntosn'],
      resppropiedadesj: json['resppropiedadesj'],
      opprrespuestacorrectab: json['opprrespuestacorrectab'] ?? 0,
      opprvalorrespuestad: json['opprvalorrespuestad'],
      opciordenn: json['opciordenn'] ?? 0,
      gradidn: json['gradidn'],
      gradnombrev: json['gradnombrev'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pregunta_id': preguntaId,
      'resptextov': resptextov,
      'responidentificadorv': responidentificadorv,
      'respmaterialrefuerzov': respmaterialrefuerzov,
      'respdiagnosticov': respdiagnosticov,
      'respnivelacercionn': respnivelacercionn,
      'resppuntosn': resppuntosn,
      'resppropiedadesj': resppropiedadesj,
      'opprrespuestacorrectab': opprrespuestacorrectab,
      'opprvalorrespuestad': opprvalorrespuestad,
      'opciordenn': opciordenn,
      'gradidn': gradidn,
      'gradnombrev': gradnombrev,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

String questionToJson(Question data) => json.encode(data.toJson());
String answerToJson(Answer data) => json.encode(data.toJson());
