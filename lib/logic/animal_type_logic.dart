import 'package:adoptme/services/category_service.dart';
import 'package:flutter/material.dart';

import '../models/animal_type_model.dart';

class AnimalTypeLogic extends ChangeNotifier{
  List<AnimalModel>? _animalList;

  List<AnimalModel>? get animalList => _animalList;

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  String? _animalId;

  String? get animalId => _animalId;

  String? _typeName;

  String? get typeName => _typeName;

  String? _image;

  String? get image => _image;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future<void> readAnimal() async {
    setLoading();
    try {
      await CategoryService.getAllAnimals(
        onResult: (result) => _animalList = result,
        onReject: (e) => _error = e,
      );
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}