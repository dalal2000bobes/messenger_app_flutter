import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Controller/LoginController.dart';
import 'homePage.dart';
import 'signupPage.dart';

class LoginPage extends StatelessWidget {
  LoginController loginController = Get.put(LoginController(),permanent: true);

  static const routeName = '/LoginPage11';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigoAccent, Colors.deepPurple],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                    height: 80,
                  ),
                  Text(
                    "REGISTER CHAT",
                    style: TextStyle(
                        // color: Colors.purple.shade800,
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40.0),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: loginController.inputTextPhone,
                    onChanged: (text) {
                      loginController.UserPhoneNumber = text;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16.0),
                      prefixIcon: Container(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(10.0))),
                          child: Icon(
                            Icons.phone,
                            color: Colors.purple,
                          )),
                      hintText: "Enter your Phone Number",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: loginController.inputTextPassword,
                    onChanged: (text) {
                      loginController.UserPassword = text;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16.0),
                      prefixIcon: Container(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(10.0))),
                          child: Icon(
                            Icons.lock,
                            color: Colors.purple,
                          )),
                      hintText: "Enter your Password",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                      child: Text("Login".toUpperCase()),
                      onPressed: () async{
                        if (!loginController.UserPhoneNumber.isEmpty &&
                            !loginController.UserPassword.isEmpty) {
                          print(loginController.UserPhoneNumber);
                          print(loginController.UserPassword);
                          await loginController.login();
                          if (loginController.done) {
                            loginController.done = false;
                            Get.to(HomePage());
                          }
                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return HomePage();
                        // }));
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.to(SignupPage());
                        },
                        child: Text('Creat Accont'),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Text('Forgot Password'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
