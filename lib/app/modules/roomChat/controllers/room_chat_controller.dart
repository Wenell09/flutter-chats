import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RoomChatController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController inputChat;
  late ScrollController scrollController;
  late FocusNode focusNode;
  var isShowEmoji = false.obs;
  var chatId = Get.arguments["chatId"];
  var nameTarget = Get.arguments["nameTarget"];
  var statusTarget = Get.arguments["statusTarget"];
  var photoTarget = Get.arguments["photoTarget"];
  var emailUser = Get.arguments["emailUser"];
  var emailTarget = Get.arguments["emailTarget"];
  var resultDay = "";

  sendChat(String chatId, String emailUsers, String emailTarget,
      String message) async {
    CollectionReference chats = firebaseFirestore.collection("chats");
    CollectionReference users = firebaseFirestore.collection("users");

    // kirim pesan
    if (inputChat.text != "") {
      await chats.doc(chatId).update({
        "chat": FieldValue.arrayUnion([
          {
            "pengirim": emailUsers,
            "penerima": emailTarget,
            "pesan": message,
            "time": DateTime.now().toIso8601String(),
            "groupTime": DateFormat.yMMMMd("en_US")
                .format(DateTime.parse(DateTime.now().toIso8601String())),
            "isRead": false,
          }
        ]),
      });
      inputChat.clear();
    } else {
      return "harap isi pesan";
    }

    // Ambil data target untuk mendapatkan nilai total_unread saat ini
    DocumentSnapshot targetUserDoc = await users.doc(emailTarget).get();
    int totalUnread = 0;
    List<dynamic> updatedChats = [];
    if (targetUserDoc.exists) {
      List<dynamic> targetUserChats = targetUserDoc['chats'];
      for (var chat in targetUserChats) {
        if (chat['chats_id'] == chatId) {
          totalUnread = chat['total_unread'] + 1;
          chat['total_unread'] = totalUnread;
          chat['last_time'] = DateTime.now().toIso8601String();
        }
        updatedChats.add(chat);
      }
    }
    // update data target
    await users.doc(emailTarget).update({
      "chats": updatedChats,
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(String chatId) =>
      firebaseFirestore.collection("chats").doc(chatId).snapshots();

  String formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  String formatDateTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Jika pesan diterima hari ini, kembalikan jam dan menit
      resultDay = "hari ini";
      return resultDay;
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      // Jika pesan diterima kemarin, kembalikan "Kemarin"
      resultDay = "kemarin";
      return resultDay;
    } else {
      // Jika pesan diterima lebih dari sehari yang lalu, kembalikan tanggal lainnya
      return DateFormat('dd MMMM yyyy', 'id').format(dateTime);
      // 'id' digunakan untuk bahasa Indonesia pada format nama bulan
    }
  }

  @override
  void onInit() {
    focusNode = FocusNode();
    scrollController = ScrollController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    inputChat = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    inputChat.dispose();
    super.dispose();
  }
}
