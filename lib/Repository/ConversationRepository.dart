import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/chatMessageModel.dart';

Future<List<ChatMessage>> getMessage(int from, int to) async {
  var path = 'http://192.168.1.9:3000';
  var myUrl = Uri.parse("$path/message/receive?from=$from&to=$to");
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
    List<ChatMessage> sold = [];
    for (int i = 0; i < body.length; i++) {
      sold.add(new ChatMessage.fromJson(body[i]));
    }
    return sold;
  } else {
    List<ChatMessage> sold = [];
    return sold;
  }
}
