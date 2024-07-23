import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var updateNameUser = "".obs;
  var updatePhotoUser = "".obs;
  var id = Get.arguments["id"];
  var nameUser = Get.arguments["name"];
  var emailUser = Get.arguments["email"];
  var photoUser = Get.arguments["photo"];
  var statusUser = Get.arguments["status"];
  String cutString(String inputString) {
    int index = inputString.indexOf(' ');
    if (index != -1) {
      return inputString.substring(0, index).trim();
    } else {
      return inputString;
    }
  }

  setDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    updateNameUser.value = nameUser;
    updatePhotoUser.value = photoUser;
    prefs.setString('name', nameUser);
    prefs.setString('email', emailUser);
    prefs.setString('photoUrl', photoUser);
    prefs.setString('status', statusUser);
  }

  getDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name') ?? "";
    var email = prefs.getString('email') ?? "";
    var photo = prefs.getString('photoUrl') ?? "";
    var status = prefs.getString('status') ?? "";
    updateNameUser.value = name;
    updatePhotoUser.value = photo;
    nameUser = name;
    emailUser = email;
    photoUser = photo;
    statusUser = status;
  }

  updateUser(String name, String photo) {
    updateNameUser.value = name;
    updatePhotoUser.value = photo;
  }

  @override
  void onInit() {
    setDataUser();
    getDataUser();
    super.onInit();
  }
}
