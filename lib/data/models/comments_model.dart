import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  late final String id;
  late final String comment;
  late final String commentOwnerId;
  late final String commentOwnerImage;
  late final String commentOwnerUsername;
  // late final String commentsCount;
  late final Timestamp commentTime;

  CommentsModel({
    required this.id,
    required this.comment,
    required this.commentOwnerId,
    required this.commentOwnerImage,
    // required this.commentsCount,
    required this.commentTime,
    required this.commentOwnerUsername,
  });

  factory CommentsModel.fromSnapshot(DocumentSnapshot doc) {
    return CommentsModel(
      id: doc["id"],
      comment: doc["comment"],
      commentOwnerId: doc["commentOwnerId"],
      commentOwnerImage: doc["commentOwnerImage"],
      // commentsCount: doc["commentsCount"],
      commentTime: doc["commentTime"],
      commentOwnerUsername: doc["commentOwnerUsername"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "comment": comment,
      "commentOwnerId": commentOwnerId,
      "commentOwnerImage": commentOwnerImage,
      // "commentsCount": commentsCount,
      "dateTime": Timestamp.fromDate(DateTime.now()),
      "commentTime": commentTime,
      "commentOwnerUsername": commentOwnerUsername,
    };
  }
}
