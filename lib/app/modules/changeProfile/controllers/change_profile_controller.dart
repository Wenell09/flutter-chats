import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late TextEditingController inputName;
  late TextEditingController inputStatus;
  var id = Get.arguments["id"];
  var email = Get.arguments["email"];
  var name = Get.arguments["name"];
  var status = Get.arguments["status"];
  var updatedPhotoUrl = "".obs;
  final ImagePicker picker = ImagePicker();
  XFile? image;
  final isPickImage = false.obs;

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
    updatedPhotoUrl.value = getDataUser["photoUrl"];
  }

  pickImage() async {
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      image = imagePicker;
      isPickImage.value = true;
    }
  }

  uploadImage(String id) async {
    CollectionReference users = firebaseFirestore.collection("users");
    Reference reference = firebaseStorage.ref("$id.png");
    File file = File(image!.path);
    try {
      await reference.putFile(file);
      final dataImage = await reference.getDownloadURL();
      await users.doc(email).update({
        "photoUrl": dataImage,
        "updatedAccount": DateTime.now().toIso8601String()
      });
      updatedPhotoUrl.value = dataImage;
    } catch (e) {
      debugPrint("error :$e");
    }
  }

  deleteImage() {
    isPickImage.value = false;
    image = null;
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
