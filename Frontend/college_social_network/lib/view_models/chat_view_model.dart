import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

import '../models/message.dart';
import '../models/user.dart';

class ChatModel extends Model {
  List<User> users = [
    User(name: 'IronMan', chatID: '111'),
    User(name: 'Captain America', chatID: '222'),
    User(name: 'Antman', chatID: '333'),
    User(name: 'Hulk', chatID: '444'),
    User(name: 'Thor', chatID: '555'),
  ];

  late User currentUser;
  List<User> friendList = <User>[];
  List<Message> messages = <Message>[];
  late SocketIO socketIO;

  void init() {
    currentUser = users[0];
    friendList =
        users.where((user) => user.chatID != currentUser.chatID).toList();

    socketIO = SocketIOManager().createSocketIO(
        '<ENTER_YOUR_SERVER_URL_HERE>', '/',
        query: 'chatID=${currentUser.chatID}');
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
        senderID: currentUser.chatID,
        receiverID: receiverChatID,
        timeStamp: DateTime.now().toIso8601String()));
    socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverChatID': receiverChatID,
        'senderChatID': currentUser.chatID,
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
