import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var photoUser = "".obs;
  var photo = Get.arguments["photo"];
  var email = Get.arguments["email"];
  var name = Get.arguments["name"];
  var status = Get.arguments["status"];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  savePhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    photoUser.value = photo;
    prefs.setString("photo", photo);
  }

  getPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final photoPrefs = prefs.getString("photo") ?? "";
    photoUser.value = photoPrefs;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(String email) =>
      firebaseFirestore.collection("users").doc(email).snapshots();

  String formatDateTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Jika pesan diterima hari ini, kembalikan jam dan menit
      return DateFormat('HH:mm').format(dateTime);
    } else {
      // Jika pesan diterima lebih dari sehari yang lalu, kembalikan tanggal/bulan/tahun
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  void onInit() {
    savePhoto();
    getPhoto();
    super.onInit();
  }
}
