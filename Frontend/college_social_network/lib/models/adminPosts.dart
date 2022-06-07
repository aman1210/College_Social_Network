// To parse this JSON data, do
//
//     final adminPosts = adminPostsFromJson(jsonString);

import 'dart:convert';

AdminPosts adminPostsFromJson(String str) =>
    AdminPosts.fromJson(json.decode(str));

String adminPostsToJson(AdminPosts data) => json.encode(data.toJson());

class AdminPosts {
  AdminPosts({
    required this.id,
    this.text,
    this.images,
    required this.timeStamp,
    required this.userName,
  });

  String id;
  String? text;
  List<String>? images;
  DateTime timeStamp;
  String userName;

  factory AdminPosts.fromJson(Map<String, dynamic> json) => AdminPosts(
        id: json["_id"],
        text: json["text"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        timeStamp: DateTime.parse(json["timeStamp"]),
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "images":
            images == null ? null : List<dynamic>.from(images!.map((x) => x)),
        "timeStamp": timeStamp == null ? null : timeStamp.toIso8601String(),
        "userName": userName,
      };
}
