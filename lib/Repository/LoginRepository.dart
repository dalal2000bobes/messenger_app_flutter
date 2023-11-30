import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/chatUsersModel.dart';

Future<String> getLogin(String phone, String password) async {
  var path = 'http://192.168.1.9:3000';
  var myUrl =
      Uri.parse("$path/users/login?phoneNumber=${phone}&password=${password}");
  final response = await http.get(
    myUrl,
    headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
    },
  );
  return response.body;
}

Future<String> signup(var user) async {
  var path = 'http://192.168.1.9:3000';
  var myUrl = Uri.parse("$path/users/signup");
  final response = await http.post(myUrl,
      headers: {
        'Accept': 'application/json',
        'Charset': 'utf-8',
      },
      body: user);
  return response.body;
}

Future<ChatUser> getUserInfo(int id) async {
  var path = 'http://192.168.1.9:3000';
  var myUrl =
      Uri.parse("$path/users/one?id=$id");
  final response = await http.get(
    myUrl,
    headers: {
      'Accept': 'application/json',
      'Charset': 'utf-8',
    },
  );
  var body = jsonDecode(response.body);
  ChatUser user = ChatUser.fromJson(body);
  return user;
}
