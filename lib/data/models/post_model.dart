import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postText;
  String? postImage;
  String? username;
  String? userImage;
  Timestamp? dateTime;
  String? id;
  Map<String, dynamic>? likes;
  String? ownerId;
  int? likeCount = 0;

  PostModel({
    this.postImage,
    this.postText,
    this.userImage,
    this.username,
    this.dateTime,
    this.id,
    this.likes,
    this.ownerId,
    this.likeCount,
  });

  factory PostModel.fromSnapshot(DocumentSnapshot doc) {
    return PostModel(
      postImage: doc["postImage"],
      postText: doc["postText"],
      username: doc["username"],
      userImage: doc["userImage"],
      dateTime: doc["dateTime"],
      id: doc["id"],
      likes: doc["likes"],
      ownerId: doc["ownerId"],
      likeCount: doc["likeCount"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "postImage": postImage,
      "postText": postText,
      "username": username,
      "userImage": userImage,
      "id": id,
      "dateTime": Timestamp.fromDate(DateTime.now()),
      "likes": likes ??
          {
            "$id": {},
          },
      "ownerId": ownerId,
      "likeCount": likeCount ?? 0,
    };
  }
}
