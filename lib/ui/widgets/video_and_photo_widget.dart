import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/custom_dialog.dart';
import 'package:social_app/ui/widgets/text_button.dart';

// class VideoAndPhotoButtonsWidget extends StatelessWidget {
//   const VideoAndPhotoButtonsWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         BuildTextButton(
//           color: AppTheme.aux2Color,
//           widget: TextButton(
//             onPressed: () {},
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   getTranslated(context, "Photo"),
//                   style: TextStyle(color: AppTheme.red),
//                 ),
//                 SizedBox(width: 5.w),
//                 const Icon(FontAwesomeIcons.camera, color: Colors.red),
//               ],
//             ),
//           ),
//           width: 140.w,
//           height: 40.h,
//         ),
//         BuildTextButton(
//           color: AppTheme.aux2Color,
//           widget: TextButton(
//             onPressed: () {},
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   getTranslated(context, 'Video'),
//                   style: TextStyle(color: AppTheme.blue),
//                 ),
//                 SizedBox(width: 10.w),
//                 const Icon(FontAwesomeIcons.video),
//               ],
//             ),
//           ),
//           width: 140.w,
//           height: 40.h,
//         ),
//       ],
//     );
//   }
// }

class VideoAndPhotoButtonsWidget extends StatelessWidget {
  const VideoAndPhotoButtonsWidget({
    Key? key,
    required Function cameraFunction,
    required Function galleryFunction,
  })  : _cameraFunction = cameraFunction,
        _galleryFunction = galleryFunction,
        super(key: key);

  // final PostsCubits _cubit;
  final Function _cameraFunction;
  final Function _galleryFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BuildTextButton(
          color: AppTheme.aux2Color,
          widget: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  cameraFunction: () => _cameraFunction(),
                  // _cubit.getImage(context,
                  //     source: ImageSource.camera),
                  galleryFunction: () => _galleryFunction(),
                  // _cubit.getImage(context,
                  //     source: ImageSource.gallery),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTranslated(context, 'photo'),
                  style: TextStyle(color: AppTheme.red),
                ),
                SizedBox(width: 5.w),
                const Icon(FontAwesomeIcons.camera, color: Colors.red),
              ],
            ),
          ),
          width: 140.w,
          height: 40.h,
        ),
        BuildTextButton(
          color: AppTheme.aux2Color,
          widget: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTranslated(context, 'video'),
                  style: TextStyle(color: AppTheme.blue),
                ),
                SizedBox(width: 10.w),
                const Icon(FontAwesomeIcons.video),
              ],
            ),
          ),
          width: 140.w,
          height: 40.h,
        ),
      ],
    );
  }
}
