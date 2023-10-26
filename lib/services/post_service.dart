import 'package:adoptme/models/postModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future getAllPost({
    required void Function(List<Post>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      http.Response res = await http
          .get(Uri.parse("https://7lbhmj6r-3000.asse.devtunnels.ms/post"));
      onResult(await compute(_convertData, res.body));
      onReject(null);
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  static List<Post> _convertData(String data) {
    List<Post> list = postFromJson(data);
    return list;
  }
}
