import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/logic/states/settigns_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/shared/cache_helper.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  SettingsCubit() : super(SettingsInitialState());

  static SettingsCubit get(BuildContext context) => BlocProvider.of(context);

  // var _isEnglish;
  // //  CacheHelper.getValue(key: 'Lang')  true;
  // get isEnglish {
  //   if (CacheHelper.getValue(key: 'Lang') == 'English') {
  //     _isEnglish = true;
  //   } else {
  //     _isEnglish = false;
  //   }
  // }

  // TextAlign textAlign = TextAlign.left;

  String langVal = "English";

  bool isDark = false;

  Locale lang = const Locale("en");

  void switchLang(String val) async {
    if (val == "English") {
      // _isEnglish = true;
      langVal = "English";
      AppConstant.lang = "English";
      AppConstant.align = "Left";
      await CacheHelper.setValue(key: 'Lang', value: 'English');
      await CacheHelper.setValue(key: 'TextAlign', value: 'Left');
      // textAlign = TextAlign.left;
      emit(ChangeLangState());
    } else {
      // _isEnglish = false;
      langVal = "Arabic";
      AppConstant.lang = "Arabic";
      AppConstant.align = "Right";
      await CacheHelper.setValue(key: 'Lang', value: 'Arabic');
      await CacheHelper.setValue(key: 'TextAlign', value: 'Right');
      // textAlign = TextAlign.right;
      emit(ChangeLangState());
    }
  }

  void switchMode(bool val) async {
    isDark = val;
    AppConstant.mode = val;
    await CacheHelper.setValue(key: 'Mode', value: val);
    emit(ChangeLangState());
  }
}
