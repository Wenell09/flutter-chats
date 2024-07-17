import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/search_chat_controller.dart';

class SearchChatView extends GetView<SearchChatController> {
  const SearchChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          title: const Text('Search'),
          centerTitle: true,
          backgroundColor: Colors.orange,
          flexibleSpace: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Obx(
                  () => TextField(
                    autofocus: true,
                    cursorColor: Colors.orange,
                    controller: controller.inputSearch,
                    onChanged: (value) {
                      controller.searchUser(value);
                      if (controller.inputSearch.text.isEmpty) {
                        controller.ishiddenClear.value = true;
                        controller.isSearch.value = true;
                      } else {
                        controller.ishiddenClear.value = false;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Cari teman baru disini",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: UnconstrainedBox(
                        child: controller.ishiddenClear.value
                            ? Container()
                            : InkWell(
                                onTap: () => controller.clearButton(),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: const Icon(Icons.clear),
                                ),
                              ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            (controller.isSearch.value)
                ? Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Lottie.asset("assets/search.json", width: 300),
                      const Text(
                        textAlign: TextAlign.center,
                        "Lakukan pencarian untuk mendapatkan teman barumu dan mulai berinteraksi!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : (controller.itemData.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Lottie.asset("assets/chats.json", width: 150),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Tidak ada nama ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Flexible(
                                  child: Text(
                                    maxLines: 1,
                                    controller.inputSearch.text,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Text(
                                  " dalam pencarian",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var itemData = controller.itemData[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15,
                                  right: 5,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black26,
                                        radius: 25,
                                        backgroundImage:
                                            NetworkImage(itemData["photoUrl"]),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(itemData["name"]),
                                          Text(itemData["email"]),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Center(
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () => {
                                            controller.connectUser(
                                                itemData["email"], index),
                                          },
                                          child: Container(
                                            width: 70,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Message",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: controller.itemData.length,
                      )
          ],
        ),
      ),
    );
  }
}
