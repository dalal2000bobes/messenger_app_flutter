import 'package:flutter/cupertino.dart';

class ChatMessage {
  int? id;
  int? destination;
  String? content;
  String? state;
  int? AccountId;
  String? createdAt;
  String? updatedAt;

  ChatMessage(
      {this.id,
      this.destination,
      this.content,
      this.state,
      this.AccountId,
      this.createdAt,
      this.updatedAt});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destination = json['destination'];
    content = json['content'];
    state = json['state'];
    AccountId = json['AccountId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['destination'] = this.destination;
    data['content'] = this.content;
    data['state'] = this.state;
    data['AccountId'] = this.AccountId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}