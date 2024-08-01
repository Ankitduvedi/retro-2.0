// lib/ui/create_menu_screen.dart

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reso/data/model/dish_model.dart';
import 'package:reso/feature/hotel/controller/restaurant_controller.dart';

class CreateMenuScreen extends ConsumerStatefulWidget {
  final String restaurantId;

  const CreateMenuScreen({super.key, required this.restaurantId});

  @override
  CreateMenuScreenState createState() => CreateMenuScreenState();
}

class CreateMenuScreenState extends ConsumerState<CreateMenuScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _ratingsController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  _uploadImages() async {
    setState(() {
      _isUploading = true;
    });

    List<File> imageFiles =
        _selectedImages.map((xFile) => File(xFile.path)).toList();

    try {
      final createMenuController = ref.read(createMenuControllerProvider);
      await createMenuController.uploadImages(imageFiles).then(
        (value) async {
          final List<String> tags = _tagsController.text.split(',');
          final Dish newDish = Dish(
            name: _nameController.text,
            description: _descriptionController.text,
            price: _priceController.text,
            cookingTime: _cookingTimeController.text,
            quantity: _quantityController.text,
            discount: _discountController.text,
            ratings: _ratingsController.text,
            category: _categoryController.text,
            subCategory: _subCategoryController.text,
            tags: tags,
            images: value,
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            id: '',
          );
          log('list of urls of images $value');
          await createMenuController.createDish(newDish, widget.restaurantId);
          //return value;
        },
      );
      setState(() {
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      rethrow;
    }
  }

  void _createDish() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    try {
      await _uploadImages();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dish created successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create dish: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cookingTimeController,
              decoration: const InputDecoration(
                labelText: 'Cooking Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: 'Discount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ratingsController,
              decoration: const InputDecoration(
                labelText: 'Ratings',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subCategoryController,
              decoration: const InputDecoration(
                labelText: 'Sub Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Pick Images'),
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedImages.map((image) {
                  return Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _createDish,
              child: _isUploading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Create Dish'),
            ),
          ],
        ),
      ),
    );
  }
}
