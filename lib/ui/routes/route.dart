import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static void navTo({
    required BuildContext context,
    required Widget screenWidget,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screenWidget),
    );
  }

  static void navAndFinish({
    required BuildContext context,
    required Widget screenWidget,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screenWidget),
    );
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
