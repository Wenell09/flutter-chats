import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SearchChatController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var ishiddenClear = true.obs;
  var isSearch = true.obs;
  var emailUser = Get.arguments;
  late TextEditingController inputSearch;
  var itemData = [].obs;

  searchUser(String user) async {
    CollectionReference users = firebaseFirestore.collection("users");
    try {
      if (user.isNotEmpty) {
        final getData = [];
        String searchKey = user.substring(0, 1).toUpperCase();
        String endKey = '${searchKey.substring(0, 1)}\uf8ff';
        final filteredFirebase = await users
            .orderBy('name')
            .startAt([searchKey]).endAt([endKey]).get();
        getData.clear();

        for (var doc in filteredFirebase.docs) {
          getData.add(doc.data() as Map<String, dynamic>);
        }
        debugPrint("hasil pencarian : ${getData.length}");
        final filtered = getData
            .where((data) =>
                data["name"]
                    .toString()
                    .toLowerCase()
                    .contains(user.toLowerCase()) &&
                data["email"] !=
                    emailUser) // filter jika user mencari nama sendiri
            .toList();
        itemData.assignAll(filtered);
        isSearch.value = false;
      } else {
        itemData.clear();
        isSearch.value = true;
      }
    } catch (e) {
      debugPrint("Error searching user: $e");
    }
  }

  connectUser(String targetUser, int index) async {
    CollectionReference users = firebaseFirestore.collection("users");
    CollectionReference chats = firebaseFirestore.collection("chats");
    try {
      //cek jika user sudah/belum connect user yang dituju
      QuerySnapshot userChats =
          await chats.where("connections", arrayContains: emailUser).get();
      String? existingChatId;
      for (var chat in userChats.docs) {
        List<dynamic> connections = chat.get("connections");
        if (connections.contains(targetUser)) {
          existingChatId = chat.id;
          break;
        }
      }

      if (existingChatId != null) {
        // jika sudah terdaftar
        debugPrint("chat id yang terhubung: $existingChatId");
        Get.toNamed(Routes.ROOM_CHAT, arguments: {
          "chatId": existingChatId,
          "emailUser": emailUser,
          "nameTarget": itemData[index]["name"],
          "statusTarget": itemData[index]["status"],
          "photoTarget": itemData[index]["photoUrl"],
          "emailTarget": itemData[index]["email"],
        });
      } else {
        // jika belum terdaftar
        final chatDocument = await chats.add({
          "connections": [emailUser, targetUser],
          "chat": [],
        });
        // Update db pengguna
        await users.doc(emailUser).update({
          "chats": FieldValue.arrayUnion([
            {
              "connection": targetUser,
              "chats_id": chatDocument.id,
              "total_unread": 0,
              "last_time": DateTime.now().toIso8601String(),
            }
          ]),
        });
        // Update db pengguna yang dituju
        await users.doc(targetUser).update({
          "chats": FieldValue.arrayUnion([
            {
              "connection": emailUser,
              "chats_id": chatDocument.id,
              "total_unread": 0,
              "last_time": DateTime.now().toIso8601String(),
            }
          ]),
        });
        debugPrint("chat room dibuat: ${chatDocument.id}");
        Get.toNamed(Routes.ROOM_CHAT, arguments: {
          "chatId": chatDocument.id,
          "emailUser": emailUser,
          "nameTarget": itemData[index]["name"],
          "statusTarget": itemData[index]["status"],
          "photoTarget": itemData[index]["photoUrl"],
          "emailTarget": itemData[index]["email"],
        });
      }
    } catch (e) {
      debugPrint("Error connecting: $e");
    }
  }

  clearButton() {
    ishiddenClear.value = true;
    isSearch.value = true;
    inputSearch.clear();
  }

  @override
  void onInit() {
    inputSearch = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    inputSearch.dispose();
    super.dispose();
  }
}
