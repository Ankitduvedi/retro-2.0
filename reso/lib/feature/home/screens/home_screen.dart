import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso/feature/auth/controller/auth_controller.dart';
import 'package:reso/providers/user_data_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider).userData!;
    return TextButton(
        onPressed: () {
          ref.read(authControllerProvider.notifier).signOut(context);
        },
        child: Text('Logout ${user.name}'));
  }
}
