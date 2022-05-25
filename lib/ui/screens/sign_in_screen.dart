import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/states/auth_states.dart';
import 'package:social_app/ui/routes/route.dart';
import 'package:social_app/ui/screens/main_screen.dart';

import 'package:social_app/ui/screens/sign_up_screen.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/circle_indicator.dart';
import 'package:social_app/ui/widgets/font_awsome_icon.dart';

import 'package:social_app/ui/widgets/text_button.dart';
import 'package:social_app/ui/widgets/text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  Future _submit(context, AuthStates state) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await AuthCubits.get(context).signInWithEmailAndPass(
          email: _emailController.text, pass: _passController.text);
      if (response != null) {
        AppRoute.navAndFinish(
          context: context,
          screenWidget: const MainScreen(),
        );
      }
      //     .then((value) {
      //   print("value is $value and state is $state");
      //   if (state is AuthSignInWithEmailAndPassSuccessState && value != null) {
      //     AppRoute.navAndFinish(
      //       context: context,
      //       screenWidget: const MainScreen(),
      //     );
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _padding = EdgeInsets.only(top: 50.h, left: 15.w, right: 15.w);

    return BlocConsumer<AuthCubits, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final AuthCubits _authProvider = AuthCubits.get(context);
          return Scaffold(
            body: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: Padding(
                  padding: _padding,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: constraint.maxHeight - _padding.top),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, "signin_header"),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            getTranslated(context, "signin_main_text"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                BuildTextFormField(
                                  controller: _emailController,
                                  labelText: getTranslated(
                                      context, "email_label_text"),
                                  prefixIcon: const FontAwasomeIcon(
                                      icon: FontAwesomeIcons.mailBulk),
                                  // radiuas: 10.r,
                                  validator: (String? val) {
                                    if (!val!.contains('@')) {
                                      return getTranslated(
                                          context, "email_error_text");
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                BuildTextFormField(
                                  controller: _passController,
                                  labelText:
                                      getTranslated(context, "pass_label_text"),
                                  prefixIcon: const FontAwasomeIcon(
                                      icon: FontAwesomeIcons.key),
                                  // radiuas: 10.r,
                                  obscureText: true,
                                  validator: (String? val) {
                                    if (val!.length < 6) {
                                      return getTranslated(
                                          context, "pass_error_text");
                                    }
                                    return null;
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      getTranslated(
                                          context, "signin_forget_pass"),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                              ],
                            ),
                          ),
                          (state is AuthSignInWithEmailAndPassLoadingState)
                              ? const CircleProgreesIndicator()
                              : BuildTextButton(
                                  isGradiantColor: true,
                                  width: double.infinity,
                                  height: 60.h,
                                  widget: TextButton(
                                    onPressed: () {
                                      _submit(context, state);
                                    },
                                    child: Text(
                                      getTranslated(
                                          context, "signin_create_button_text"),
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.h),
                            child: Text(
                              getTranslated(context, "signin_or_continue_with"),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              (state is AuthSignUpWithGoogleLoadingState
                                  ? const CircleProgreesIndicator()
                                  : BuildTextButton(
                                      color: AppTheme.red,
                                      width: 150.w,
                                      height: 50.h,
                                      widget: IconButton(
                                        onPressed: () {
                                          _authProvider
                                              .signInWithGoogle(
                                                  context: context)
                                              .then(
                                                (value) =>
                                                    AppRoute.navAndFinish(
                                                  context: context,
                                                  screenWidget:
                                                      const MainScreen(),
                                                ),
                                              );
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.googlePlusG,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    )),
                              (state is AuthSignUpWithFacebookLoadingState)
                                  ? const CircleProgreesIndicator()
                                  : BuildTextButton(
                                      color: Colors.blue,
                                      width: 150.w,
                                      height: 50.h,
                                      widget: IconButton(
                                        onPressed: () {
                                          _authProvider
                                              .signInWithFacebook(
                                                  context: context)
                                              .then(
                                                (value) =>
                                                    AppRoute.navAndFinish(
                                                  context: context,
                                                  screenWidget:
                                                      const MainScreen(),
                                                ),
                                              );
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.facebookF,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0.h),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated(
                                          context, "signin_have_account"),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                      ),
                                      onPressed: () {
                                        AppRoute.navTo(
                                          context: context,
                                          screenWidget: SignUpScreen(),
                                        );
                                      },
                                      child: Text(
                                        getTranslated(
                                            context, "signin_signup_iniested"),
                                        style: TextStyle(color: AppTheme.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
