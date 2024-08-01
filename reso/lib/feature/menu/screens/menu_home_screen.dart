import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/data/model/dish_model.dart';
import 'package:reso/feature/menu/controller/meun_controller.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Entered in menu screen');
    final dishesAsyncValue = ref.watch(dishesStreamProvider);
    log('Entered in menu screen after');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: dishesAsyncValue.when(
        data: (dishes) {
          log('Dishes ${dishes.toString()}');
          final groupedDishes =
              ref.watch(menuControllerProvider).groupDishesByTags(dishes);
          return ListView(
            children: groupedDishes.entries.map((entry) {
              return CategorySection(
                category: entry.key,
                dishes: entry.value,
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;
  final List<Dish> dishes;

  const CategorySection(
      {super.key, required this.category, required this.dishes});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(category),
      children: dishes.map((dish) {
        return ListTile(
          leading: Image.network(dish.images.first, width: 50, height: 50),
          title: Text(dish.name),
          subtitle: Text(dish.description),
          trailing: Text('\$${dish.price}'),
        );
      }).toList(),
    );
  }
}
