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

  readChat(String chatId, String emailTarget) async {
    CollectionReference users = firebaseFirestore.collection("users");
    CollectionReference chats = firebaseFirestore.collection("chats");
    final chatDoc = await chats.doc(chatId).get();
    // Ambil data dari dokumen chat
    final data = chatDoc.data() as Map<String, dynamic>;
    // Ambil list chat
    List<dynamic> chatList = data['chat'];
    // Update field isRead pada elemen yang sesuai
    List<Map<String, dynamic>> updatedChatList = chatList.map((item) {
      final chatItem = item as Map<String, dynamic>;
      if (chatItem['isRead'] == false && chatItem['penerima'] == email) {
        return {...chatItem, 'isRead': true};
      }
      return chatItem;
    }).toList();

    // Dapatkan nilai time dari item terakhir di list chat
    // ignore: prefer_typing_uninitialized_variables
    var lastTime;
    if (chatList.isNotEmpty) {
      final lastChatItem = chatList.last as Map<String, dynamic>;
      lastTime = lastChatItem['time'];
    }

    // Perbarui dokumen dengan list yang telah diubah
    await chats.doc(chatId).update({'chat': updatedChatList});
    await users.doc(email).update({
      "chats": [
        {
          "connection": emailTarget,
          "chats_id": chatId,
          "total_unread": 0,
          "last_time": lastTime ?? DateTime.now().toIso8601String(),
        }
      ],
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChatView(
          String chatId) =>
      firebaseFirestore.collection("chats").doc(chatId).snapshots();

  @override
  void onInit() {
    savePhoto();
    getPhoto();
    super.onInit();
  }
}
