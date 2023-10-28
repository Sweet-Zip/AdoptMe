// To parse this JSON data, do
//
//     final animalModel = animalModelFromJson(jsonString);

import 'dart:convert';

List<AnimalModel> animalModelFromJson(String str) => List<AnimalModel>.from(json.decode(str).map((x) => AnimalModel.fromJson(x)));

String animalModelToJson(List<AnimalModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnimalModel {
  int typeId;
  String typeName;
  String image;

  AnimalModel({
    required this.typeId,
    required this.typeName,
    required this.image,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) => AnimalModel(
    typeId: json["type_id"],
    typeName: json["type_name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "type_id": typeId,
    "type_name": typeName,
    "image": image,
  };
}
