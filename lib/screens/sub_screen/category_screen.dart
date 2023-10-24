import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../components/my_appbar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Show the skeleton for 3 seconds
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          // After 3 seconds, change to the actual content
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Category',
      ),
      body: _isLoading ? _buildSkeleton() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 250,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue, // Use a light background color
                ),
              ),
              const Positioned(
                top: 15,
                left: 10,
                child: Text(
                  'Hello',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 7,
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
                const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text('Hello'),
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
