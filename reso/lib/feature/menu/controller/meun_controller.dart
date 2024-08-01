// lib/controllers/restaurant_controller.dart

import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/data/model/dish_model.dart';
import 'package:reso/feature/menu/repository/menu_repository.dart';
import 'package:reso/providers/local_storage_data_provider.dart';

final menuRepositoryProvider = Provider((ref) => MenuRepository());
final dishesStreamProvider = StreamProvider.autoDispose((ref) {
  final restaurant = ref.watch(selectedRestaurantProvider)!;
  return ref
      .watch(menuRepositoryProvider)
      .getDishesByRestaurantId(restaurant.id);
});
final menuControllerProvider = Provider((ref) {
  return MenuController(ref);
});

class MenuController {
  final Ref _ref;

  MenuController(this._ref);

  Map<String, List<Dish>> groupDishesByTags(List<Dish> dishes) {
    Map<String, List<Dish>> groupedDishes = {};

    for (var dish in dishes) {
      for (var tag in dish.tags) {
        log('tags are $tag');
        if (!groupedDishes.containsKey(tag)) {
          groupedDishes[tag] = [];
        }
        groupedDishes[tag]!.add(dish);
      }
    }

    return groupedDishes;
  }

  Future<List<String>> uploadImages(List<File> images) async {
    try {
      return await _ref.watch(menuRepositoryProvider).uploadImages(images);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createDish(
    Dish dish,
    String restaurantId,
  ) async {
    try {
      await _ref.watch(menuRepositoryProvider).createDish(dish, restaurantId);
    } catch (e) {
      rethrow;
    }
  }
}
