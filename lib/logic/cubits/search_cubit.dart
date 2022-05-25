import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/data/models/post_model.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/logic/states/search_states.dart';
import 'package:social_app/shared/app_constant.dart';

enum SearchType { Post, People }

class SearchCubits extends Cubit<SearchStates> {
  SearchCubits() : super(SearchInitialState());

  static SearchCubits get(BuildContext context) => BlocProvider.of(context);
  late UserModel _userModel;
  List<UserModel> userModelList = [];

  late PostModel _postModel;
  List<PostModel> postModelList = [];
  Future<void> searchPeaople(String username) async {
    emit(SearchPeopleLoadingState());
    try {
      userModelList = [];
      final _data = await AppConstant.firestore
          .collection(AppConstant.USER_COLLECTION)
          .where('username', isGreaterThanOrEqualTo: username)
          .get();
      final _docs = _data.docs;
      for (var element in _docs) {
        _userModel = UserModel.fromSnapshot(element);
        userModelList.add(_userModel);
      }
      emit(SearchPeopleSuccessState());
    } catch (e) {
      log(e.toString());
      emit(SearchPeopleErrorState());
    }
  }

  searchPost(String postText) async {
    emit(SearchPostLoadingState());
    try {
      postModelList = [];
      final data = await AppConstant.firestore
          .collection(AppConstant.POST_COLLECTION)
          .get();

      final data1 = data.docs;

      for (int i = 0; i < data1.length; i++) {
        final data2 = await AppConstant.firestore
            .collection(AppConstant.POST_COLLECTION)
            .doc(data1[i].id)
            .collection(AppConstant.USER_POST_COLLECTION)
            .where('postText', isGreaterThanOrEqualTo: 'postText')
            .get();
        final docs = data2.docs;
        for (int k = 0; k < docs.length; k++) {
          _postModel = PostModel.fromSnapshot(docs[k]);
          postModelList.add(_postModel);
          // likes.addAll(_postModel.likes!);
          // likeCountMap.addAll({_postModel.id!: _postModel.likeCount!});

          // print("ttt $likeCountMap");
          // print("sss ${likes}");
        }
      }

      emit(SearchPostSuccessState());
    } catch (e) {
      log(e.toString());
      emit(SearchPostErrorState());
    }
  }

  SearchType searchType = SearchType.People;
  getSearchType(int index) {
    if (index == 0) {
      searchType = SearchType.People;
      emit(ChangeSearchType());
      return;
    }

    searchType = SearchType.Post;
    emit(ChangeSearchType());
  }
}
