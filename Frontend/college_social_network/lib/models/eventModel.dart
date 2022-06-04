// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  Event({
    required this.id,
    required this.title,
    required this.detail,
    required this.venue,
    this.time,
  });

  String id;
  String title;
  String detail;
  String venue;
  DateTime? time;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        title: json["title"],
        detail: json["detail"],
        venue: json["venue"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "detail": detail,
        "venue": venue,
        "time": time == null ? null : time?.toIso8601String(),
      };
}
