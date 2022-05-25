import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FontAwasomeIcon extends StatelessWidget {
  const FontAwasomeIcon({Key? key, required this.icon}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.w, top: 8.0.h, right: 8.0.w),
      child: FaIcon(
        icon,
      ),
    );
  }
}
