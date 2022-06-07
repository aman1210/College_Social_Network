// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    this.id,
    this.type,
    this.postId,
    this.senderId,
    this.timeStamp,
  });

  String? id;
  String? type;
  PostId? postId;
  SenderId? senderId;
  DateTime? timeStamp;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["_id"] == null ? null : json["_id"],
        type: json["type"] == null ? null : json["type"],
        postId: json["postId"] == null ? null : PostId.fromJson(json["postId"]),
        senderId: json["senderId"] == null
            ? null
            : SenderId.fromJson(json["senderId"]),
        timeStamp: json["timeStamp"] == null
            ? null
            : DateTime.parse(json["timeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "type": type == null ? null : type,
        "postId": postId == null ? null : postId!.toJson(),
        "senderId": senderId == null ? null : senderId!.toJson(),
        "timeStamp": timeStamp == null ? null : timeStamp!.toIso8601String(),
      };
}

class PostId {
  PostId({
    this.images,
  });

  List<dynamic>? images;

  factory PostId.fromJson(Map<String, dynamic> json) => PostId(
        images: json["images"] == null
            ? null
            : List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "images":
            images == null ? null : List<dynamic>.from(images!.map((x) => x)),
      };
}

class SenderId {
  SenderId({
    this.name,
  });

  String? name;

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
      };
}
