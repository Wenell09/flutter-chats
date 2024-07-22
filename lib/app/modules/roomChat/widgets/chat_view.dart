import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/modules/roomChat/controllers/room_chat_controller.dart';

class ChatView extends StatelessWidget {
  final bool isSender;
  final List chat;
  final RoomChatController controller;
  final bool isRead;
  final int index;
  const ChatView({
    super.key,
    required this.isSender,
    required this.chat,
    required this.controller,
    required this.isRead,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Align(
        alignment: (isSender) ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              (isSender) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isSender) ? Colors.orange : Colors.black26,
                borderRadius: (isSender)
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat[index]["pesan"],
                    style: TextStyle(
                      fontSize: 16,
                      color: (isSender) ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.formatTime(chat[index]["time"]),
                        style: TextStyle(
                          color: (isSender) ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      (isSender)
                          ? (isRead)
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.check,
                                  size: 20,
                                )
                          : Container()
                    ],
                  ),
                ],
              ),
            ),
            (isSender)
                ? const SizedBox(
                    height: 5,
                  )
                : const SizedBox(
                    height: 10,
                  ),
          ],
        ),
      ),
    );
  }
}
