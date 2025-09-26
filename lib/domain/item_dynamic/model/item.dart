import 'dart:convert';
import 'dart:math';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  String? value;
  String? code;
  String? name;
  String? shortName;
  String? id;
  List<String> childrents;
  String? colecction;
  String? codeDep;

  Item({
    this.value,
    this.code,
    this.name,
    this.id,
    this.codeDep,
    this.shortName,
    this.childrents = const [],
    this.colecction,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      value: json["value"],
      code: json["code"],
      codeDep: json["code_dep"], 
      name: json["name"],
      shortName: json["shortName"],
      id: json["id"] ?? json["_id"],
      childrents: json["childrents"] == null
          ? []
          : List<String>.from(json["childrents"]!.map((x) => x)),
      colecction: json["colecction"],
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "code": code,
        "name": name,
        "shortName": shortName,
        "id": id,
        "childrents": childrents == null
            ? []
            : List<dynamic>.from(childrents.map((x) => x)),
        "colecction": colecction,
      };

  bool hasChildren(childId) {
    return childrents.contains(childId);
  }

  List<String> getRandomChildren({int n = 10}) {
    if (n >= childrents.length) {
      return List<String>.from(childrents);
    }

    Random random = Random();
    Set<String> randomChildren = {};

    while (randomChildren.length < n) {
      randomChildren.add(childrents[random.nextInt(childrents.length)]);
    }

    return randomChildren.toList();
  }
}
