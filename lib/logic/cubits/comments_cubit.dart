import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/data/models/comments_model.dart';
import 'package:social_app/logic/states/comments_states.dart';

const String COMMENT_COLLECTION = 'comments';

class CommentsCubits extends Cubit<CommentsStates> {
  CommentsCubits() : super(CommentsInitialState());

  static CommentsCubits get(BuildContext context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CommentsModel? commentsModel;
  List<CommentsModel>? commentsModelList = [];

  Future<List<CommentsModel>> getPostComments(String postId) async {
    commentsModelList = [];
    emit(GetCommentsLoadingState());
    try {
      final data = await _firestore
          .collection(COMMENT_COLLECTION)
          .doc(postId)
          .collection("postComments")
          .orderBy('dateTime', descending: true)
          .get();
      final docs = data.docs;
      // docs.forEach((element) {
      for (var element in docs) {
        commentsModel = CommentsModel.fromSnapshot(element);
        commentsModelList!.add(commentsModel!);
      }
      emit(GetCommentsSuccesState());
      return commentsModelList!;
    } catch (e) {
      log(e.toString());
      emit(GetCommentsErrorState());
    }
    return commentsModelList!;
  }

  void addComment({
    required String postId,
    required String comment,
    required String commentOwnerId,
    required String commentOwnerImage,
    required String commentOwnerUsername,
    // required String id,
  }) async {
    emit(AddCommentsLoadingState());
    final CommentsModel commentsModel = CommentsModel(
      comment: comment,
      commentOwnerId: commentOwnerId,
      commentOwnerImage: commentOwnerImage,
      commentOwnerUsername: commentOwnerUsername,
      commentTime: Timestamp.fromDate(DateTime.now()),
      id: DateTime.now().toString(),
    );
    try {
      await _firestore
          .collection(COMMENT_COLLECTION)
          .doc(postId)
          .collection("postComments")
          .add(commentsModel.toJson());
      getPostComments(postId);
      emit(AddCommentsSuccesState());
    } catch (e) {
      log(e.toString());
      emit(AddCommentsErrorState());
    }
  }
}
