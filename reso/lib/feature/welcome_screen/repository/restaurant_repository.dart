// lib/data/repositories/restaurant_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reso/data/model/resturant_model.dart';
import 'package:reso/data/model/user_model.dart';

class RestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Restaurant>> getRestaurantsByOwnerId(String ownerId) {
    return _firestore
        .collection('restaurant')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Restaurant.fromJson(doc.data()))
            .toList());
  }

  Future<void> createUser({
    required String place,
    required String email,
    required String password,
    required String name,
    required String designation,
  }) async {
    try {
      // Store the current user and their credential
      final User? currentUser = _auth.currentUser;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null || googleUser == null) {
        throw FirebaseAuthException(
            code: 'ERROR_GOOGLE_SIGN_IN_FAILED',
            message: 'Google sign-in failed');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserModel newUser = UserModel.empty();
      newUser.id = userCredential.user!.uid;
      newUser.name = name;
      newUser.designation = designation;
      newUser.email = email;
      newUser.place = place;

      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());

      // Re-authenticate with the original user's credential
      await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }
}
