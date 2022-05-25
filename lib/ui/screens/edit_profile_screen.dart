import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/states/auth_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/widgets/custom_dialog.dart';
import 'package:social_app/ui/widgets/text_button.dart';
import 'package:social_app/ui/widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubits, AuthStates>(listener: (context, state) {
      if (state is UpdateUserDataSuccessState) {
        PostsCubits.get(context).getPostOwnerData(AppConstant.userId);
      }
    }, builder: (context, state) {
      final _data = PostsCubits.get(context).ownerData;
      final XFile? _imageFile = AuthCubits.get(context).imageFile;
      _usernameController.text = _data!.username!;
      _bioController.text = _data.bio!;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            getTranslated(context, 'Profile'),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state is UpdateUserDataLoadingState)
                  const LinearProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 50.0.h, bottom: 25.0.h),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 90.h,
                          height: 90.h,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: (_imageFile != null)
                              ? Image(
                                  width: 50.h,
                                  height: 50.h,
                                  image: FileImage(
                                    File(_imageFile.path),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : Image(
                                  width: 50.h,
                                  height: 50.h,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    _data.imageUrl!,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.0.h, right: 3.0.w),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                    cameraFunction: () =>
                                        AuthCubits.get(context).uploadImage(
                                          ImageSource.camera,
                                          context,
                                        ),
                                    galleryFunction: () =>
                                        AuthCubits.get(context).uploadImage(
                                          ImageSource.gallery,
                                          context,
                                        )));
                          },
                          icon: const FaIcon(FontAwesomeIcons.camera),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      BuildTextFormField(
                        labelText:
                            getTranslated(context, 'username_label_text'),
                        validator: (val) {},
                        prefixIcon: Padding(
                          padding:
                              EdgeInsets.only(left: 7.w, top: 7.h, bottom: 5.h),
                          child: const FaIcon(FontAwesomeIcons.user),
                        ),
                        controller: _usernameController,
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text(getTranslated(context, 'Gender')),
                      ),
                      // Container(
                      //   width: 200,
                      //   child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              value: true,
                              onChanged: (val) {},
                              title: Text(getTranslated(context, 'Male')),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: false,
                              onChanged: (val) {},
                              title: Text(getTranslated(context, 'Female')),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),
                      // ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      BuildTextFormField(
                        labelText: getTranslated(context, 'Bio'),
                        validator: (val) {},
                        controller: _bioController,
                        maxLines: 4,
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      BuildTextButton(
                        widget: TextButton(
                          child: Text(
                            getTranslated(context, 'Edit'),
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () {
                            AuthCubits.get(context).updateUserData(
                              imageFile: File(_imageFile!.path),
                              username: _usernameController.text,
                              bio: _bioController.text,
                            );
                          },
                        ),
                        width: double.infinity,
                        height: 60.0.h,
                        isGradiantColor: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
