import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController inputName;
  late TextEditingController inputStatus;
  var email = Get.arguments["email"];
  var photoUrl = Get.arguments["photoUrl"];
  var name = Get.arguments["name"];
  var status = Get.arguments["status"];

  changeProfile(String getName, String getStatus) async {
    CollectionReference users = firebaseFirestore.collection("users");
    await users.doc(email).update({
      "name": getName,
      "status": getStatus,
      "updatedAccount": DateTime.now().toIso8601String()
    });
  }

  getUpdated() async {
    CollectionReference users = firebaseFirestore.collection("users");
    final dataUser = await users.doc(email).get();
    final getDataUser = dataUser.data() as Map<String, dynamic>;
    inputName.text = getDataUser["name"];
    inputStatus.text = getDataUser["status"];
  }

  @override
  void onInit() {
    getUpdated();
    inputName = TextEditingController(text: name);
    inputStatus = TextEditingController(text: status);
    super.onInit();
  }

  @override
  void dispose() {
    inputName.dispose();
    inputStatus.dispose();
    super.dispose();
  }
}
