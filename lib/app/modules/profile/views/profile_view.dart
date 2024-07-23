import 'package:avatar_glow/avatar_glow.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/modules/login/controllers/login_controller.dart';
import 'package:flutter_chat_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<LoginController>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.28,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 20,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                Center(
                  child: Obx(() => Text(
                        controller.updateNameUser.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
                ListTile(
                  title: const Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: Obx(
                    () => Text(
                      controller.cutString(controller.updateNameUser.value),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: Text(
                    controller.emailUser,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(Routes.CHANGE_PROFILE, arguments: {
                    "id": controller.id,
                    "email": controller.emailUser,
                    "name": controller.updateNameUser.value,
                    "status": controller.statusUser,
                  }),
                  child: const ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    title: Text(
                      "Change Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_outlined,
                      size: 30,
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(Routes.UPDATE_STATUS, arguments: {
                    "email": controller.emailUser,
                    "status": controller.statusUser,
                  }),
                  child: const ListTile(
                    leading: Icon(
                      Icons.note_alt_outlined,
                      size: 30,
                    ),
                    title: Text(
                      "Update Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_outlined,
                      size: 30,
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                          ),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: const Text(
                            textAlign: TextAlign.center,
                            "Apakah Anda yakin untuk keluar?",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                "Batal",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => auth.logout(),
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_outlined,
                      size: 30,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.dark_mode,
                    size: 30,
                  ),
                  title: const Text(
                    "dark Mode",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Switch(
                    value: true,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey[700],
                    inactiveTrackColor: Colors.white,
                    inactiveThumbColor: Colors.grey[700],
                    onChanged: (value) async {},
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Versi Aplikasi\n1.0.0",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28 - 65,
              left: MediaQuery.of(context).size.width / 2 - 62.5,
              child: AvatarGlow(
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
                            controller.updatePhotoUser.value,
                          ),
                          fit: BoxFit.cover,
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
            ),
          ],
        ),
      ),
    );
  }
}
