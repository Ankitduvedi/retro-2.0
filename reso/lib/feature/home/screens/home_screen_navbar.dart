import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reso/feature/auth/controller/auth_controller.dart';
import 'package:reso/feature/hotel/screen/hotels_list.dart';
import 'package:reso/main.dart';
import 'package:reso/providers/local_storage_data_provider.dart';
import 'package:reso/providers/user_data_provider.dart'; // Import the new widget

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  final Widget childScreen;
  const ScaffoldWithNavBar({required this.childScreen, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar>
    with TickerProviderStateMixin {
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/staff');
        break;
      case 3:
        GoRouter.of(context).go('/menu');
        break;
      case 4:
        GoRouter.of(context).go('/account');
        break;
    }
  }

  bool blackColor = false;
  TabController? _controller;
  FirebaseMessaging? _messaging;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this, initialIndex: 0);
    _messaging = FirebaseMessaging.instance;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotification();
    _requestPermission();
    _handleForegroundNotifications();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      // Navigate to desired screen based on message
    });
  }

  void _checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Navigate to desired screen based on initialMessage
    }
  }

  void _initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Set your app icon here
    //const IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      //iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  void _requestPermission() {
    _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  void _handleForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'channel_description',
              icon: android.smallIcon,
              // other properties...
            ),
          ),
        );
      }
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.4,
          child: Stack(
            children: [
              Column(
                children: [
                  AppBar(
                    title: const Text('Restaurants'),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(child: RestaurantList()),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    context.push('/setupHotelScreen');
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userDataProvider).userData!;
    final restaurant = ref.watch(selectedRestaurantProvider);
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: restaurant != null
            ? Text(
                restaurant.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              )
            : const CircularProgressIndicator(),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(bottom: false, child: widget.childScreen),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          FluentIcons.home_12_filled,
          size: 30,
        ),
        // Customize the color as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.only(bottom: 2),
        color: !blackColor ? Colors.white : Colors.black,
        height: 50,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: TabBar(
          controller: _controller,
          indicatorColor: Colors.transparent,
          onTap: (index) {
            _onItemTapped(index, context);
            if (index != 2) {
              setState(() {
                blackColor = index == 2;
              });
            }
          },
          tabs: [
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 0
                        ? FluentIcons.data_bar_vertical_32_filled
                        : FluentIcons.data_bar_vertical_32_regular,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'KPI',
                    style: TextStyle(fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 0
              //       ? FluentIcons.data_bar_vertical_32_filled
              //       : FluentIcons.data_bar_vertical_32_regular,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 1
                        ? Icons.group
                        : Icons.group_outlined,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'Staff',
                    style: TextStyle(fontSize: 11, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 1 ? Icons.group : Icons.group_outlined,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
            const SizedBox(width: 30), // Space for the floating action button
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 3
                        ? FluentIcons.food_20_filled
                        : FluentIcons.food_20_regular,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 3
              //       ? FluentIcons.food_20_filled
              //       : FluentIcons.food_20_regular,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 4
                        ? FluentIcons.person_20_filled
                        : FluentIcons.person_20_regular,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 4
              //       ? FluentIcons.person_20_filled
              //       : FluentIcons.person_20_regular,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
