// lib/screens/hotel_screen.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reso/data/model/resturant_model.dart';
import 'package:reso/feature/welcome_screen/controller/restaurant_controller.dart';

class HotelScreen extends ConsumerStatefulWidget {
  const HotelScreen({super.key});

  @override
  ConsumerState<HotelScreen> createState() => HotelScreenState();
}

class HotelScreenState extends ConsumerState<HotelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Hotels'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer(
        builder: (context, watch, child) {
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
                  log('length ${restaurants.length}');
                  final Restaurant restaurant = restaurants[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        ref.read(selectedRestaurantProvider.notifier).state =
                            restaurant;
                        context.push(
                            '/hotelScreen/hotelDetailsScreen/${restaurant.id}');
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          context.push('/hotelScreen/setupHotelScreen');
        },
        child: const Icon(
          Icons.group_add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
