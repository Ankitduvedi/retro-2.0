// lib/data/repositories/restaurant_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reso/data/model/resturant_model.dart';

class RestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Restaurant>> getRestaurantsByOwnerId(String ownerId) {
    return _firestore
        .collection('restaurant')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Restaurant.fromJson(doc.data()))
            .toList());
  }
}
