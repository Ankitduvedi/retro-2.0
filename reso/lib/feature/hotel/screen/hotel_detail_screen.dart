// lib/screens/hotel_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reso/feature/hotel/controller/restaurant_controller.dart';

class HotelDetailsScreen extends ConsumerWidget {
  final String restaurantId;

  const HotelDetailsScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurant = ref.watch(selectedRestaurantProvid.notifier).state;
    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant Details'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: Text('No restaurant selected')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Details ${restaurant.email}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Create Menu Screen
                context.go('/hotelScreen/createMenuScreen/$restaurantId');
              },
              child: const Text('Create Menu'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Appoint Staff Screen
                context.push('/appointStaffScreen');
              },
              child: const Text('Appoint Staff'),
            ),
          ],
        ),
      ),
    );
  }
}
