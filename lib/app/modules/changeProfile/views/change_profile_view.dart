import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_chat_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  const ChangeProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final update = Get.find<ProfileController>();
    final updateHome = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          AvatarGlow(
            glowRadiusFactor: 0.3,
            glowCount: 1,
            glowColor: Colors.black,
            duration: const Duration(seconds: 2),
            child: Obx(
              () => Hero(
                tag: controller.id,
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExtendedNetworkImageProvider(
                        controller.updatedPhotoUrl.value,
                      ),
                      fit: BoxFit.contain,
                    ),
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: TextField(
              controller: controller.inputName,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: TextField(
              controller: controller.inputStatus,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: "Status",
                labelStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (controller.isPickImage.value)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(
                              controller.image!.path,
                            ),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : const Text("No image"),
                  (controller.isPickImage.value)
                      ? InkWell(
                          onTap: () => controller.deleteImage(),
                          child: const Text(
                            "Delete Image",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : InkWell(
                          onTap: () => controller.pickImage(),
                          child: const Text(
                            "Choosen",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          UnconstrainedBox(
            child: InkWell(
              onTap: () {
                controller.changeProfile(
                    controller.inputName.text, controller.inputStatus.text);
                if (controller.isPickImage.value) {
                  controller.uploadImage(controller.id);
                }
                controller.isPickImage.value = false;
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Center(
                        child: Text(
                          "Berhasil Diupdate!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
                Future.delayed(const Duration(seconds: 2), () {
                  update.updateUser(controller.inputName.text,
                      controller.updatedPhotoUrl.value);
                  update.getUpdatePhoto();
                  updateHome.updatePhoto(controller.updatedPhotoUrl.value);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "UPDATE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
