// To parse this JSON data, do
//
//     final friendList = friendListFromJson(jsonString);

import 'dart:convert';

FriendList friendListFromJson(String str) =>
    FriendList.fromJson(json.decode(str));

String friendListToJson(FriendList data) => json.encode(data.toJson());

class FriendList {
  FriendList({
    this.friendList,
  });

  List<FriendListElement>? friendList;

  factory FriendList.fromJson(Map<String, dynamic> json) => FriendList(
        friendList: json["friendList"] == null
            ? null
            : List<FriendListElement>.from(
                json["friendList"].map((x) => FriendListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "friendList": friendList == null
            ? null
            : List<dynamic>.from(friendList!.map((x) => x.toJson())),
      };
}

class FriendListElement {
  FriendListElement({this.name, this.profileImage, this.id});

  String? name;
  String? profileImage;
  String? id;

  factory FriendListElement.fromJson(Map<String, dynamic> json) =>
      FriendListElement(
        name: json["name"],
        profileImage: json["profile_image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() =>
      {"name": name, "profile_image": profileImage, "id": id};
}
