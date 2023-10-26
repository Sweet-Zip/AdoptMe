import 'package:adoptme/services/post_service.dart';
import 'package:flutter/foundation.dart';

import '../models/postModel.dart';

class PostLogic extends ChangeNotifier {
  List<Post>? _postList;
  List<Post>? get postList => _postList;
  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  Future readAllPost() async {
    await PostService.getAllPost(
        onResult: (result) => _postList = result, onReject: (e) => _error = e);
    _loading = false;
    notifyListeners();
  }
}
