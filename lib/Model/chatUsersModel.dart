import 'package:flutter/cupertino.dart';

class ChatUser {
  int? id;
  String? name;
  String? phoneNumber;
  String? password;
  String? pubKey;
  String? state;
  String? createdAt;
  String? updatedAt;

  ChatUser(
      {this.id,
      this.name,
      this.phoneNumber,
      this.password,
      this.pubKey,
      this.state,
      this.createdAt,
      this.updatedAt});

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    pubKey = json['pubKey'];
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['pubKey'] = this.pubKey;
    data['state'] = this.state;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}