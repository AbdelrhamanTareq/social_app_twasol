import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final _defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/social-app-3046f.appspot.com/o/profile-img.png?alt=media&token=18eb7d01-01c5-46e3-97a0-eec89c0d3627";
  final _dafaultCover =
      "https://firebasestorage.googleapis.com/v0/b/social-app-3046f.appspot.com/o/cover.jpg?alt=media&token=2f0379d8-df4f-4408-9850-31b2830726f4";
  String? username;
  String? email;
  String? imageUrl;
  String? coverImageUrl;
  String? bio;
  String? birthDate;
  String? uid;
  List<Friends>? friends = [];

  UserModel({
    required this.bio,
    required this.email,
    required this.imageUrl,
    required this.username,
    required this.birthDate,
    this.uid,
    this.friends,
    this.coverImageUrl,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    username = json!["username"];
    email = json["email"];
    bio = json["bio"];
    birthDate = json["birthDate"];
    imageUrl = json["imageUrl"];
    uid = json["uid"];
    // friends = Friends.fromJson(json["friends"]);
    // if (json["friends"] != null) {
    //   json["friends"].forEach((elment) {
    //     friends!.add(Friends.fromJson(elment));
    //   });
    // }
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
      username: doc["username"] ?? "",
      email: doc["email"] ?? "",
      uid: doc["uid"] ?? "",
      imageUrl: doc["imageUrl"] ?? "",
      bio: doc["bio"] ?? "",
      birthDate: doc["birthDate"] ?? "",
      coverImageUrl: doc["coverImageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username ?? "",
      "email": email ?? "",
      "bio": bio ?? "",
      "birthDate": birthDate ?? "",
      "imageUrl": imageUrl ?? _defaultImage,
      "coverImageUrl": coverImageUrl ?? _dafaultCover,
      "uid": uid ?? "",
    };
  }
}

class Friends {
  String? friendId;
  Friends(this.friendId);

  Friends.fromJson(Map<String, dynamic> json) {
    friendId = json["friendId"];
  }
}
