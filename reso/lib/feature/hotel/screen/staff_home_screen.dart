import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reso/data/model/user_model.dart';
import 'package:reso/feature/hotel/controller/restaurant_controller.dart';

class StaffHomeScreen extends ConsumerStatefulWidget {
  const StaffHomeScreen({super.key});
  @override
  StaffHomeScreenState createState() => StaffHomeScreenState();
}

class StaffHomeScreenState extends ConsumerState<StaffHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(staffStreamProvider);

    return Scaffold(
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No staff added'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserModel user = users[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  onTap: () {
                    // ref
                    //     .read(selectedRestaurantProvider.notifier)
                    //     .selectRestaurant(restaurant);
                    // Navigator.pop(context); // Close the bottom sheet
                  },
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: user.image.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            user.image,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.person, size: 50),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    user.email,
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
      ),
      floatingActionButton: IconButton.filledTonal(
        iconSize: 30,
        onPressed: () {
          context.push('/appointStaffScreen');
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
