// To parse this JSON data, do
//
//     final componenteEducativo = componenteEducativoFromJson(jsonString);

import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:lexxi/utils/loogers_custom.dart';

ComponenteEducativo componenteEducativoFromJson(String str) =>
    ComponenteEducativo.fromJson(json.decode(str));

String componenteEducativoToJson(ComponenteEducativo data) =>
    json.encode(data.toJson());

class ComponenteEducativo {
  String? idRecurso;
  String? tipoRecurso;
  String? id;
  List<Map<String, dynamic>> componente;

  ComponenteEducativo({
    this.idRecurso,
    this.tipoRecurso,
    this.id,
    this.componente = const [],
  });

  factory ComponenteEducativo.fromJson(Map<String, dynamic> json) =>
      ComponenteEducativo(
        idRecurso: json["id_recurso"],
        tipoRecurso: json["tipo_recurso"],
        id: json["id"]??json['_id'],
        componente: json["componente"],
      );

  Map<String, dynamic> toJson() => {
        "id_recurso": idRecurso,
        "tipo_recurso": tipoRecurso,
        "id": id,
        "componente": componente,
      };

  List<Map<String, dynamic>> toListMap(componentes) {
    final List<Map<String, dynamic>> list = [];
    for (var i in componentes) {
      list.add(i);
    }
    return list;
  }

  FleatherController? toFleather() {
    try {
      final document = ParchmentDocument.fromJson(componente);
      return FleatherController(document: document);
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }


}

class Componente {
  Componente();

  factory Componente.fromJson(Map<String, dynamic> json) => Componente();

  Map<String, dynamic> toJson() => {};
}
