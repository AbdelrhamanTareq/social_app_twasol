import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/logic/states/home_states.dart';
import 'package:social_app/ui/screens/add_post_screen.dart';
import 'package:social_app/ui/screens/home_screen.dart';
import 'package:social_app/ui/screens/notification_screen.dart' as not;
import 'package:social_app/ui/screens/profile_screen.dart';
import 'package:social_app/ui/screens/search_screen.dart';
import 'package:social_app/shared/app_constant.dart';

class HomeCubits extends Cubit<HomeStates> {
  HomeCubits() : super(HomeInitialState());

  static HomeCubits get(BuildContext context) => BlocProvider.of(context);

  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    AddPostScreen(),
    const not.NotificationScreen(),
    ProfileScreen(
      ownerId: AppConstant.userId,
    ),
  ];

  int currentIndex = 0;
  void changeIndex(int index) {
    currentIndex = index;
    emit(NavState());
  }
}
