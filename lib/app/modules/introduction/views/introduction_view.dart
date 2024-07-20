import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Temukan teman baru",
          body:
              "Temukan teman barumu dan berinteraksi dengan mereka tanpa menambahkan daftar teman",
          image: Center(
            child: Lottie.asset("assets/intro1.json", width: 300, height: 300),
          ),
        ),
        PageViewModel(
          title: "Berinteraksi dari mana saja",
          body: "Berinteraksi dengan temanmu walaupun berbeda lokasi.",
          image: Center(
            child: Lottie.asset("assets/intro-2.json", width: 300, height: 300),
          ),
        ),
        PageViewModel(
          title: "Menjadi bagian dari kami",
          body:
              "Login/daftar untuk menjadi bagian dari kami, nikmati fitur-fitur yang disediakan disini.",
          image: Center(
            child: Lottie.asset("assets/intro-3.json", width: 300, height: 300),
          ),
        )
      ],
      showSkipButton: true,
      skip: const Text(
        "Skip",
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
      next: const Text(
        "Next",
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
      done: const Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.orange,
        ),
      ),
      onDone: () => Navigator.of(context).pushReplacementNamed(Routes.LOGIN),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.orange,
        color: Colors.black,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    ));
  }
}
