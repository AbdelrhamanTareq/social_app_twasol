import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/logic/states/follow_states.dart';
import 'package:social_app/shared/app_constant.dart';

class FollowCubits extends Cubit<FollowStates> {
  FollowCubits() : super(FollowInitialState());

  static FollowCubits get(BuildContext context) => BlocProvider.of(context);

  // List<String> followers = [];
  // List<String> followeing = [];
  // // List<String> userFollowing = [];

  Map<String, bool> userFollowing = {};
  int followerCount = 0;
  int followingCount = 0;

  getPostOwnerFollowCount(ownerId) async {
    try {
      final _data = await AppConstant.firestore
          .collection(AppConstant.FOLLOWING_COLLECTION)
          .doc(ownerId)
          .collection(AppConstant.USER_FOLLOWERING)
          .get();
      final _docs = _data.docs;

      followingCount = _docs.length;
      final _data1 = await AppConstant.firestore
          .collection(AppConstant.FOLLOWR_COLLECTION)
          .doc(ownerId)
          .collection(AppConstant.USER_FOLLOWERS)
          .get();
      final _docs1 = _data1.docs;
      followerCount = _docs1.length;
      emit(GetFollowCountSuccesState());
    } catch (e) {
      emit(GetFollowCountErrorState());
      log(e.toString());
    }
  }

  getUserFollowing() async {
    final _data = await AppConstant.firestore
        .collection(AppConstant.FOLLOWING_COLLECTION)
        .doc(AppConstant.userId)
        .collection(AppConstant.USER_FOLLOWERING)
        .get();
    final _docs = _data.docs;
    for (var doc in _docs) {
      userFollowing.addAll({doc.id: true});
    }
    log("userFollowing ==== $userFollowing");
  }

  // getAllFollowes() async {
  //   try {
  //     final _data = await AppConstant.firestore
  //         .collection(AppConstant.FOLLOWR_COLLECTION)
  //         .get();
  //     final _data1 = _data.docs;
  //     for (int i = 0; i < _data1.length; i++) {
  //       final _data2 = await AppConstant.firestore
  //           .collection(AppConstant.FOLLOWR_COLLECTION)
  //           .doc(_data1[i].id)
  //           .collection(AppConstant.USER_FOLLOWERS)
  //           .get();
  //       final _docs = _data2.docs;
  //       for (int k = 0; k < _docs.length; k++) {
  //         followers.add(_docs[k].id);
  //       }
  //     }
  //     print("followers ==== $followers");

  //     final _data3 = await AppConstant.firestore
  //         .collection(AppConstant.FOLLOWR_COLLECTION)
  //         .get();
  //     final _data4 = _data3.docs;
  //     for (int i = 0; i < _data4.length; i++) {
  //       final _data5 = await AppConstant.firestore
  //           .collection(AppConstant.FOLLOWR_COLLECTION)
  //           .doc(_data4[i].id)
  //           .collection(AppConstant.USER_FOLLOWERS)
  //           .get();
  //       final _docs = _data5.docs;
  //       for (int k = 0; k < _docs.length; k++) {
  //         followeing.add(_docs[k].id);
  //       }
  //     }
  //     print("followeing ==== $followeing");

  //     // await AppConstant.firestore
  //     //     .collection(AppConstant.FOLLOWR_COLLECTION)
  //     //     .doc(profileId)
  //     //     .collection(AppConstant.USER_FOLLOWERS)
  //     //     .doc(AppConstant.userId)
  //     //     .set({});
  //     // await AppConstant.firestore
  //     //     .collection(AppConstant.FOLLOWING_COLLECTION)
  //     //     .doc(AppConstant.userId)
  //     //     .collection(AppConstant.USER_FOLLOWERING)
  //     //     .doc(profileId)
  //     //     .set({});
  //     // emit(FollowUserSuccesState());
  //   } catch (e) {
  //     emit(FollowUserErrorState());
  //     print(e.toString());
  //   }
  // }

  Future<void> followUser(String profileId) async {
    bool _isFollowed = userFollowing[profileId] ?? false;

    try {
      if (!_isFollowed) {
        userFollowing[profileId] = !_isFollowed;
        emit(FollowUserChangeButtuonState());
        final _data = AppConstant.firestore
            .collection(AppConstant.FOLLOWR_COLLECTION)
            .doc(profileId);
        await _data.set({"k": 1});
        await _data
            .collection(AppConstant.USER_FOLLOWERS)
            .doc(AppConstant.userId)
            .set({});
        final _data1 = AppConstant.firestore
            .collection(AppConstant.FOLLOWING_COLLECTION)
            .doc(AppConstant.userId);
        await _data1.set({"k": 1});
        await _data1
            .collection(AppConstant.USER_FOLLOWERING)
            .doc(profileId)
            .set({});
        emit(FollowUserSuccesState());
      } else {
        userFollowing[profileId] = !_isFollowed;
        emit(FollowUserChangeButtuonState());
        await AppConstant.firestore
            .collection(AppConstant.FOLLOWR_COLLECTION)
            .doc(profileId)
            .collection(AppConstant.USER_FOLLOWERS)
            .doc(AppConstant.userId)
            .delete();
        await AppConstant.firestore
            .collection(AppConstant.FOLLOWING_COLLECTION)
            .doc(AppConstant.userId)
            .collection(AppConstant.USER_FOLLOWERING)
            .doc(profileId)
            .delete();
        emit(UnFollowUserSuccesState());
      }
    } catch (e) {
      userFollowing[profileId] = !_isFollowed;
      // emit(FollowUserChangeButtuonState());
      emit(FollowUserErrorState());
      log(e.toString());
    }
  }
}
