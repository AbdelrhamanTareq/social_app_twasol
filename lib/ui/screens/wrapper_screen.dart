import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/states/auth_states.dart';
import 'package:social_app/ui/screens/main_screen.dart';
import 'package:social_app/ui/screens/sign_up_screen.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubits, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final _user = AuthCubits.get(context).cureentUser;
        log('${_user?.uid}');

        final Widget _homeScreen =
            (_user != null) ? const MainScreen() : SignUpScreen();
        return _homeScreen;
      },
    );
  }
}
