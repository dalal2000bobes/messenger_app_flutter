import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatPage.dart';
import 'settingPage.dart';

class HomePage extends StatelessWidget {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple.shade300,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey.shade700,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (value) {
          if (value == 0) {
            Get.to(HomePage());
          } else if (value == 1) {
            Get.to(SettingsPage());
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
