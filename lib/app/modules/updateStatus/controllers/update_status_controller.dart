import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  late TextEditingController inputStatus;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var email = Get.arguments["email"];
  var status = Get.arguments["status"];

  updateStatus(String status) async {
    CollectionReference users = firebaseFirestore.collection("users");
    await users.doc(email).update({
      "status": status,
      "updatedAccount": DateTime.now().toIso8601String(),
    });
  }

  getStatus() async {
    CollectionReference users = firebaseFirestore.collection("users");
    final dataUser = await users.doc(email).get();
    final getDataUser = dataUser.data() as Map<String, dynamic>;
    inputStatus.text = getDataUser["status"];
  }

  @override
  void onInit() {
    getStatus();
    inputStatus = TextEditingController(text: status);
    super.onInit();
  }

  @override
  void dispose() {
    inputStatus.dispose();
    super.dispose();
  }
}
