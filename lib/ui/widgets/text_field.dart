import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTextFormField extends StatelessWidget {
  const BuildTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.validator,
    this.obscureText,
    this.radiuas,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);
  final bool? obscureText;
  final double? radiuas;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiuas ?? 10.r),
          ),
        ),
        prefixIcon: prefixIcon,
        // contentPadding: EdgeInsets.zero,
        //  (prefixIcon == null)
        //     ? Container()
        // :
        // Padding(
        //     padding: (prefixIcon == null)
        //         ? EdgeInsets.zero
        //         : EdgeInsets.only(left: 7.w, top: 7.h, bottom: 5.h),
        //     child: prefixIcon),
        // suffixIcon: suffixIcon ?? Container(),
        labelText: labelText,
      ),
    );
  }
}
