import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter_chat_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount;
  UserCredential? userCredential;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> login() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Proses login
      await _googleSignIn.signOut();
      _googleSignInAccount = await _googleSignIn.signIn();
      final isSuccess = await _googleSignIn.isSignedIn();

      if (isSuccess) {
        final googleAuth = await _googleSignInAccount!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        // Proses add dan get data
        CollectionReference users = firebaseFirestore.collection("users");
        final getUser = await users.doc(userCredential!.user!.email).get();

        if (getUser.exists && getUser.data() != null) {
          final getDataUser = getUser.data() as Map<String, dynamic>;
          saveUserDataToLocal(getDataUser);
          navigateToHome(getDataUser);
        } else {
          await createUser(users);
          final newUser = await users.doc(userCredential!.user!.email).get();
          final getDataUser = newUser.data() as Map<String, dynamic>;
          saveUserDataToLocal(getDataUser);
          navigateToHome(getDataUser);
        }
        await users.doc(userCredential!.user!.email).update({
          "updatedAccount": DateTime.now().toIso8601String(),
        });
        prefs.setBool("auth", true);
        SplashController.isAuthSuccess.value = true;
      } else {
        debugPrint("Gagal Login");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> saveUserDataToLocal(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', userData['id']);
    prefs.setString('email', userData['email']);
    prefs.setString('name', userData['name']);
    prefs.setString('photoUrl', userData['photoUrl']);
    prefs.setString('status', userData['status']);
  }

  Future<Map<String, dynamic>> getUserDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('id') ?? '',
      'email': prefs.getString('email') ?? '',
      'name': prefs.getString('name') ?? '',
      'photoUrl': prefs.getString('photoUrl') ?? '',
      'status': prefs.getString('status') ?? '',
    };
  }

  Future<void> createUser(CollectionReference users) async {
    await users.doc(userCredential!.user!.email).set({
      "id": userCredential!.user!.uid,
      "name": userCredential!.user!.displayName,
      "email": userCredential!.user!.email,
      "photoUrl": userCredential!.user!.photoURL,
      "status": "",
      "createdAccountTime":
          userCredential!.user!.metadata.creationTime!.toIso8601String(),
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedAccount": DateTime.now().toIso8601String(),
      "chats": []
    });
  }

  void navigateToHome(Map<String, dynamic> getDataUser) {
    Get.offAllNamed(
      Routes.HOME,
      arguments: {
        "id": getDataUser["id"] ?? "",
        "email": getDataUser["email"] ?? "",
        "name": getDataUser["name"] ?? "",
        "photo": getDataUser["photoUrl"] ?? "",
        "status": getDataUser["status"] ?? "",
      },
    );
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _googleSignIn.signOut();
    prefs.setBool("auth", false);
    SplashController.isAuthSuccess.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = prefs.getBool("auth") ?? false;
    SplashController.isAuthSuccess.value = auth;
    if (SplashController.isAuthSuccess.value) {
      final getDataUser = await getUserDataFromLocal();
      navigateToHome(getDataUser);
    } else {
      Get.offAllNamed(Routes.INTRODUCTION);
    }
  }
}
