// lib/controllers/restaurant_controller.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/core/secure_storage/hive_storage/restaurant_model.dart';
import 'package:reso/data/model/dish_model.dart';
import 'package:reso/feature/hotel/repository/restaurant_repository.dart';
import 'package:reso/providers/local_storage_data_provider.dart';
import 'package:reso/providers/user_data_provider.dart';

final restaurantRepositoryProvider = Provider((ref) => RestaurantRepository());

final restaurantStreamProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(userDataProvider).userData!;
  return ref
      .watch(restaurantRepositoryProvider)
      .getRestaurantsByOwnerId(user.id);
});

final staffStreamProvider = StreamProvider.autoDispose((ref) {
  final restaurant = ref.watch(selectedRestaurantProvider)!;
  return ref
      .watch(restaurantRepositoryProvider)
      .getStaffByRestaurantId(restaurant.id);
});

final staffControllerProvider = Provider((ref) => StaffController(ref));

class StaffController {
  final Ref _ref;

  StaffController(this._ref);
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required String designation,
  }) async {
    try {
      final restaurant = _ref.watch(selectedRestaurantProvider);
      await _ref.read(staffRepositoryProvider).createUser(
            email: email,
            password: password,
            name: name,
            designation: designation,
            place: restaurant!.id,
          );
    } catch (e) {
      rethrow;
    }
  }
}

final staffRepositoryProvider = Provider((ref) => RestaurantRepository());

final selectedRestaurantProvid = StateProvider<Restaurant?>((ref) => null);

final createMenuControllerProvider = Provider((ref) {
  return CreateMenuController(ref);
});

class CreateMenuController {
  final Ref _ref;

  CreateMenuController(this._ref);

  Future<List<String>> uploadImages(List<File> images) async {
    try {
      return await _ref
          .watch(restaurantRepositoryProvider)
          .uploadImages(images);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createDish(
    Dish dish,
    String restaurantId,
  ) async {
    try {
      await _ref
          .watch(restaurantRepositoryProvider)
          .createDish(dish, restaurantId);
    } catch (e) {
      rethrow;
    }
  }
}
