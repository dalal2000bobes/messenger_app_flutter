import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/chatUsersModel.dart';

Future<List<ChatUser>> getContacts(int id) async {
  var path = 'http://192.168.1.9:3000';
  var myUrl = Uri.parse("$path/users/contact?id=$id");
  final responce = await http.get(
    myUrl,
    headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
    },
  );
  print(responce.body);
  var jsonResponse = jsonDecode(responce.body);
  if (responce.statusCode == 200) {
    List<dynamic> body = jsonDecode(responce.body);
    List<ChatUser> sold = [];
    for (int i = 0; i < body.length; i++) {
      sold.add(new ChatUser.fromJson(body[i]));
    }
    return sold;
  } else {
    List<ChatUser> sold = [];
    return sold;
  }
}
