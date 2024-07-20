import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () =>
                  Navigator.of(context).pushNamed(Routes.PROFILE, arguments: {
                "email": controller.email,
                "name": controller.name,
                "photo": controller.photo,
                "status": controller.status,
              }),
              child: Obx(
                () => (controller.photoUser.value.isEmpty)
                    ? const CircleAvatar(
                        backgroundColor: Colors.black,
                      )
                    : Hero(
                        tag: controller.photoUser.value,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage:
                              NetworkImage(controller.photoUser.value),
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamChat(controller.email),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                var userChat = (snapshot.data!.data()
                    as Map<String, dynamic>)["chats"] as List;
                userChat
                    .sort((a, b) => b["last_time"].compareTo(a["last_time"]));
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller
                                .streamChat(userChat[index]["connection"]),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.active) {
                                var connection = snapshot2.data!.data();
                                return InkWell(
                                  onTap: () {
                                    controller.readChat(
                                        userChat[index]["chats_id"],
                                        userChat[index]["connection"]);
                                    Navigator.of(context).pushNamed(
                                      Routes.ROOM_CHAT,
                                      arguments: {
                                        "chatId": userChat[index]["chats_id"],
                                        "emailUser": controller.email,
                                        "nameTarget": connection["name"],
                                        "statusTarget": connection["status"],
                                        "photoTarget": connection["photoUrl"],
                                        "emailTarget": userChat[index]
                                            ["connection"],
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black26,
                                            radius: 28,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                fit: BoxFit.cover,
                                                "${connection!["photoUrl"]}",
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                connection["name"],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              StreamBuilder<
                                                      DocumentSnapshot<
                                                          Map<String,
                                                              dynamic>>>(
                                                  stream:
                                                      controller.streamChatView(
                                                          userChat[index]
                                                              ["chats_id"]),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.data!.data() !=
                                                            null) {
                                                      var chat =
                                                          (snapshot.data!.data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              "chat"] as List;
                                                      if (chat.isEmpty) {
                                                        return const Text("");
                                                      } else {
                                                        var isRead = chat.last[
                                                                "isRead"] ==
                                                            true;
                                                        return Row(
                                                          children: [
                                                            (chat.isEmpty)
                                                                ? const Text("")
                                                                : (chat.last[
                                                                            "pengirim"] ==
                                                                        controller
                                                                            .email)
                                                                    ? (isRead)
                                                                        ? const Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.blue,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : const Icon(
                                                                            Icons.check,
                                                                            size:
                                                                                20,
                                                                          )
                                                                    : const Text(
                                                                        ""),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Flexible(
                                                              child: (chat
                                                                      .isEmpty)
                                                                  ? const Text(
                                                                      "")
                                                                  : Text(
                                                                      chat.last[
                                                                          "pesan"],
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    } else {
                                                      return Container();
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                          stream: controller.streamChatView(
                                              userChat[index]["chats_id"]),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.data() != null) {
                                              var chat = (snapshot.data!.data()
                                                      as Map<String, dynamic>)[
                                                  "chat"] as List;
                                              return (chat.isEmpty)
                                                  ? const Text("")
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 13),
                                                      child: Center(
                                                        child: (userChat[index][
                                                                    "total_unread"] ==
                                                                0)
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(controller
                                                                      .formatDateTime(
                                                                          chat.last[
                                                                              "time"])),
                                                                  Container(
                                                                    height: 15,
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(controller
                                                                      .formatDateTime(
                                                                          chat.last[
                                                                              "time"])),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                    radius: 12,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${userChat[index]["total_unread"]}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            }),
                      ],
                    );
                  },
                  itemCount: userChat.length,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FloatingActionButton(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
          onPressed: () => Navigator.of(context)
              .pushNamed(Routes.SEARCH_CHAT, arguments: controller.email),
          backgroundColor: Colors.orange,
          child: const Icon(
            Icons.add_comment,
            size: 33,
          ),
        ),
      ),
    );
  }
}
