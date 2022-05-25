import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/logic/states/home_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/screens/add_post_screen.dart';
import 'package:social_app/ui/screens/home_screen.dart';
import 'package:social_app/ui/screens/notification_screen.dart' as not;
import 'package:social_app/ui/screens/profile_screen.dart';
import 'package:social_app/ui/screens/search_screen.dart';

class HomeCubits extends Cubit<HomeStates> {
  HomeCubits() : super(HomeInitialState());

  static HomeCubits get(BuildContext context) => BlocProvider.of(context);

  bool isSearchTapped = false;

  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    AddPostScreen(),
    const not.NotificationScreen(),
    ProfileScreen(ownerId: AppConstant.userId),
  ];

  void searchTap() {
    isSearchTapped = true;

    emit(NavSearchState());
  }

  void changeIndex(int index) {
    if (isSearchTapped) {
      currentIndex = 1;
      emit(NavState());
    } else {
      currentIndex = index;
      emit(NavState());
    }
  }
}
