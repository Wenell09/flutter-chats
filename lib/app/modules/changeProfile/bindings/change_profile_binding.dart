import 'package:flutter_chat_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeProfileController>(
      () => ChangeProfileController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
