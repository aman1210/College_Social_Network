// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.intro,
    this.about,
    this.dob,
    this.location,
    this.socialLinks,
    this.profileImage,
  });

  String? id;
  String? name;
  String? email;
  String? intro;
  String? about;
  String? dob;
  String? location;
  List<dynamic>? socialLinks;
  String? profileImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        intro: json["intro"],
        about: json["about"],
        dob: json["dob"],
        location: json["location"],
        socialLinks: json["social_links"] == null
            ? null
            : List<dynamic>.from(json["social_links"].map((x) => x)),
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "intro": intro,
        "about": about,
        "dob": dob,
        "location": location,
        "social_links": socialLinks == null
            ? null
            : List<dynamic>.from(socialLinks!.map((x) => x)),
        "profile_image": profileImage,
      };
}
