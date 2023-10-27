import 'dart:convert';

class UserModel {
  String userId;
  String username;
  String email;
  String profileImage;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"],
      username: json["username"],
      email: json["email"],
      profileImage: json["profile_image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "username": username,
      "email": email,
      "profile_image": profileImage,
    };
  }
}

List<UserModel> userModelFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((json) => UserModel.fromJson(json)).toList();
}

String userModelToJson(List<UserModel> data) {
  final List<Map<String, dynamic>> jsonData =
  data.map((user) => user.toJson()).toList();
  return json.encode(jsonData);
}
