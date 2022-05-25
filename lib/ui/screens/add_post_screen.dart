import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/states/posts_states.dart';
import 'package:social_app/shared/app_constant.dart';

import 'package:social_app/ui/widgets/header_widget.dart';
import 'package:social_app/ui/widgets/text_button.dart';
import 'package:social_app/ui/widgets/video_and_photo_widget.dart';

// enum ImageSource { camera, gallery }

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();

  Widget _loadingWidget(PostsStates state) {
    if (state is AddPostsLoadingState) {
      return const LinearProgressIndicator();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubits, PostsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final PostsCubits _cubit = PostsCubits.get(context);
          final User? _user = AuthCubits.get(context).cureentUser;
          final UserModel? _userModel = AuthCubits.get(context).userModel;
          final XFile? _imageFile = _cubit.imageFile;
          const double _bottomNavHeight = kBottomNavigationBarHeight;
          final double _height =
              MediaQuery.of(context).size.height - _bottomNavHeight - 5.0.h;
          // print('state1 === $state');

// ToDo dispose controller
          // if (state is AddPostsSuccessState) {
          //   _controller.clear();
          // } else if (state is AddPostsLoadingState) {
          //   print('state === asasdasdasxmz,xnc,zxnmc,as');
          // }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: SizedBox(
                height: _height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // (state is AddPostsLoadingState)
                    //     ? const Text('gfggghgh')
                    //     : Container(),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0.h),
                      child: Row(
                        children: [
                          HeaderWidget(
                            headerText: getTranslated(context, 'create_post'),
                          ),
                          const Spacer(),
                          const FaIcon(FontAwesomeIcons.paperPlane),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),

                    VideoAndPhotoButtonsWidget(
                      cameraFunction: () =>
                          _cubit.getImage(context, source: ImageSource.camera),
                      galleryFunction: () =>
                          _cubit.getImage(context, source: ImageSource.gallery),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    (_imageFile == null)
                        ? Container()
                        : Image.file(File(_imageFile.path),
                            width: 300.w, height: 150.h, fit: BoxFit.cover),
                    SizedBox(
                      height: 20.h,
                    ),

                    Container(
                      child: Text(
                        getTranslated(context, 'caption'),
                      ),
                      width: double.infinity,
                      alignment: (AppConstant.align == "Left")
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: TextFormField(
                        controller: _controller,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: getTranslated(context, 'add_a_caption'),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                        ),
                      ),
                    ),
                    _loadingWidget(state),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0.h),
                      child: BuildTextButton(
                        widget: TextButton(
                          onPressed: () {
                            _cubit
                                .uploadPost(
                                    postText: _controller.text,
                                    // username: _user!.displayName!,
                                    username: _userModel!.username!,
                                    uid: _user!.uid,
                                    userImage: _userModel.imageUrl!,
                                    ownerId: _userModel.uid!
                                    // userImage: _user.photoURL!,
                                    )
                                .then((_) {
                              _controller.text = "";
                            });
                          },
                          child: Text(
                            getTranslated(context, 'upload'),
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                        width: double.infinity,
                        height: 50.h,
                        isGradiantColor: true,
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

// CustomScrollView(
//   slivers: [
//     SliverFillRemaining(
//       hasScrollBody: false,
//       child: Column(
//         children: <Widget>[
//           const Text('Header'),
//           Expanded(child: Container(color: Colors.red)),
//           const Text('Footer'),
//         ],
//       ),
//     ),
//   ],
// )
