import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var updateNameUser = "".obs;
  var updatePhotoUser = "".obs;
  var id = Get.arguments["id"];
  var emailUser = Get.arguments["email"];
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
    CollectionReference users = firebaseFirestore.collection("users");
    final dataUser = await users.doc(emailUser).get();
    final getDataUser = dataUser.data() as Map<String, dynamic>;
    prefs.setString('name', getDataUser["name"]);
    prefs.setString('email', emailUser);
    prefs.setString('photoUrl', getDataUser["photoUrl"]);
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
    emailUser = email;
    statusUser = status;
  }

  updateUser(String name, String photo) async {
    final prefs = await SharedPreferences.getInstance();
    updateNameUser.value = name;
    updatePhotoUser.value = photo;
    prefs.setString('name', name);
    prefs.setString('photoUrl', photo);
  }

  getUpdatePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    var photo = prefs.getString('photoUrl') ?? "";
    updatePhotoUser.value = photo;
  }

  @override
  void onInit() {
    setDataUser();
    getDataUser();
    super.onInit();
  }
}
