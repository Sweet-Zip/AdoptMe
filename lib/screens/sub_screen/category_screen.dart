import 'dart:async';

import 'package:flutter/material.dart';
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
    return FutureBuilder<List<AnimalModel>>(
      future: categoryService.fetchAnimalTypes(),
      // Assuming you have implemented the fetchAnimalTypes function as mentioned earlier
      builder:
          (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeleton();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final List<AnimalModel> animalTypes = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              itemBuilder: (BuildContext context, int index) {
                final AnimalModel animalType = animalTypes[index];
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
                              // Shadow color
                              spreadRadius: 3,
                              // Spread radius
                              blurRadius: 5,
                              // Blur radius
                              offset:
                                  const Offset(0, 1), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            animalType.image,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // If the image is fully loaded, display it
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 10,
                        child: Text(
                          animalType.typeName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                // Shadow color
                                offset: Offset(1, 1),
                                // Horizontal and vertical offset
                                blurRadius: 1, // Shadow blur radius
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: animalTypes.length,
            ),
          );
        } else {
          return const SizedBox(); // Return an empty SizedBox when there is no data
        }
      },
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
