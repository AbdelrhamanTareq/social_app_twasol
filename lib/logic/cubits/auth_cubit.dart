import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/logic/states/auth_states.dart';
import 'package:social_app/shared/app_constant.dart';

// const String USER_COLLECTION = "users";

class AuthCubits extends Cubit<AuthStates> {
  AuthCubits() : super(AuthInitialState());

  static AuthCubits get(BuildContext context) => BlocProvider.of(context);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signUpWithEmailAndPass(
      {required String email,
      required String pass,
      context,
      required String username}) async {
    emit(AuthSignUpWithEmailAndPassLoadingState());
    // User? user;
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      final String _msg = getMessageFromErrorCode(e);
      _showErrorToast(_msg);
      log(_msg);
      log(e.toString());
      emit(AuthSignUpWithEmailAndPassErrorState());
    } catch (e) {
      log(e.toString());
      emit(AuthSignUpWithEmailAndPassErrorState());
    }
    emit(AuthSignUpWithEmailAndPassSuccessState());
    final uid = user!.uid;
    log("fasasfasf $uid");
    final UserModel userModel = UserModel(
      bio: "",
      email: email,
      imageUrl: user!.photoURL,
      username: username,
      birthDate: "",
      uid: uid,
    );
    await _firestore
        .collection(AppConstant.USER_COLLECTION)
        .doc(
          uid,
        )
        .set(
          userModel.toJson(),
        );
    return user;
  }

  Future<User?> signInWithEmailAndPass(
      {required String email, required String pass, context}) async {
    emit(AuthSignInWithEmailAndPassLoadingState());
    // User? user;
    // getCurrentUser();
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      user = userCredential.user;
      final uid = user!.uid;
      final _token = await FirebaseMessaging.instance.getToken();
      await _firestore
          .collection(AppConstant.USER_COLLECTION)
          .doc(
            uid,
          )
          .update({
        "androidToken": _token,
      });

      getCurrentUser();
    } on FirebaseAuthException catch (e) {
      final String _msg = getMessageFromErrorCode(e);
      _showErrorToast(_msg);

      log(e.toString());
      emit(AuthSignInWithEmailAndPassErrorState());
    } catch (e) {
      log(e.toString());
      emit(AuthSignInWithEmailAndPassErrorState());
    }
    emit(AuthSignInWithEmailAndPassSuccessState());
    return user;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    emit(AuthSignUpWithGoogleLoadingState());
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        user = userCredential.user;
        // getCurrentUser();
      } on FirebaseAuthException catch (e) {
        final String _msg = getMessageFromErrorCode(e);
        _showErrorToast(_msg);
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
        emit(AuthSignUpWithGoogleErrorState());
      }
    }
    emit(AuthSignUpWithGoogleSuccessState());
    final UserModel userModel = UserModel(
      bio: "",
      email: user!.email,
      imageUrl: user!.photoURL,
      username: user!.displayName,
      birthDate: "",
      uid: user!.uid,
    );
    await _firestore.collection(AppConstant.USER_COLLECTION).doc(user!.uid).set(
          userModel.toJson(),
        );
    return user;
  }

  Future<User?> signInWithFacebook({required BuildContext context}) async {
    emit(AuthSignUpWithFacebookLoadingState());
    // User? user;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential =
            await _auth.signInWithCredential(facebookCredential);
        user = userCredential.user;
        final UserModel userModel = UserModel(
          bio: "",
          email: user!.email,
          imageUrl: user!.photoURL,
          username: user!.displayName,
          birthDate: "",
          uid: user!.uid,
        );
        await _firestore
            .collection(AppConstant.USER_COLLECTION)
            .doc(user!.uid)
            .set(
              userModel.toJson(),
            );
        emit(AuthSignUpWithFacebookSuccessState());
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
        emit(AuthSignUpWithGoogleErrorState());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred using Facebook Sign-In. Try again.',
          ),
        );
        emit(AuthSignUpWithGoogleErrorState());
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error occurred using Facebook Sign-In. Try again.',
        ),
      );
      emit(AuthSignUpWithGoogleErrorState());
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Stream<User?>? get userState {
    _auth.authStateChanges();
  }

  User? get cureentUser {
    return _auth.currentUser;
  }

  UserModel? userModel;
  getCurrentUser() async {
    if (_auth.currentUser == null) {
      return;
    }
    // final userId = cureentUser!.uid;
    final userId = _auth.currentUser!.uid;
    log("asasd asdasd $userId");
    final userData = await _firestore
        .collection(AppConstant.USER_COLLECTION)
        // .doc("6YxLxf9NuTIyGMvxud4v")
        .doc(userId)
        .get();

    userModel = UserModel.fromSnapshot(userData);

    // UserModel.fromJson(userData.data()) as User?;
    return userModel;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  String getMessageFromErrorCode(FirebaseException e) {
    switch (e.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Too many requests to log into this account.";

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";

      case "invalid-credential":
        return "Error occurred while accessing credentials. Try again.";

      default:
        return "Login failed. Please try again.";
    }
  }

  void updateUserData({
    required String username,
    required String bio,
    required File imageFile,
    // required String imageUrl,
  }) async {
    emit(UpdateUserDataLoadingState());
    final _imageUrl = await updateUserImage(imageFile);
    try {
      await _firestore
          .collection(AppConstant.USER_COLLECTION)
          .doc(AppConstant.userId)
          .update({
        'username': username,
        'bio': bio,
        'imageUrl': _imageUrl,
      });
      final _userPosts = await _firestore
          .collection("posts")
          .doc(AppConstant.userId)
          .collection("userPosts")
          .get();
      final _docs = _userPosts.docs;
      log('${_docs[0].data()}');
      for (var element in _docs) {
        element.data().update("userImage", (val) => val = "asdasdasd");
        element.reference.update({"userImage": _imageUrl});
        log('${element.data().values}');
      }

      emit(UpdateUserDataSuccessState());
    } catch (e) {
      log(e.toString());
      emit(UpdateUserDataErrorState());
    }
  }

  // final _firebaseStorage = FirebaseStorage.instance;

  Future<String> updateUserImage(File imageFile) async {
    final TaskSnapshot task = await FirebaseStorage.instance
        // .ref("users-images/${AppConstant.userId}.jpg")
        .ref("users-images/${DateTime.now().toString()}.jpg")
        .putFile(imageFile);
    // final TaskSnapshot data = task.snapshot;
    final String url = await task.ref.getDownloadURL();
    return url;
  }

  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();
  void uploadImage(source, context) async {
    final XFile? _pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (_pickedFile != null) {
      imageFile = _pickedFile;
      Navigator.pop(context);
      emit(GetImageSuccessState());
      log("imageFile = $imageFile");
    } else {
      log("No image picked");
      emit(GetImageErrorState());
    }
    // return pickedFile;
  }

  _showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
    );
  }
}
