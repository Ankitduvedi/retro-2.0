import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reso/core/secure_storage/saving_data.dart';
import 'package:reso/data/model/failure.dart';
import 'package:reso/data/model/user_model.dart';
import 'package:reso/providers/user_data_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref: ref);
});

class AuthRepository extends ConsumerStatefulWidget {
  final Ref _ref;

  const AuthRepository({super.key, required Ref ref}) : _ref = ref;

  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      log("registering with email and password");
      final creds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      log("uid is ${creds.user!.uid}");
      SecureStorage().setTempAccessToken('tempAccessToken', 'onboarded');
      SecureStorage().setUserAccessToken('accessToken', creds.user!.uid);
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      UserModel userModel;
      userModel = UserModel(
          id: creds.user!.uid,
          name: name,
          isNewUser: true,
          email: email.toString(),
          about: '',
          image:
              'https://firebasestorage.googleapis.com/v0/b/while-2.appspot.com/o/profile_pictures%2FKIHEXrUQrzcWT7aw15E2ho6BNhc2.jpg?alt=media&token=1316edc6-b215-4655-ae0d-20df15555e34',
          createdAt: time,
          pushToken: '',
          dateOfBirth: '',
          gender: '',
          phoneNumber: '',
          place: '',
          designation: 'Member',
          isApproved: 0,
          tourPage: "");
      log('/////as////${FirebaseAuth.instance.currentUser!.uid}');
      await createNewUser(userModel);
      return right(userModel);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // Attempt to log in.
      log("logging with email and password");
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Get UID of the logged-in user.
      final String uid = credentials.user!.uid;

      // Fetch user data from Firestore using UID.
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return left(Failure(message: "No account exists for this user."));
      } else {
        // Check if credentials.credential and accessToken are not null
        // String userAccessToken = credentials.credential!.accessToken!.toString();
        SecureStorage().setTempAccessToken('tempAccessToken', 'onboarded');
        SecureStorage().setUserAccessToken('accessToken', uid);
        final UserModel user =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        UserDataProvider userDataProvider =
            UserDataProvider(_ref); // Create an instance
        userDataProvider.updateUserData(user);

        return right(user);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions.
      log(e.toString());
      return left(
          Failure(message: e.message ?? "An error occurred during login."));
    } catch (e) {
      // Handle any other exceptions.
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> signout() async {
    try {
      SecureStorage().setUserAccessToken('accessToken', '');
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      return right(r"Successfully signed out.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        log("Network error: ${e.toString()}");
        return left(Failure(message: "No internet connection available."));
      } else {
        log("FirebaseAuth error: ${e.toString()}");
        return left(Failure(message: "Authentication error: ${e.message}"));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteAccount() async {
    try {
      // await APIs.updateActiveStatus(false);
      await FirebaseAuth.instance.currentUser!.delete();
      return right("Account deleted successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        log("Network error: ${e.toString()}");
        return left(Failure(message: "No internet connection available."));
      } else {
        log("FirebaseAuth error: ${e.toString()}");
        return left(Failure(message: "Authentication error: ${e.message}"));
      }
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<DocumentSnapshot> getSnapshot() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    return snapshot;
  }

  Future<Either<Failure, UserModel>> signInWithGoogle(Ref ref) async {
    try {
      log("Entered in Google sign in function");
      // Assumed _googleSignIn and _auth are initialized

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        SecureStorage().setUserAccessToken(
            'accessToken', googleAuth!.accessToken.toString());

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        log("sign in successfully");
        log("userCredential2 ${userCredential.user!.uid}");

        if (userCredential.user != null) {
          final User newUser = userCredential.user!;
          UserModel userModel;

          if (userCredential.additionalUserInfo!.isNewUser) {
            log("new user");
            // Set isNewUser to true

            // Define userModel for a new user
            final time = DateTime.now().millisecondsSinceEpoch.toString();
            userModel = UserModel(
              id: newUser.uid,
              name: newUser.displayName.toString(),
              email: newUser.email.toString(),
              about: 'Hey I am ${newUser.displayName}',
              image:
                  'https://firebasestorage.googleapis.com/v0/b/while-2.appspot.com/o/profile_pictures%2FKIHEXrUQrzcWT7aw15E2ho6BNhc2.jpg?alt=media&token=1316edc6-b215-4655-ae0d-20df15555e34',
              createdAt: time,
              isNewUser: true,
              pushToken: '',
              dateOfBirth: '',
              gender: '',
              phoneNumber: '',
              place: '',
              designation: 'Member',
              isApproved: 0,
              tourPage: "",
            );
            await createNewUser(
                userModel); // Ensure this is awaited if asynchronous

            log("success new user");
          } else {
            userModel = getUserData(
              newUser.uid,
            ); // Assume this fetches the user correctly
            log("existing user");
          }

          return right(userModel); // Return userModel instead of newUser
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        log("Network error: ${e.toString()}");
        return left(Failure(message: "No internet connection available."));
      } else {
        log("FirebaseAuth error: ${e.toString()}");
        return left(Failure(message: "Authentication error: ${e.message}"));
      }
    } catch (e) {
      log(e.toString());
      // Log any other exceptions
      if (e is PlatformException) {
        return left(Failure(message: "Try checking your network connection"));
      } else {
        return left(Failure(message: "Error  $e"));
      }
    }
    // Handle case where Google sign-in was cancelled or failed before returning
    return left(Failure(message: "Google sign-in failed."));
  }

  Future<void> createNewUser(UserModel newUser) async {
    log(' users given id is /: ${newUser.name}');
    log(newUser.id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.id)
        .set(newUser.toJson());
    UserDataProvider userDataProvider =
        UserDataProvider(_ref); // Create an instance
    // userDataProvider.setUserData(newUser);
  }

  UserModel getUserData(
    String uid,
  ) {
    UserDataProvider userDataProvider =
        UserDataProvider(_ref); // Create an instance
    UserModel user = userDataProvider.userData!;
    return user;
  }

  Stream<User?> get authStateChange => FirebaseAuth.instance.authStateChanges();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    throw UnimplementedError();
  }
}
