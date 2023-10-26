// To parse this JSON data, do
//
//     final petType = petTypeFromJson(jsonString);

import 'dart:convert';

List<PetType> petTypeFromJson(String str) => List<PetType>.from(json.decode(str).map((x) => PetType.fromJson(x)));

String petTypeToJson(List<PetType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PetType {
    int id;
    String typeTitle;

    PetType({
        required this.id,
        required this.typeTitle,
    });

    factory PetType.fromJson(Map<String, dynamic> json) => PetType(
        id: json["id"],
        typeTitle: json["type_title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type_title": typeTitle,
    };
}
