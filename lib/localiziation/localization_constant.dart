import 'package:flutter/cupertino.dart';
import 'package:social_app/localiziation/app_localiziation.dart';

String getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context).getTranslatedValues(key);
}
