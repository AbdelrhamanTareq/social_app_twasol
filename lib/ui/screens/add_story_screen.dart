import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/logic/states/story_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/custom_dialog.dart';
import 'package:social_app/ui/widgets/header_widget.dart';
import 'package:social_app/ui/widgets/text_button.dart';

class AddStoryScreen extends StatelessWidget {
  AddStoryScreen({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryCubit, StoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _cubit = StoryCubit.get(context);
          final XFile? _storyImage = _cubit.storyFile;
          return Scaffold(
              body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is AddStoryLoadingState)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.0.h),
                    child: HeaderWidget(
                      headerText: getTranslated(context, "add_story"),
                    ),
                  ),
                  SizedBox(
                    height: 40.0.h,
                  ),
                  if (_storyImage != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          // height: 400.0.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0.r),
                          ),
                          child: Image.file(
                            File(_storyImage.path),
                          ),
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                      ],
                    ),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: getTranslated(context, "Add_story_description"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                    ),
                    controller: _textController,
                  ),
                  SizedBox(
                    height: 15.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BuildTextButton(
                        widget: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                cameraFunction: () => _cubit.getImage(context,
                                    source: ImageSource.camera),
                                galleryFunction: () => _cubit.getImage(context,
                                    source: ImageSource.gallery),
                              ),
                            );
                          },
                          child: Text(
                            getTranslated(context, "Add_media"),
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                        width: 150.0.w,
                        height: 45.0.h,
                        color: AppTheme.red,
                      ),
                      BuildTextButton(
                        widget: TextButton(
                          onPressed: () {
                            _cubit.addStory(
                                userId: AppConstant.userId,
                                text: _textController.text);
                          },
                          child: Text(
                            getTranslated(context, "add_story"),
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                        width: 150.0.w,
                        height: 45.0.h,
                        color: AppTheme.aux1Color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        });
  }
}
