import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RoomChatController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController inputChat;
  late FocusNode focusNode;
  var isShowEmoji = false.obs;
  var chatId = Get.arguments["chatId"];
  var nameTarget = Get.arguments["nameTarget"];
  var statusTarget = Get.arguments["statusTarget"];
  var photoTarget = Get.arguments["photoTarget"];
  var emailUser = Get.arguments["emailUser"];
  var emailTarget = Get.arguments["emailTarget"];
  @override
  void onInit() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    inputChat = TextEditingController();
    super.onInit();
  }

  sendChat(String chatId, String emailUsers, String emailTarget,
      String message) async {
    CollectionReference chats = firebaseFirestore.collection("chats");
    CollectionReference users = firebaseFirestore.collection("users");

    // kirim pesan
    await chats.doc(chatId).update({
      "chat": FieldValue.arrayUnion([
        {
          "pengirim": emailUsers,
          "penerima": emailTarget,
          "pesan": message,
          "time": DateTime.now().toIso8601String(),
          "isRead": false,
        }
      ]),
    });
    inputChat.clear();

    // Ambil data target untuk mendapatkan nilai total_unread saat ini
    DocumentSnapshot targetUserDoc = await users.doc(emailTarget).get();
    int totalUnread = 0;
    if (targetUserDoc.exists) {
      List<dynamic> targetUserChats = targetUserDoc['chats'];
      for (var chat in targetUserChats) {
        if (chat['chats_id'] == chatId) {
          totalUnread = chat['total_unread'] + 1;
          break;
        }
      }
    }
    // update data target
    await users.doc(emailTarget).update({
      "chats": [
        {
          "connection": emailUser,
          "chats_id": chatId,
          "total_unread": totalUnread,
          "last_time": DateTime.now().toIso8601String(),
        }
      ],
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(String chatId) =>
      firebaseFirestore.collection("chats").doc(chatId).snapshots();

  String formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  @override
  void dispose() {
    focusNode.dispose();
    inputChat.dispose();
    super.dispose();
  }
}
