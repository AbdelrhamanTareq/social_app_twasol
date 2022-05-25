/// Done ?????????????????////////////////
/// Sign In
/// Sign Up
/// Add Post Screen
///
///
///
///
///
/// ////////////////////////////////
/// Almost Done Until Any Editing ????????????????
/// Setting Screen
/// Story Screen

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:social_app/logic/bloc_observer.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';

import 'package:social_app/logic/states/settigns_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/shared/cache_helper.dart';

import 'package:social_app/ui/screens/wrapper_screen.dart';

import 'package:social_app/ui/theme/app_theme.dart';

import 'localiziation/app_localiziation.dart';
import 'logic/cubits/home_cubit.dart';

import 'logic/cubits/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: AppBlocObserver(),
  );

  // Bloc.observer = MyBlocObserver();
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final _user = AuthCubits.get(context).cureentUser;
    // final Widget _homeScreen =
    //     (_user != null) ? const MainScreen() : SignUpScreen();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubits>(
            create: (context) => AuthCubits()..getCurrentUser(),
          ),
          BlocProvider<HomeCubits>(
            create: (context) => HomeCubits(),
          ),
          BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit(),
          ),
          // BlocProvider<FollowCubits>(
          //   create: (context) => FollowCubits(),
          // ),
        ],
        child: BlocConsumer<SettingsCubit, SettingsStates>(
            listener: (context, state) {},
            builder: (context, state) {
              log('lang ==== ${AppConstant.lang}');

              return MaterialApp(
                // title: getTranslated(context, 'app_title'),
                theme: (AppConstant.mode == false)
                    ? AppTheme.lightTheme
                    : AppTheme.darkTheme,
                darkTheme: AppTheme.darkTheme,
                debugShowCheckedModeBanner: false,
                home: const WrapperScreen(),

                locale: (AppConstant.lang == "Arabic")
                    ? const Locale('ar')
                    : const Locale('en'),
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // localeResolutionCallback: (deviceLanguage, supportedLocales) {
                //   for (var locale in supportedLocales) {
                //     if (locale.languageCode == deviceLanguage!.languageCode &&
                //         locale.countryCode == deviceLanguage.countryCode) {
                //       return deviceLanguage;
                //     }
                //   }
                //   return supportedLocales.first;
                // },
                // )
                // ;
                // },
              );
            }),
      ),
    );
  }
}
