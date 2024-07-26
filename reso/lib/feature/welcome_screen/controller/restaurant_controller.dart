// lib/controllers/restaurant_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/data/model/resturant_model.dart';
import 'package:reso/feature/welcome_screen/repository/restaurant_repository.dart';
import 'package:reso/providers/user_data_provider.dart';

final restaurantRepositoryProvider = Provider((ref) => RestaurantRepository());

final restaurantStreamProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(userDataProvider).userData!;
  return ref
      .watch(restaurantRepositoryProvider)
      .getRestaurantsByOwnerId(user.id);
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
      final restaurant = _ref.watch(selectedRestaurantProvider.notifier).state;
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

final selectedRestaurantProvider = StateProvider<Restaurant?>((ref) => null);
