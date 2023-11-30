import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Model/chatUsersModel.dart';
import 'View/homePage.dart';
import 'View/loginPage.dart';

bool isLogin = false;

Future<void> open() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var user = preferences.getString('user');
  if ((user != "") && (user != null)) {
    isLogin = true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: isLogin ? HomePage() : LoginPage(),
      // home: LoginPage(),
    );
  }
}
