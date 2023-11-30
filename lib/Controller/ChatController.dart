import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Repository/ChatRepository.dart' as repo;

import '../Model/chatUsersModel.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  TextEditingController _inputTextSearch = new TextEditingController();
  TextEditingController get inputTextSearch => _inputTextSearch;
  List<ChatUser> contact = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    await getContact();
    update();
    super.onInit();
  }

  Future getContact() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user');
    ChatUser current = ChatUser.fromJson(jsonDecode(user.toString()));
    contact = await repo.getContacts(current.id as int);
  }
}
