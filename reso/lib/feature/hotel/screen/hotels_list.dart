import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/core/secure_storage/hive_storage/restaurant_model.dart';
import 'package:reso/feature/hotel/controller/restaurant_controller.dart';
import 'package:reso/providers/local_storage_data_provider.dart';

class RestaurantList extends ConsumerWidget {
  const RestaurantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(restaurantStreamProvider);

    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (restaurants) {
        if (restaurants.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final Restaurant restaurant = restaurants[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                onTap: () {
                  ref
                      .read(selectedRestaurantProvider.notifier)
                      .selectRestaurant(restaurant);
                  Navigator.pop(context); // Close the bottom sheet
                },
                contentPadding: const EdgeInsets.all(16.0),
                leading: restaurant.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          restaurant.image,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.restaurant, size: 50),
                title: Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  restaurant.address,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
