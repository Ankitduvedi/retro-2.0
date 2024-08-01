// lib/data/repositories/restaurant_repository.dart

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reso/data/model/dish_model.dart';

class MenuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Dish>> getDishesByRestaurantId(String restaurantId) {
    log('Restaurant id getDishesByRestaurantId$restaurantId');
    return _firestore
        .collection('restaurant')
        .doc(restaurantId)
        .collection('dishes')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Dish.fromJson(doc.data())).toList());
  }

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      Reference ref =
          _storage.ref().child('dish_images/${image.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  Future<void> createDish(Dish dish, String restaurantId) async {
    try {
      final docRef =
          _firestore.collection('restaurant/$restaurantId/dishes').doc();
      dish.id = docRef.id;
      await docRef.set(dish.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
