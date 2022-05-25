import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:social_app/shared/cache_helper.dart';
import 'package:uuid/uuid.dart';

class AppConstant {
  static final dateFormat = DateFormat("d MMM yyyy");
  static final double rad = 100.0.r;

  static final double width = 80.w;

  static final double contHeight = 100.0.h;

  static final double circleRad = 20.0.r;

  // final _user = AuthCubits.get(context).cureentUser;

  static final String userId = FirebaseAuth.instance.currentUser!.uid;

  static final double circleAvataRad = 25.0.r;
  static final double inputBorder = 10.0.r;

  static const String USER_COLLECTION = "users";
  static const String POST_COLLECTION = "posts";
  static const String FOLLOWR_COLLECTION = "followr";
  static const String FOLLOWING_COLLECTION = "following";
  static const String USER_POST_COLLECTION = "userPosts";
  static const String USER_FOLLOWERS = "userFollowers";
  static const String USER_FOLLOWERING = "userFolloweing";
  static const IconData xIcon = Icons.cancel;

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final ImagePicker picker = ImagePicker();

  static String? lang = CacheHelper.getValue(key: "Lang") ?? "English";
  static String? align = CacheHelper.getValue(key: "TextAlign") ?? "Left";
  static bool? mode = CacheHelper.getBool(key: "Mode") ?? false;

  static final TextAlign textaAlign =
      (align == "Left") ? TextAlign.left : TextAlign.right;

  static const Uuid uuid = Uuid();
}

enum NotifiactionType { like, comment, follow }
