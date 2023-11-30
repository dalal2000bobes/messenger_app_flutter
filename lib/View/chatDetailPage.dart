import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/ConversationController.dart';
import '../Model/chatMessageModel.dart';
import '../Model/chatUsersModel.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatUser card;

  const ChatDetailPage({super.key, required this.card});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState(card);
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ChatUser card;
  _ChatDetailPageState(this.card);

  // int index = card.id as int;
  int getIndex() {
    int index = card.id as int;
    return index;
  }

  // ConversationController conversationController = Get.put(
  //     ConversationController( destination: 2, ),
  //     permanent: true);

  ConversationController conversationController =
      Get.put(ConversationController());

  // List<ChatMessage> messages = [
  //   ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  //   ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "Hey Kriss, I am doing fine dude. wbu?",
  //       messageType: "sender"),
  //   ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "Is there any thing wrong?", messageType: "sender"),
  // ];

  @override
  void initState() {
    conversationController.messages = [];
    conversationController.destination = card.id as int;
    conversationController.getMessage();
    super.initState();
    print("sssssssssssssssssssssssssssssssssssssssssssssss${card.id}");
    // conversationController.connectToSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple.shade500,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        card.name.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade900, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GetBuilder(
            init: conversationController,
            builder: (conversationController) => ListView.builder(
              itemCount: conversationController.messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment:
                        ((conversationController.messages[index].AccountId ==
                                conversationController.sender)
                            ? Alignment.topLeft
                            : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            (conversationController.messages[index].AccountId ==
                                    conversationController.sender
                                ? Colors.grey.shade200
                                : Colors.purple[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        conversationController.messages[index].content.toString(),
                        // conversationController.decryptAES(conversationController.messages[index].content.toString()),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.grey.shade500,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: conversationController.inputTextMessage,
                      onChanged: (value) {
                        conversationController.currentTypingMessage = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Write Message ...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      conversationController.sendMessageQ1();
                      // conversationController.sendMessageQ2();
                      // conversationController.sendMessageQ3();
                      conversationController.currentTypingMessage = "";
                      conversationController.inputTextMessage.clear();
                      //////////////////////////// SEND MESSAGE ////////////////////////////////////////
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.purple,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
