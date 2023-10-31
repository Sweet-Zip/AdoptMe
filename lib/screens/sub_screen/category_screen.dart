import 'dart:async';

import 'package:adoptme/logic/animal_type_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../components/my_appbar.dart';
import '../../models/animal_type_model.dart';
import '../../services/category_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryService categoryService = CategoryService();
  bool showSkeleton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Category',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    String? error = context.watch<AnimalTypeLogic>().error;
    if (error != null) {
      debugPrint(error);
      return const Center(child: Text("Something went wrong"));
    } else {
      List<AnimalModel>? animalList =
          context.watch<AnimalTypeLogic>().animalList;
      return _buildCustomGridView(animalList);
    }
  }

  Widget _buildCustomGridView(List<AnimalModel>? items) {
    if (items == null) {
      return const Center(
        child: Text("Something still went Wrong"),
      );
    }
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemView(items[index]);
      },
    );
  }

  Widget _buildItemView(AnimalModel item) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.image.isNotEmpty || item.image != ''
                  ? Image.network(
                      item.image,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                    )
                  : Image.asset('assets/images/image_not_found.jpg'),
            ),
          ),
          Positioned(
            top: 15,
            left: 10,
            child: Text(
              item.typeName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 250,
      ),
      itemBuilder: (BuildContext context, int index) {
        // Simulate loading with a shimmer effect
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, // Use a light background color
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: 7,
    );
  }
}
