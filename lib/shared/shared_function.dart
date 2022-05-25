// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:social_app/shared/app_constant.dart';

// Future<XFile?> getImage(context, {required ImageSource source}) async {
//   try {
//     final _pickedFile = await AppConstant.picker.pickImage(
//       source: source,
//       maxWidth: 800,
//       imageQuality: 90,
//     );
//     if (_pickedFile != null) {
//       storyFile = _pickedFile;
//       Navigator.pop(context);
//       emit(PickImageSuccesState());
//       return storyFile;
//     }
//     emit(PickImageErrorState());
//     return storyFile = null;
//   } catch (e) {
//     emit(PickImageErrorState());
//     print(e.toString());
//   }
// }
