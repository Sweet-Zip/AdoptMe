import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/animal_type_model.dart';

class CategoryService with ChangeNotifier {
  final String _baseUrl = 'http://192.168.50.115:3000/api';


  Future<List<AnimalModel>> fetchAnimalTypes() async {
    final response = await http.get(Uri.parse('$_baseUrl/animal_types'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => AnimalModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch animal types');
    }
  }

  static Future getAllAnimals({
    required void Function(List<AnimalModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://192.168.50.115:3000/api/animal_types/'),
      );
      onResult(await compute(_convertData, res.body));
      onReject(null);
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }

  static List<AnimalModel> _convertData(String data) {
    List<AnimalModel> list = animalModelFromJson(data);
    return list;
  }
}