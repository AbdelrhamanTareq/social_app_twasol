import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/data/models/post_model.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/logic/states/posts_states.dart';
import 'package:social_app/shared/app_constant.dart';

class PostsCubits extends Cubit<PostsStates> {
  PostsCubits() : super(PostsInitialState());

  static PostsCubits get(BuildContext context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Map<String, dynamic> likes = {};
  Map<String, int> likeCountMap = {};

  List<PostModel> postsModel = [];
  List<UserModel> usersModel = [];
  UserModel? userModel;
  late PostModel postModel;

  XFile? imageFile;

  Future<void> getPostData() async {
    postsModel = [];
    emit(GetPostsLoadingState());
    try {
      if (postsModel.isEmpty) {
        final _data =
            await _firestore.collection(AppConstant.POST_COLLECTION).get();

        final _data1 = _data.docs;

        for (int i = 0; i < _data1.length; i++) {
          final _data2 = await _firestore
              .collection(AppConstant.POST_COLLECTION)
              .doc(_data1[i].id)
              .collection(AppConstant.USER_POST_COLLECTION)
              .orderBy('dateTime', descending: true)
              .get();
          final _docs = _data2.docs;
          for (int k = 0; k < _docs.length; k++) {
            postModel = PostModel.fromSnapshot(_docs[k]);
            postsModel.add(postModel);
            likes.addAll(postModel.likes!);
            likeCountMap.addAll({postModel.id!: postModel.likeCount!});

            log("ttt $likeCountMap");
            log("sss $likes");
          }
        }

        emit(GetPostsSuccessState());
        // return postsModel;
      }
    } catch (e) {
      log(e.toString());
      emit(GetPostsErorrState());
    }
    // return postsModel;
  }

  Future<XFile?> getImage(context, {required ImageSource source}) async {
    try {
      final _pickedFile = await AppConstant.picker.pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 90,
      );
      if (_pickedFile != null) {
        imageFile = _pickedFile;
        Navigator.pop(context);
        emit(PickImageSuccesState());
        return imageFile;
      }
      emit(PickImageErrorState());
      return imageFile = null;
    } catch (e) {
      emit(PickImageErrorState());
      log(e.toString());
    }
  }

  Future<dynamic> uploadImage(
      {required String postId, XFile? imageFile}) async {
    if (imageFile != null) {
      final TaskSnapshot task = await _firebaseStorage
          .ref("post/$postId.jpg")
          .putFile(File(imageFile.path));
      final String downloadUrl = await task.ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }

  Future<void> uploadPost({
    required String postText,
    required String username,
    required String userImage,
    required String uid,
    required String ownerId,
  }) async {
    emit(AddPostsLoadingState());
    try {
      final _imageUrl = await uploadImage(
          imageFile: imageFile, postId: DateTime.now().toString());
      final String id = AppConstant.uuid.v4();
      final PostModel postModel = PostModel(
        postImage: _imageUrl ?? null,
        postText: postText,
        username: username,
        userImage: userImage,
        id: id,
        likes: {
          id: {},
        },
        ownerId: ownerId,
      );

      final _data = _firestore.collection(AppConstant.POST_COLLECTION).doc(uid);

      await _data.set({"k": 1});
      await _data
          .collection(AppConstant.USER_POST_COLLECTION)
          .doc(id)
          .set(postModel.toJson());

      imageFile = null;
      emit(AddPostsSuccessState());
    } catch (e) {
      log(e.toString());
      emit(AddPostsErrorState());
    }
  }

  addOrRemoveLike({
    required String ownerId,
    required String postId,
    required String userId,
  }) {
    log("likes $likes");
    bool _isLiked = likes[postId][userId] ?? false;
    log("_isLiked $_isLiked");
    int _likeCount = likeCountMap[postId] ?? 0;

    if (likes[postId][userId] == null) {
      likes[postId][userId] = false;
    }
    likes[postId][userId] = !likes[postId][userId]!;
    try {
      if (_isLiked) {
        // likeCount -= 1;
        likeCountMap[postId] = _likeCount - 1;
        _firestore
            .collection(AppConstant.POST_COLLECTION)
            .doc(ownerId)
            .collection(AppConstant.USER_POST_COLLECTION)
            .doc(postId)
            .update({
          // "likes.$userId": !_isLiked,

          "likes.$postId.$userId": !_isLiked,
          // "likes.x.z": "asdas",
          "likeCount": _likeCount - 1,
        });
        // likes[userId] = _isLiked;
        emit(RemoveLikeState());
      } else {
        likeCountMap[postId] = _likeCount + 1;
        _firestore
            .collection(AppConstant.POST_COLLECTION)
            .doc(ownerId)
            .collection(AppConstant.USER_POST_COLLECTION)
            .doc(postId)
            .update({
          // "likes.x.z": "asdas",
          "likes.$postId.$userId": !_isLiked,
          // "likes.$userId": !_isLiked,
          "likeCount": _likeCount + 1,
        });

        emit(AddLikeState());
      }
    } catch (e) {
      likes[userId] = !likes[userId]!;
      log(e.toString());
      emit(AddOrRemoveLikeErrorState());
    }
  }

  UserModel? ownerData;

  List<UserModel?> ownerDataList = [];
  Future<UserModel?> getPostOwnerData(String ownerid) async {
    emit(GetPostOwnerDataLoadingState());
    try {
      final _data = await _firestore
          .collection(AppConstant.USER_COLLECTION)
          .doc(ownerid)
          .get();
      ownerData = UserModel.fromSnapshot(_data);
      log("WWE ${ownerData?.coverImageUrl}");
      emit(GetPostOwnerDataSuccessState());
      return ownerData;
    } catch (e) {
      log(e.toString());
      emit(GetPostOwnerDataErrorState());
    }
    return ownerData;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostOwnerData1(
      String ownerid) async {
    emit(GetPostOwnerDataLoadingState());

    // try {
    final DocumentSnapshot<Map<String, dynamic>> data = await _firestore
        .collection(AppConstant.USER_COLLECTION)
        .doc(ownerid)
        .get();
    return data;
  }

  List<PostModel> postOwnerPosts = [];
  PostModel? postOwnerPost;
  int postOwnerPostsCount = 0;
  getPostOwnerPosts(String ownerid) async {
    postOwnerPosts = [];
    emit(GetPostOwnerPostsLoadingState());
    try {
      final _data = await _firestore
          .collection(AppConstant.POST_COLLECTION)
          .doc(ownerid)
          .collection(AppConstant.USER_POST_COLLECTION)
          .get();
      final _docs = _data.docs;
      postOwnerPostsCount = _docs.length;
      for (var element in _docs) {
        postOwnerPost = PostModel.fromSnapshot(element);
        postOwnerPosts.add(postOwnerPost!);
      }
      emit(GetPostOwnerPostsSuccessState());
    } catch (e) {
      log(e.toString());
      emit(GetPostOwnerPostsErrorState());
    }
  }

  getPostOwnerPostsCount(String ownerid) async {
    final data = await _firestore
        .collection(AppConstant.POST_COLLECTION)
        .doc(ownerid)
        .collection(AppConstant.USER_POST_COLLECTION)
        .get();
    final docs = data.docs;
    docs.length;
  }
}
