import 'package:flutter/material.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/ui/theme/app_theme.dart';

class ErrorWidget extends StatelessWidget {
  final VoidCallback? onPress;
  // final String errorText;
  const ErrorWidget({
    Key? key,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[400],
              // color: AppColors.primary,
              size: 150,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              getTranslated(context, 'no_internet_connection'),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          // Text(
          //   getTranslated(context, 'try_again'),
          //   style: const TextStyle(
          //       color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          // ),
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width * 0.55,
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  //onPrimary: Colors.lightBlue,
                  primary: AppTheme.primaryColor,
                  elevation: 500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text(
                getTranslated(context, 'try_again'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                if (onPress != null) {
                  onPress!();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
