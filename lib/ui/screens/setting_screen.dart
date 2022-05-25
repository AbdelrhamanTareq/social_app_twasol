import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/cubits/settings_cubit.dart';
import 'package:social_app/logic/states/settigns_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/routes/route.dart';
import 'package:social_app/ui/screens/sign_in_screen.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/text_button.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _cubit = SettingsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              // iconTheme: Theme.of(context).iconTheme,
              // backgroundColor: Theme.of(context).iconTheme.color,
              title: Text(
                getTranslated(context, 'setting'),
                // style: TextStyle(color: Theme.of(context).canvasColor),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 30.0.h, horizontal: 15.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTile(
                      icon: FontAwesomeIcons.personBooth,
                      text: getTranslated(context, 'Account'),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.lock,
                      text: getTranslated(context, 'Privacy_Policey'),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.bell,
                      text: getTranslated(context, 'Notification'),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.info,
                      text: getTranslated(context, 'About'),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    _buildDropDownMenu(context, onChanged: (String? val) {
                      _cubit.switchLang(val!);
                    }, value: AppConstant.lang ?? "English"),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    _buildSwitchListTile(
                      value: AppConstant.mode!,
                      onChanged: (bool val) {
                        _cubit.switchMode(val);
                      },
                      icon: FontAwesomeIcons.starAndCrescent,
                      text: getTranslated(context, 'Dark_Mode'),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    BuildTextButton(
                        isGradiantColor: true,
                        widget: TextButton(
                          onPressed: () {
                            AuthCubits.get(context).signOut().then(
                                  (value) => AppRoute.navAndFinish(
                                      context: context,
                                      screenWidget: SignInScreen()),
                                );
                          },
                          child: Text(
                            getTranslated(context, "sign_out"),
                            style: TextStyle(color: AppTheme.white),
                          ),
                        ),
                        width: double.infinity,
                        height: 50.0.h),
                  ],
                ),
              ),
            ),
          );
        });
  }

  ListTile _buildListTile({
    required IconData icon,
    required String text,
  }) {
    return ListTile(
      leading: FaIcon(icon),
      title: Text(text),
      trailing: const FaIcon(FontAwesomeIcons.arrowRight),
    );
  }

  ListTile _buildSwitchListTile({
    required IconData icon,
    required String text,
    required bool value,
    required void Function(bool)? onChanged,
  }) {
    return ListTile(
      leading: FaIcon(icon),
      title: Text(text),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropDownMenu(
    BuildContext context, {
    required String value,
    required void Function(String?)? onChanged,
  }) {
    return ListTile(
      leading: const FaIcon(FontAwesomeIcons.language),
      title: Text(
        getTranslated(context, "Langauge"),
      ),
      trailing: DropdownButton<String>(
        // value: lang
        value: value,
        onChanged: onChanged,
        items: [
          DropdownMenuItem(
            value: "English",
            child: Text(
              getTranslated(context, "English"),
            ),
          ),
          DropdownMenuItem(
            value: "Arabic",
            child: Text(
              getTranslated(context, "Arabic"),
            ),
          ),
        ],
      ),
    );
  }
}
