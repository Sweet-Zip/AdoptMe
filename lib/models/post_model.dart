// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

List<PostModel> postModelFromJson(String str) => List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  int postId;
  String caption;
  String userId;
  int likes;
  String contact;
  String image;
  String animalType;

  PostModel({
    required this.postId,
    required this.caption,
    required this.userId,
    required this.likes,
    required this.contact,
    required this.image,
    required this.animalType,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postId: json["post_id"],
    caption: json["caption"],
    userId: json["user_id"],
    likes: json["likes"],
    contact: json["contact"],
    image: json["image"],
    animalType: json["animal_type"],
  );

  Map<String, dynamic> toJson() => {
    "post_id": postId,
    "caption": caption,
    "user_id": userId,
    "likes": likes,
    "contact": contact,
    "image": image,
    "animal_type": animalType,
  };
}
