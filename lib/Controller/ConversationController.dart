import 'dart:convert';
import 'dart:math';
import 'package:crypton/crypton.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Model/chatMessageModel.dart';
import '../Model/chatUsersModel.dart';
import '../Repository/ConversationRepository.dart' as repo;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ConversationController extends GetxController {
  int destination = 0;

  // ConversationController({required this.destination});

  TextEditingController _inputTextMessage = new TextEditingController();
  TextEditingController get inputTextMessage => _inputTextMessage;

  String currentTypingMessage = "";
  List<ChatMessage> messages = [];
  late ChatUser current;
  int sender = 0;

  late IO.Socket socket;

  String destinationPublicKey = "";
  String sicritKey = "AES key for encfor message @2023";

  String getRandomString(int length) {
    const characters =
        '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  Encrypted? encryptAES(String plainText) {
    Encrypted? encrypted;
    final key = encrypt.Key.fromUtf8(sicritKey);
    // final iv = encrypt.IV.fromLength(16);
    final iv = encrypt.IV.fromUtf8("mHGFxENnZLbienLyANoi.e");
    final encrypter = encrypt.Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    print(
        "dddddddddddddddddddddddddddddddddddddddddddddddd${encrypted.base64}");
    decryptAES(encrypted.base64);
    // encrypted!.base64
    return encrypted;
  }

  String encryptRSA(String plainText) {
    RSAPublicKey rsaPublicKey = RSAPublicKey.fromString(destinationPublicKey);
    String result = rsaPublicKey.encrypt(plainText);
    print("999999999999999999999999999999999999999999$result");
    return result;
  }

  String decryptAES(String encrypted) {
    final key = encrypt.Key.fromUtf8(sicritKey);
    final iv = encrypt.IV.fromUtf8("mHGFxENnZLbienLyANoi.e");
    final encrypter = encrypt.Encrypter(AES(key));
    var decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
    print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr$decrypted");
    return decrypted;
  }

  Future<String> decryptRSA(String encryptText) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var privateKey = preferences.getString('privateKey');
    RSAKeyParser keyParser = RSAKeyParser();
    RSAPrivateKey rsaPrivateKey =
        RSAPrivateKey.fromString(privateKey as String);
    print(
        "55555555555555555555555555555555555555555555555555555${rsaPrivateKey.toString()}");
    String result = rsaPrivateKey.decrypt(encryptText);
    print("777777777777777777777777777777777777777777777777777777777$result");
    return result;
  }

  @override
  void onInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user');
    current = ChatUser.fromJson(jsonDecode(user.toString()));
    sender = current.id as int;
    await getMessage();
    connectToSocketQ1();
    // connectToSocketQ2();
    // connectToSocketQ3();
    update();
    super.onInit();
  }

  Future getMessage() async {
    if ((destination != 0) && (sender != 0)) {
      messages = await repo.getMessage(sender, destination);
      messages = messages.reversed.toList();
      update();
    }
  }

  Future<void> connectToSocketQ1() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user');
    // ChatUser current = ChatUser.fromJson(jsonDecode(user.toString()));
    int srcId = jsonDecode(user.toString())["id"];
    // IO.Socket socket;
    socket = IO.io("http://192.168.1.9:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("sining", srcId);
    socket.onConnect((data) {
      print("Connected ... ");
      socket.on("message", (msg) async {
        print(
            "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm $msg");
        setMessage(msg);
        update();
      });
    });
  }

  Future<void> connectToSocketQ2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user');
    // ChatUser current = ChatUser.fromJson(jsonDecode(user.toString()));
    int srcId = jsonDecode(user.toString())["id"];
    // IO.Socket socket;
    socket = IO.io("http://192.168.1.9:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("sining", srcId);
    socket.onConnect((data) {
      print("Connected ... ");
      socket.on("message", (msg) async {
        // msg["content"] = decryptAES(msg["content"].toString() as Encrypted);
        print(
            "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm $msg");
        setMessage(msg);
        update();
      });
    });
  }

  Future<void> connectToSocketQ3() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user');
    // ChatUser current = ChatUser.fromJson(jsonDecode(user.toString()));
    int srcId = jsonDecode(user.toString())["id"];
    // IO.Socket socket;
    socket = IO.io("http://192.168.1.9:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("sining", srcId);
    socket.emit("getPublicKey", {"id": destination, "sender": sender});
    socket.on("publicKey", (desKey) {
      destinationPublicKey = desKey;
      print(destinationPublicKey);
    });
    if (sicritKey == "AES key for encfor message @2023") {
      sicritKey = getRandomString(32);
      print(
          "dddddddddddddddddddddddd000000000000000000000000000000000${encryptRSA(sicritKey)}");
      socket.emit("sicrit", {"key": encryptRSA(sicritKey), "id": destination});
    }
    socket.on("rcvScrit", (data) async {
      sicritKey = await decryptRSA(data);
      print(
          "ddddddddddddddddddddd1111111111111111111111111111111111$sicritKey");
    });
    socket.onConnect((data) {
      print("Connected ... ");
      socket.on("message", (msg) async {
        // msg["content"] = decryptAES(msg["content"].toString() as Encrypted);
        print(
            "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm $msg");
        // setMessage(msg);
        update();
      });
    });
  }

  Future<void> sendMessageQ1() async {
    var message = {
      "destination": destination as int,
      "content": currentTypingMessage,
      "state": "send",
      "AccountId": sender as int
    };
    var complete = {
      "destination": destination as int,
      "content": currentTypingMessage,
      "state": "send",
      "AccountId": sender as int,
      "id": 0,
      "createdAt": "",
      "updatedAt": ""
    };
    setMessage(complete);
    socket.emit("message", message);
  }

  Future<void> sendMessageQ2() async {
    var message = {
      "destination": destination as int,
      "content": encryptAES(currentTypingMessage)!.base64,
      "state": "send",
      "AccountId": sender as int
    };
    var complete = {
      "destination": destination as int,
      "content": encryptAES(currentTypingMessage)!.base64,
      "state": "send",
      "AccountId": sender as int,
      "id": 0,
      "createdAt": "",
      "updatedAt": ""
    };
    setMessage(complete);
    socket.emit("message", message);
  }

  Future<void> sendMessageQ3() async {
    var message = {
      "destination": destination as int,
      "content": encryptRSA(currentTypingMessage),
      "state": "send",
      "AccountId": sender as int
    };
    var complete = {
      "destination": destination as int,
      "content": encryptRSA(currentTypingMessage),
      "state": "send",
      "AccountId": sender as int,
      "id": 0,
      "createdAt": "",
      "updatedAt": ""
    };
    setMessage(complete);
    socket.emit("message", message);
  }

  Future<void> setMessage(var newMessage) async {
    ChatMessage chatMessage = ChatMessage.fromJson(newMessage);
    messages.add(chatMessage);
    print("sssssssssssssssssssssssssssssssssssssssss$newMessage");
    update();
  }
}
