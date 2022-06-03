import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/cubits/comments_cubit.dart';
import 'package:social_app/logic/cubits/follow_cubit.dart';
import 'package:social_app/logic/cubits/notification_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/cubits/search_cubit.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/ui/screens/add_story_screen.dart';
import 'package:social_app/ui/screens/comments_screen.dart';
import 'package:social_app/ui/screens/edit_profile_screen.dart';
import 'package:social_app/ui/screens/main_screen.dart';
import 'package:social_app/ui/screens/post_owner_profile.dart';
import 'package:social_app/ui/screens/setting_screen.dart';
import 'package:social_app/ui/screens/sign_in_screen.dart';
import 'package:social_app/ui/screens/sign_up_screen.dart';
import 'package:social_app/ui/screens/storey_screen.dart';
import 'package:social_app/ui/screens/wrapper_screen.dart';

class AppRoute {
  final StoryCubit _storyCubit = StoryCubit();
  final CommentsCubits _commentsCubit = CommentsCubits();
  final PostsCubits _postsCubit = PostsCubits();
  final FollowCubits _followCubit = FollowCubits();
  final NotificationCubit _notifivationCubit = NotificationCubit();
  final SearchCubits _searchCubit = SearchCubits();
  final AuthCubits _authCubit = AuthCubits();

  static void navTo({
    required BuildContext context,
    required Widget screenWidget,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screenWidget),
    );
  }

  static void navToWithName({
    required BuildContext context,
    required String screenName,
    Object? arguments,
  }) {
    Navigator.of(context).pushNamed(screenName, arguments: arguments);
  }

  static void navAndFinish({
    required BuildContext context,
    required Widget screenWidget,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screenWidget),
    );
  }

  Route? appRouter(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        final _user = _authCubit.cureentUser;
        if (_user != null) {
          return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
              BlocProvider.value(value: _postsCubit..getPostData()),
              BlocProvider.value(value: _storyCubit),
              BlocProvider.value(value: _followCubit..getUserFollowing()),
              BlocProvider.value(
                  value: _notifivationCubit..getUserNotification()),
              BlocProvider.value(value: _searchCubit),
              BlocProvider.value(value: _storyCubit..getAllStories()),
            ], child: const MainScreen1()),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => SignUpScreen(),
          );
        }
      case '/post_owner_proifle':
        final String ownerId = setting.arguments as String;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _postsCubit),
              BlocProvider.value(value: _storyCubit),
              BlocProvider.value(value: _followCubit),
              BlocProvider.value(value: _notifivationCubit),
            ],
            child: PostOwnerProfile(
              ownerId: ownerId,
            ),
          ),
        );
      case '/add_story':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _storyCubit,
            child: AddStoryScreen(),
          ),
        );
      case '/comments':
        final arg = setting.arguments as Map;
        final String postId = arg['postId'] as String;
        final String commentOwnerId = arg['commentOwnerId'] as String;
        final String commentOwnerImage = arg['commentOwnerImage'] as String;
        final String commentOwnerUsername =
            arg['commentOwnerUsername'] as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _commentsCubit,
            child: CommentsScreen(
              postId: postId,
              commentOwnerId: commentOwnerId,
              commentOwnerImage: commentOwnerImage,
              commentOwnerUsername: commentOwnerUsername,
            ),
          ),
        );
      case '/edit_proifle':
        return MaterialPageRoute(
          builder: (context) => const EditProfileScreen(),
        );
      case '/setting':
        return MaterialPageRoute(
          builder: (context) => const SettingScreen(),
        );
      case '/story':
        final arg = setting.arguments as Map;

        final String storyId = arg['storyId'] as String;
        final String storyUsername = arg['storyUsername'] as String;
        final Timestamp storyDate = arg['storyDate'] as Timestamp;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _storyCubit,
            child: StorySceen(
              storyDate: storyDate,
              storyId: storyId,
              storyUsername: storyUsername,
            ),
          ),
        );
      case '/sign_in':
        return MaterialPageRoute(
          builder: (context) => SignInScreen(),
        );
      case '/sign_up':
        return MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        );
    }
  }

  void dispose() {
    _commentsCubit.close();
    _storyCubit.close();
    _postsCubit.close();
    _followCubit.close();
    _notifivationCubit.close();
    _searchCubit.close();
    _authCubit.close();
  }
}


// Route? onGenerateRoute(RouteSettings routeSettings) {
//     switch (routeSettings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => const WrapperScreen());

//       case 'post_owner_profile':
//         return MaterialPageRoute(builder: (_) => PostOwnerProfile());
//       case 'setting_screen':
//         return MaterialPageRoute(builder: (_) => const SettingScreen());
//       case 'story_screen':
//         return MaterialPageRoute(builder: (_) => StorySceen());
//       case 'add_story':
//         return MaterialPageRoute(builder: (_) => AddStoryScreen());
//       case 'sign_in':
//         return MaterialPageRoute(builder: (_) => SignInScreen());
//       case 'sign_up':
//         return MaterialPageRoute(builder: (_) => SignUpScreen());
        
//       default:
//         return null;
//     }
//   }
