import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

import '../models/message.dart';
import '../models/user.dart';

class ChatModel extends ChangeNotifier {
  late User currentUser;
  List<User> friendList = <User>[];
  List<Message> messages = <Message>[];
  late SocketIO socketIO;

  void init() {
    // currentUser = users[0];
    // friendList =
    //     users.where((user) => user.id != currentUser.id).toList();

    socketIO = SocketIOManager().createSocketIO(
        'https://connectus15-backend.herokuapp.com', '/',
        query: 'chatID=${currentUser.id}');
    socketIO.init();

    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      messages.add(
        Message(
          text: data['content'],
          senderID: data['senderChatID'],
          receiverID: data['receiverChatID'],
          timeStamp: data['timeStamp'],
        ),
      );
      notifyListeners();
    });

    socketIO.connect();
  }

  void sendMessage(String text, String receiverChatID) {
    messages.add(Message(
        text: text,
        senderID: currentUser.id!,
        receiverID: receiverChatID,
        timeStamp: DateTime.now().toIso8601String()));
    socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverChatID': receiverChatID,
        'senderChatID': currentUser.id,
        'content': text,
      }),
    );
    notifyListeners();
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
        .toList();
  }
}
