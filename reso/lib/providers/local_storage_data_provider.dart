import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:reso/core/secure_storage/hive_storage/restaurant_model.dart';

final selectedRestaurantProvider =
    StateNotifierProvider<SelectedRestaurantNotifier, Restaurant?>((ref) {
  return SelectedRestaurantNotifier();
});

class SelectedRestaurantNotifier extends StateNotifier<Restaurant?> {
  SelectedRestaurantNotifier() : super(null) {
    _loadFromLocalStorage();
  }

  void selectRestaurant(Restaurant restaurant) {
    state = restaurant;
    _saveToLocalStorage(restaurant);
  }

  void _loadFromLocalStorage() async {
    final box = await Hive.openBox<Restaurant>('restaurantBox');
    final restaurant = box.get('selectedRestaurant');
    if (restaurant != null) {
      state = restaurant;
    }
  }

  void _saveToLocalStorage(Restaurant restaurant) async {
    final box = await Hive.openBox<Restaurant>('restaurantBox');
    await box.put('selectedRestaurant', restaurant);
  }
}
