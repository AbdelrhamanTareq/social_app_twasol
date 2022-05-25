import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/data/models/notification_model.dart';
import 'package:social_app/data/models/user_model.dart';

import 'package:social_app/logic/states/notification_states.dart';
import 'package:social_app/shared/app_constant.dart';

const String NOTIFICATION_COLLECTION = "notification";
const String USER_NOTIFICATION_COLLECTION = "userNotification";

class NotificationCubit extends Cubit<NotifiactionStates> {
  NotificationCubit() : super(GetNotificationLoadingState());

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> notificationsList = [];
  List<UserModel> userList = [];
  // late UserModel userData1;

  final _uniqeId = AppConstant.uuid.v4();

  Future getUserNotification() async {
    emit(GetNotificationLoadingState());
    try {
      // notificationsList = [];

      if (notificationsList.isEmpty) {
        _firestore
            .collection(NOTIFICATION_COLLECTION)
            .doc(AppConstant.userId)
            .collection(USER_NOTIFICATION_COLLECTION)
            .orderBy('dateTime', descending: true)
            .snapshots()
            .listen((event) {
          notificationsList = [];
          for (var element in event.docs) {
            //  element.data()['id']
            log("data ====$element ");
            log("data ====${element.data()["notId"]} ");

            notificationsList.add(NotificationModel.fromSnapshot(element));
            // final userModel = getNotificationData(element.data()['notId']);
            Future userData = getNotificationData(element.data()['notId'])
                .then((value) => userList.add(value!));
            // // UserModel.fromSnapshot(userModel);
            // userList.add(userData!);
            emit(GetNotificationSuccesState());
          }
        });
      }

      emit(GetNotificationSuccesState());
    } catch (e) {
      emit(GetNotificationErrorState());
      log(e.toString());
    }
  }

  UserModel? userData;

  Future<UserModel?> getNotificationData(String id) async {
    final data =
        await _firestore.collection(AppConstant.USER_COLLECTION).doc(id).get();

    userData = UserModel.fromSnapshot(data);
    return userData;
  }

  Future<void> addNotification(
    NotifiactionType notType, {
    String? notData,
    String? notMedia,
  }) async {
    try {
      if (notType == NotifiactionType.like) {
        final NotificationModel _notificationModel = NotificationModel(
          id: _uniqeId,
          type: 'like',
          notId: AppConstant.userId,
          notMedia: notMedia,
        );
        final _data = AppConstant.firestore
            .collection(NOTIFICATION_COLLECTION)
            .doc(AppConstant.userId);
        await _data.set({'k': 1});
        _data
            .collection(USER_NOTIFICATION_COLLECTION)
            .doc(_uniqeId)
            .set(_notificationModel.toJson());
        emit(AddLikeNotificationState());
      } else if (notType == NotifiactionType.comment) {
        final NotificationModel _notificationModel = NotificationModel(
          id: _uniqeId,
          type: 'comment',
          notData: notData,
          notId: AppConstant.userId,
          notMedia: notMedia,
        );
        final _data = AppConstant.firestore
            .collection(NOTIFICATION_COLLECTION)
            .doc(AppConstant.userId);
        await _data.set({'k': 1});
        _data
            .collection(USER_NOTIFICATION_COLLECTION)
            .doc(_uniqeId)
            .set(_notificationModel.toJson());
        emit(AddCommentNotificationState());
      } else {
        final NotificationModel _notificationModel = NotificationModel(
          id: _uniqeId,
          type: 'follow',
          notId: AppConstant.userId,
          // notData: notData,
        );
        final _data = AppConstant.firestore
            .collection(NOTIFICATION_COLLECTION)
            .doc(AppConstant.userId);
        await _data.set({'k': 1});
        _data
            .collection(USER_NOTIFICATION_COLLECTION)
            .doc(_uniqeId)
            .set(_notificationModel.toJson());
        emit(AddFollowNotificationState());
      }
    } catch (e) {
      emit(AddNotificationErorrState());
    }
  }
}
