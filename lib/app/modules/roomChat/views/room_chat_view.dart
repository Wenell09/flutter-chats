// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/modules/roomChat/widgets/chat_view.dart';
import 'package:get/get.dart';
import '../controllers/room_chat_controller.dart';
import 'package:flutter/foundation.dart' as foundation;

class RoomChatView extends GetView<RoomChatController> {
  const RoomChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leadingWidth: 70,
        leading: InkWell(
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              const SizedBox(
                width: 3,
              ),
              const Icon(Icons.arrow_back),
              const SizedBox(
                width: 3,
              ),
              CircleAvatar(
                backgroundColor: Colors.black,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    controller.photoTarget,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.nameTarget,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              controller.statusTarget,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.value) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.of(context).pop();
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamChat(controller.chatId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        var chat = (snapshot.data!.data()
                            as Map<String, dynamic>)["chat"] as List;
                        Timer(
                            Duration.zero,
                            () => controller.scrollController.jumpTo(controller
                                .scrollController.position.maxScrollExtent));
                        return ListView.builder(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            var isSender =
                                chat[index]["pengirim"] == controller.emailUser;
                            var isRead = chat[index]["isRead"] == true;
                            return Column(
                              children: [
                                (index == 0)
                                    ? Center(
                                        child: Text(
                                          controller.formatDateTime(
                                              chat[index]["time"]),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : (chat[index]["groupTime"] ==
                                            chat[index - 1]["groupTime"])
                                        ? const Center()
                                        : Center(
                                            child: Text(
                                              controller.formatDateTime(
                                                  chat[index]["time"]),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                (isSender)
                                    ? Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) {},
                                        confirmDismiss: (direction) {
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                      "Hapus pesan saya?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: const Text(
                                                        "Batal",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        controller.deleteChat(
                                                            controller.chatId,
                                                            chat[index]
                                                                ["groupTime"],
                                                            chat[index]
                                                                ["isRead"],
                                                            chat[index]
                                                                ["penerima"],
                                                            chat[index]
                                                                ["pesan"],
                                                            chat[index]
                                                                ["time"]);
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: const Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          decoration: const BoxDecoration(
                                              color: Colors.red),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 25,
                                          ),
                                        ),
                                        child: ChatView(
                                          isSender: isSender,
                                          chat: chat,
                                          controller: controller,
                                          isRead: isRead,
                                          index: index,
                                        ),
                                      )
                                    : ChatView(
                                        isSender: isSender,
                                        chat: chat,
                                        controller: controller,
                                        isRead: isRead,
                                        index: index,
                                      )
                              ],
                            );
                          },
                          itemCount: chat.length,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          focusNode: controller.focusNode,
                          controller: controller.inputChat,
                          cursorColor: Colors.orange,
                          decoration: InputDecoration(
                            focusColor: Colors.orange,
                            hoverColor: Colors.orange,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            prefixIcon: IconButton(
                              onPressed: () {
                                controller.focusNode.unfocus();
                                controller.isShowEmoji.toggle();
                              },
                              icon: const Icon(Icons.emoji_emotions_outlined),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => controller.sendChat(
                        controller.chatId,
                        controller.emailUser,
                        controller.emailTarget,
                        controller.inputChat.text,
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 23,
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Obx(
              () => (controller.isShowEmoji.value)
                  ? EmojiPicker(
                      textEditingController: controller.inputChat,
                      config: Config(
                        height: 256,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 28 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.20
                                  : 1.0),
                        ),
                        swapCategoryAndBottomBar: true,
                        skinToneConfig: const SkinToneConfig(
                          dialogBackgroundColor: Colors.orange,
                        ),
                        categoryViewConfig: const CategoryViewConfig(
                          backspaceColor: Colors.black,
                          iconColor: Colors.black,
                          iconColorSelected: Colors.orange,
                          indicatorColor: Colors.orange,
                        ),
                        bottomActionBarConfig: const BottomActionBarConfig(
                          backgroundColor: Colors.orange,
                          buttonColor: Colors.black,
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
