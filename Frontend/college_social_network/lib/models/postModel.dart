import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String PostToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    this.id,
    this.text,
    this.images,
    this.timeStamp,
    this.userName,
    this.likeCount,
    this.comments,
  });

  String? id;
  String? text;
  List<String>? images;
  String? timeStamp;
  String? userName;
  int? likeCount;
  List<dynamic>? comments;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        text: json["text"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        timeStamp: json["timeStamp"],
        userName: json["PostName"],
        likeCount: json["likeCount"],
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "images":
            images == null ? null : List<dynamic>.from(images!.map((x) => x)),
        "timeStamp": timeStamp,
        "userName": userName,
        "likeCount": likeCount,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x)),
      };
}
