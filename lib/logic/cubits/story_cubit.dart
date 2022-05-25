import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/data/models/story_model.dart';
import 'package:social_app/data/models/user_model.dart';

import 'package:social_app/logic/states/story_states.dart';
import 'package:social_app/shared/app_constant.dart';

const String STORY_COLLECTION = "stories";
const String USER_STORY_COLLECTION = "userStories";

class StoryCubit extends Cubit<StoryStates> {
  StoryCubit() : super(GetStoryLoadingState());

  static StoryCubit get(BuildContext context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late StoryModel storyModel;
  List<StoryModel> storyModelList = [];

  // late final UserModel userData;
  UserModel? userData1;
  List<UserModel> userDataList = [];
  Future<void> getAllStories() async {
    emit(GetStoryLoadingState());
    try {
      storyModelList = [];
      userDataList = [];
      final data = await _firestore.collection(STORY_COLLECTION).get();

      final data1 = data.docs;

      log("data1 ==== $data1");
      for (int i = 0; i < data1.length; i++) {
        final data2 = await _firestore
            .collection(STORY_COLLECTION)
            .doc(data1[i].id)
            .collection(USER_STORY_COLLECTION)
            .orderBy('dateTime', descending: true)
            .limit(1)
            .get();

        final docs = data2.docs;
        log("docs ==== ${docs[0].data()}");
        for (int k = 0; k < docs.length; k++) {
          storyModel = StoryModel.fromSnapshot(docs[k]);
          storyModelList.add(storyModel);

          // Future userData = getStoryOwner(storyModel.ownerId).then((value) {
          //   print("value ===== $value");
          //   userData1 = value;
          //   userDataList.add(userData1!);
          // });

          userData1 = await getStoryOwner(storyModel.ownerId);
          userDataList.add(userData1!);
          log('asdasdasdczxczxc $userData1');
        }
      }
      log('storyModelList===== ${storyModelList.length}');
      emit(GetStorySuccesState());
    } catch (e) {
      log(e.toString());
      emit(GetStoryErrorState());
    }
  }

  Future<UserModel> getStoryOwner(String id) async {
    final data =
        await _firestore.collection(AppConstant.USER_COLLECTION).doc(id).get();
    final userData = UserModel.fromSnapshot(data);
    return userData;
  }

  StoryModel? storyData;
  final List<StoryModel> storyDataList = [];
  Future<void> getStoryData(String id) async {
    emit(GetStoryDataLoadingState());
    try {
      final data = await _firestore
          .collection(STORY_COLLECTION)
          .doc(id)
          .collection(USER_STORY_COLLECTION)
          .get();
      for (var element in data.docs) {
        storyData = StoryModel.fromSnapshot(element);
        storyDataList.add(storyData!);
      }
      emit(GetStorySuccesState());
    } catch (e) {
      log(e.toString());
      emit(GetStoryDataErrorState());
    }
  }

  Future<void> addStory({required String userId, required String text}) async {
    emit(AddStoryLoadingState());

    try {
      final String id = AppConstant.uuid.v4();
      final storyImageUrl = await uploadImage(postId: id, imageFile: storyFile);
      final StoryModel _storyData = StoryModel(
        id: id,
        ownerId: userId,
        text: text,
        image: storyImageUrl != null ? storyImageUrl : null,
      );
      final data = _firestore.collection(STORY_COLLECTION).doc(userId);

      data.set({"k": 1});
      data.collection(USER_STORY_COLLECTION).doc(id).set(_storyData.toJson());
      emit(AddStorySuccesState());
    } catch (e) {
      log(e.toString());
      emit(AddStoryErrorState());
    }
  }

  // final _picker = ImagePicker();
  XFile? storyFile;

  Future<XFile?> getImage(context, {required ImageSource source}) async {
    try {
      final _pickedFile = await AppConstant.picker.pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 90,
      );
      if (_pickedFile != null) {
        storyFile = _pickedFile;
        Navigator.pop(context);
        emit(PickImageSuccesState());
        return storyFile;
      }
      emit(PickImageErrorState());
      return storyFile = null;
    } catch (e) {
      emit(PickImageErrorState());
      log(e.toString());
    }
  }

  final _firebaseStorage = FirebaseStorage.instance;

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

  List<StoryModel> ownerStoreies = [];
  late StoryModel ownerStorey;
  Future<void> getOwnerStories() async {
    ownerStoreies = [];
    emit(GetOwnerStoryLoadingState());
    try {
      final _data = await _firestore
          .collection(STORY_COLLECTION)
          .doc(AppConstant.userId)
          .collection(USER_STORY_COLLECTION)
          .get();
      final _docs = _data.docs;
      for (var doc in _docs) {
        ownerStorey = StoryModel.fromSnapshot(doc);
        ownerStoreies.add(ownerStorey);
      }
      emit(GetOwnerStorySuccesState());
    } catch (e) {
      log(e.toString());
      emit(GetOwnerStoryErrorState());
    }
  }

  List<StoryModel> postownerStoreies = [];
  late StoryModel postownerStorey;
  Future<void> getPostOwnerStories(String id) async {
    postownerStoreies = [];
    emit(GetOwnerStoryLoadingState());
    try {
      final _data = await _firestore
          .collection(STORY_COLLECTION)
          .doc(id)
          .collection(USER_STORY_COLLECTION)
          .get();
      final _docs = _data.docs;
      for (var doc in _docs) {
        postownerStorey = StoryModel.fromSnapshot(doc);
        postownerStoreies.add(postownerStorey);
      }
      emit(GetOwnerStorySuccesState());
    } catch (e) {
      log(e.toString());
      emit(GetOwnerStoryErrorState());
    }
  }
}
