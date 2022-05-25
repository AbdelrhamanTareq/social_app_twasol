import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/localiziation/localization_constant.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.cameraFunction,
    required this.galleryFunction,
  }) : super(key: key);

  final Function cameraFunction;
  final Function galleryFunction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200.0.h,
        // alignment: Alignment.center,s
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => cameraFunction(),
              child: Text(
                getTranslated(context, 'camera'),
              ),
            ),
            SizedBox(height: 10.0.h),
            TextButton(
              onPressed: () => galleryFunction(),
              child: Text(
                getTranslated(context, 'gallery'),
              ),
            ),
            SizedBox(height: 10.0.h),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                getTranslated(context, 'cancel'),
              ),
            ),

            // SizedBox(height: 10.0.h),
          ],
        ),
      ),
    );
  }
}
