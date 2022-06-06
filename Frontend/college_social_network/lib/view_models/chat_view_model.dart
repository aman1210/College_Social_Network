import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/user.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatModel extends ChangeNotifier {
  String? currentUserId;
  List<User> friendList = <User>[];
  List<Message> messages = <Message>[];
  late IO.Socket socket;

  void init(String userId) {
    socket =
        IO.io('https://connectus15-backend.herokuapp.com/', <String, dynamic>{
      "transport": ['websocket'],
      "upgrade": false,
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) => print("connected"));
    socket.onConnectError((data) => print(data));
    print("helo");
  }
  // late SocketIO socketIO;

  // void init(String userId) {
  //   currentUserId = userId;
  //   // friendList =
  //   //     users.where((user) => user.id != currentUser.id).toList();

  //   socketIO = SocketIOManager().createSocketIO(
  //       'https://connectus15-backend.herokuapp.com', '/',
  //       query: 'chatID=$currentUserId');
  //   socketIO.init();

  //   socketIO.subscribe('receive_message', (jsonData) {
  //     Map<String, dynamic> data = json.decode(jsonData);
  //     messages.add(
  //       Message(
  //         text: data['content'],
  //         senderID: data['senderChatID'],
  //         receiverID: data['receiverChatID'],
  //         timeStamp: data['timeStamp'],
  //       ),
  //     );
  //     notifyListeners();
  //   });

  //   socketIO.connect();
  // }

  // void sendMessage(String text, String receiverChatID) {
  //   messages.add(Message(
  //       text: text,
  //       senderID: currentUserId!,
  //       receiverID: receiverChatID,
  //       timeStamp: DateTime.now().toIso8601String()));
  //   socketIO.sendMessage(
  //     'send_message',
  //     json.encode({
  //       'receiverChatID': receiverChatID,
  //       'senderChatID': currentUserId,
  //       'content': text,
  //     }),
  //   );
  //   notifyListeners();
  // }

  // List<Message> getMessagesForChatID(String chatID) {
  //   return messages
  //       .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
  //       .toList();
  // }
}
