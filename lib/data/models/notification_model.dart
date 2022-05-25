import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  late final String id;
  late final String type;
  final Timestamp? dateTime;
  late final String notId;
  final String? notData;
  final String? notMedia;

  NotificationModel({
    required this.id,
    required this.type,
    this.dateTime,
    required this.notId,
    this.notData,
    this.notMedia,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot doc) {
    return NotificationModel(
      id: doc["id"],
      type: doc["type"],
      dateTime: doc["dateTime"],
      notId: doc["notId"],
      notData: doc["notData"],
      notMedia: doc["notMedia"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "dateTime": Timestamp.fromDate(DateTime.now()),
      "notId": notId,
      "notData": notData ?? "",
      "notMedia": notMedia ?? "",
    };
  }
}
