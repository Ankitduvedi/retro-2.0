import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var docs = 0;
  Future<void> fetchDocumentCount() async {
    try {
      log("fetching");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('names').get();
      log('Total documents in "users" collection: ${querySnapshot.docs.length}');
      setState(() {
        docs = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching document count: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDocumentCount();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        onTap: () => fetchDocumentCount,
        child: Container(height: 100, width: 100, color: Colors.red, child: Text(docs.toString())),
      ),
    ));
  }
}
