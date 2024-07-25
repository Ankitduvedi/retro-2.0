// lib/controllers/restaurant_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/feature/welcome_screen/repository/setup_hotel_repository.dart';
import 'package:reso/providers/user_data_provider.dart';

final restaurantRepositoryProvider = Provider((ref) => RestaurantRepository());

final restaurantStreamProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(userDataProvider).userData!;
  return ref
      .watch(restaurantRepositoryProvider)
      .getRestaurantsByOwnerId(user.id);
});
