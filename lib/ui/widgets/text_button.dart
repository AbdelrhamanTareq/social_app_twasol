import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/ui/theme/app_theme.dart';

class BuildTextButton extends StatelessWidget {
  const BuildTextButton({
    Key? key,
    required this.widget,
    required this.width,
    required this.height,
    this.color,
    this.isGradiantColor = false,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget widget;
  final Color? color;
  final bool isGradiantColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: (isGradiantColor)
              ? [
                  AppTheme.primaryColor,
                  AppTheme.accentColor,
                ]
              : [color!, color!],
        ),
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: widget,
    );
  }
}
