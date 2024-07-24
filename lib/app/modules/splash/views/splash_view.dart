import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    final login = Get.find<LoginController>();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        login.autoLogin();
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/splash-chat.json", width: 300, height: 300),
            const Text(
              'Welcome To NelChats',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
