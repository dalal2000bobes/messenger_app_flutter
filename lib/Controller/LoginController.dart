import 'dart:convert';
import 'package:crypton/crypton.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Model/chatUsersModel.dart';
import '../Repository/LoginRepository.dart' as repo;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/api.dart' as crypto;

class LoginController extends GetxController {
  TextEditingController _inputTextName = new TextEditingController();
  TextEditingController get inputTextName => _inputTextName;

  TextEditingController _inputTextPhone = new TextEditingController();
  TextEditingController get inputTextPhone => _inputTextPhone;

  TextEditingController _inputTextPassword = new TextEditingController();
  TextEditingController get inputTextPassword => _inputTextPassword;

  String UserName = "";
  String UserPhoneNumber = "";
  String UserPassword = "";

  String messageError = "";

  bool done = false;

  String publicKey = "";
  String privateKey = "";

  @override
  void onInit() async {
    RSAKeypair rsaKeypair = RSAKeypair.fromRandom();
    publicKey = rsaKeypair.publicKey.toString();
    privateKey = rsaKeypair.privateKey.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('privateKey', json.encode(privateKey));
    update();
    super.onInit();
  }

  Future<void> connectToSocket() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user');
    // ChatUser current = ChatUser.fromJson(jsonDecode(user.toString()));
    int srcId = jsonDecode(user.toString())["id"];
    IO.Socket socket;
    socket = IO.io("http://192.168.1.9:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });
    socket.connect();
    socket.emit("sining", srcId);
    socket.onConnect((data) {
      print("Connected ... ");
    });
    // print(socket.connected);
  }

  Future login() async {
    int userId = 0;
    var value = await repo.getLogin(UserPhoneNumber, UserPassword);
    if (jsonDecode(value)["message"] == "phone number is not correct") {
      messageError = "phone number is not correct";
    } else if (jsonDecode(value)["message"] == "password is not correct") {
      messageError = "password is not correct";
    } else if (messageError == "") {
      userId = jsonDecode(value)["id"];
      done = true;
      ChatUser currentUser = await repo.getUserInfo(userId);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user', json.encode(currentUser.toJson()));
    }
    UserName = "";
    UserPhoneNumber = "";
    UserPassword = "";
    messageError = "";
    await connectToSocket();
    update();
  }

  Future goToSignUp() async {
    int userId = 0;
    var chatUser = {
      "name": UserName,
      "phoneNumber": UserPhoneNumber,
      "password": UserPassword,
      "pubKey": publicKey,
      "state": "online"
    };
    var value = await repo.signup(chatUser);
    if (jsonDecode(value)["message"] == "Account is already exist") {
      messageError = "Account is already exist";
    } else if (messageError == "") {
      userId = jsonDecode(value)["id"];
      done = true;
      ChatUser currentUser = await repo.getUserInfo(userId);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user', json.encode(currentUser.toJson()));
    }
    UserName = "";
    UserPhoneNumber = "";
    UserPassword = "";
    messageError = "";
    await connectToSocket();
    update();
  }

  void goToForgetPassword() {}
}


// import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences preferences = await SharedPreferences.getInstance();
// preferences.setString('user', json.encode(value.toJson()));
// preferences.setString('userToken', value.token);

// SharedPreferences preferences = await SharedPreferences.getInstance();
// var user = preferences.getString('user');

// home:(userss.id==null)||(userss.id.isEmpty) ?WelcomePage():PageMarket(userss),