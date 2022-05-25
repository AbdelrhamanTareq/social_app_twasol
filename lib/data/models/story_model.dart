import 'package:cloud_firestore/cloud_firestore.dart';

// class StoryModel {
//   late final Timestamp dateTime;
//   late final String id;
//   late final String ownerId;
//   // late final List<UserStory> userStories;
//   late final List<dynamic> userStories;

//   StoryModel({
//     required this.dateTime,
//     required this.id,
//     required this.ownerId,
//     required this.userStories,
//   });

//   factory StoryModel.fromSnapshot(DocumentSnapshot doc) {
//     return StoryModel(
//       id: doc['id'],
//       dateTime: doc['dateTime'],
//       ownerId: doc['ownerId'],
//       // userStories: List<UserStory>.from(doc['userStories']),
//       userStories: doc['userStories'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "dateTime": Timestamp.fromDate(DateTime.now()),
//       "ownerId": ownerId,
//       "userStories": userStories,
//     };
//   }
// }

// class UserStory {
//   late final String id;
//   late final bool hasMedia;
//   late final String image;
//   String? text;
//   String? caption;

//   UserStory({
//     required this.id,
//     required this.hasMedia,
//     required this.image,
//     this.text,
//     this.caption,
//   });

//   factory UserStory.fromSnapshot(DocumentSnapshot doc) {
//     return UserStory(
//       id: doc['id'],
//       hasMedia: doc['hasMedia'],
//       image: doc['image'],
//       text: doc['text'],
//       caption: doc['caption'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "hasMedia": hasMedia,
//       "image": image,
//       "caption": caption,
//       "text": text,
//     };
//   }
// }

class StoryModel {
  Timestamp? dateTime;
  late final String id;
  late final String ownerId;
  late bool hasMedia;
  String? text;
  String? image;
  String? caption;

  StoryModel({
    this.dateTime,
    required this.id,
    required this.ownerId,
    this.hasMedia = false,
    this.caption,
    this.image,
    this.text,
  });

  factory StoryModel.fromSnapshot(DocumentSnapshot doc) {
    return StoryModel(
      id: doc['id'],
      dateTime: doc['dateTime'],
      ownerId: doc['ownerId'],
      hasMedia: doc['hasMedia'],
      caption: doc['caption'],
      text: doc['text'],
      image: doc['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dateTime": Timestamp.fromDate(DateTime.now()),
      "ownerId": ownerId,
      "hasMedia": (image != null) ? true : false,
      "caption": text ?? "",
      "text": text ?? "",
      "image": image ?? "",
    };
  }
}
