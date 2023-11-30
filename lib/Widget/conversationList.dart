import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/chatUsersModel.dart';
import '../View/chatDetailPage.dart';

class ConversationList extends StatefulWidget {
  final ChatUser card;

  const ConversationList({super.key, required this.card});
  
  @override
  _ConversationListState createState() => _ConversationListState(card);
}

class _ConversationListState extends State<ConversationList> {
  final ChatUser card;

  _ConversationListState(this.card);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context){
        //   return ChatDetailPage();
        // }));
        Get.to(ChatDetailPage(card: card));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            card.name.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "online",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                fontWeight: true
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "10:30",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: true
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
