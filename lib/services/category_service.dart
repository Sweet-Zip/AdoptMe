import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/animal_type_model.dart';

class CategoryService with ChangeNotifier {
  final String _baseUrl = 'http://192.168.207.23:3000/api';


  Future<List<AnimalModel>> fetchAnimalTypes() async {
    final response = await http.get(Uri.parse('$_baseUrl/animal_types'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => AnimalModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch animal types');
    }
  }
}