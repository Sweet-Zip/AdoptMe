// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  int id;
  int userId;
  String title;
  String caption;
  String imageLink;
  int petId;
  String contactNum;
  int like;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.caption,
    required this.imageLink,
    required this.petId,
    required this.contactNum,
    required this.like,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        caption: json["caption"],
        imageLink: json["imageLink"],
        petId: json["petId"],
        contactNum: json["contact_num"],
        like: json["like"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "caption": caption,
        "imageLink": imageLink,
        "petId": petId,
        "contact_num": contactNum,
        "like": like,
      };
}
