import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChatView(
          String chatId) =>
      firebaseFirestore.collection("chats").doc(chatId).snapshots();

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

    // update isRead penerima
    final chatDoc = await chats.doc(chatId).get();
    final data = chatDoc.data() as Map<String, dynamic>;
    List<dynamic> chatList = data['chat'];
    List<Map<String, dynamic>> updatedChatList = chatList.map((item) {
      final chatItem = item as Map<String, dynamic>;
      if (chatItem['isRead'] == false && chatItem['penerima'] == email) {
        return {...chatItem, 'isRead': true};
      }
      return chatItem;
    }).toList();
    await chats.doc(chatId).update({'chat': updatedChatList});

    // update db user dan hapus total unreadnya
    final userDoc = await users.doc(email).get();
    int totalUnread = 0;
    List<dynamic> updatedChats = [];
    if (userDoc.exists) {
      List<dynamic> listChats = userDoc["chats"];
      for (var chats in listChats) {
        if (chats["connection"] == emailTarget) {
          chats["total_unread"] = totalUnread;
          chats["last_time"] = DateTime.now().toIso8601String();
        }
        updatedChats.add(chats);
      }
    }
    await users.doc(email).update({'chats': updatedChats});
  }

  deleteChats(String chatId, String emailTarget) async {
    CollectionReference users = firebaseFirestore.collection("users");
    CollectionReference chats = firebaseFirestore.collection("chats");

    // ambil nilai totalUnread users dan target
    final userDoc = await users.doc(email).get();
    final targetDoc = await users.doc(emailTarget).get();
    int totalUnreadUsers = 0;
    int totalUnreadTarget = 0;
    String dateTimeUser = "";
    String dateTimeTarget = "";
    List<dynamic> listChats = userDoc["chats"];
    for (var chats in listChats) {
      if (chats["connection"] == emailTarget) {
        totalUnreadUsers = chats["total_unread"];
        dateTimeUser = chats["last_time"];
        debugPrint("isi total unread : $totalUnreadUsers");
        debugPrint("isi total last time : $dateTimeUser");
        break;
      }
    }
    List<dynamic> listChatsTarget = targetDoc["chats"];
    for (var chatsTarget in listChatsTarget) {
      if (chatsTarget["connection"] == email) {
        totalUnreadTarget = chatsTarget["total_unread"];
        dateTimeTarget = chatsTarget["last_time"];
        debugPrint("isi total unread : $totalUnreadTarget");
        debugPrint("isi total last time : $dateTimeTarget");
        break;
      }
    }

    // hapus doc sesuai id di collection chat
    await chats.doc(chatId).delete();
    // perbarui data users dan target
    await users.doc(email).update({
      "chats": FieldValue.arrayRemove([
        {
          "connection": emailTarget,
          "chats_id": chatId,
          "total_unread": totalUnreadUsers,
          "last_time": dateTimeUser,
        }
      ]),
    });
    await users.doc(emailTarget).update({
      "chats": FieldValue.arrayRemove([
        {
          "connection": email,
          "chats_id": chatId,
          "total_unread": totalUnreadTarget,
          "last_time": dateTimeTarget,
        }
      ]),
    });
  }

  @override
  void onInit() {
    savePhoto();
    getPhoto();
    super.onInit();
  }
}
