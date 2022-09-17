import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_app/data/models/story_model.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/auth_cubit.dart';
import 'package:social_app/logic/cubits/home_cubit.dart';
import 'package:social_app/logic/cubits/notification_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/logic/states/posts_states.dart';
import 'package:social_app/logic/states/story_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/routes/route.dart';

import 'package:social_app/ui/widgets/post_widget.dart';

import 'package:social_app/ui/widgets/video_and_photo_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);
  final double _contWidth = 80.0.w;
  final double _contHeight = 100.0.h;
  final double _rad = 20.0.r;
  // final PostsCubits postCubit;

  // final PostsCubits _postCubit = PostsCubits();
  Future<void> _refreshFunction(context) async {
    await PostsCubits.get(context).getPostData();
    await StoryCubit.get(context).getAllStories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubits, PostsStates>(listener: (context, state) {
      if (state is AddLikeState) {
        NotificationCubit.get(context).addNotification(
          NotifiactionType.like,
        );
      }
    }, builder: (context, state) {
      final _data = PostsCubits.get(context).postsModel;
      final UserModel? _userData = AuthCubits.get(context).userModel;
      final _likes = PostsCubits.get(context).likes;
      final _storyModelList = StoryCubit.get(context).storyModelList;
      final _userStoryDataList = StoryCubit.get(context).userDataList;

      if (((state is GetPostsLoadingState) || _userData == null)) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        // print("likes = ${PostsCubits.get(context).likes}");

        return RefreshIndicator(
          onRefresh: () {
            return _refreshFunction(context);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: (AppConstant.align == "Left")
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.h, horizontal: 8.w),
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colors.amber,
                        backgroundImage: CachedNetworkImageProvider(
                          _userData.imageUrl ?? "",
                        )
                        //  NetworkImage(

                        //   _userData.imageUrl ?? ""),
                        ),
                    title: Text(_userData.username ?? "",
                        style: Theme.of(context).textTheme.headline6
                        //  TextStyle(color: AppTheme.black),
                        ),
                    subtitle: Text(_userData.email ?? "",
                        style: Theme.of(context).textTheme.headline6
                        //  TextStyle(color: AppTheme.black),
                        ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // AppRoute.navTo(
                            //   context: context,
                            //   screenWidget: const SettingScreen(),
                            // );
                            AppRoute.navToWithName(
                                context: context, screenName: '/setting');
                          },
                          icon: const FaIcon(FontAwesomeIcons.cog),
                        ),
                        IconButton(
                          onPressed: () {
                            HomeCubits.get(context).searchTap();
                          },
                          icon: const FaIcon(FontAwesomeIcons.search),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOwnerAddStory(context, _userData),
                    _buildUsersStories(_storyModelList, _userStoryDataList),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                VideoAndPhotoButtonsWidget(
                  cameraFunction: () {},
                  galleryFunction: () {},
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  child: BuildPostWidget(
                    // blocValue: PostsCubits.get(context),
                    data: _data,
                    userData: _userData,
                    likes: _likes,
                    isOwnerScreen: false,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  InkWell _buildOwnerAddStory(BuildContext context, UserModel _userData) {
    return InkWell(
      onTap: () {
        // AppRoute.navTo(
        //   context: context,
        //   screenWidget: BlocProvider<StoryCubit>.value(
        //       value: StoryCubit.get(context), child: AddStoryScreen()),
        // );
        AppRoute.navToWithName(context: context, screenName: '/add_story');
      },
      child: SizedBox(
        height: 145.h,
        child: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 10.w),
          child: Column(
            children: [
              SizedBox(
                width: _contWidth,
                height: 120.h,
                child: Stack(
                  children: [
                    Container(
                      width: _contWidth,
                      height: _contHeight,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstant.inputBorder),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                _userData.coverImageUrl!),
                            // NetworkImage(_userData.coverImageUrl!),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: _contHeight - _rad,
                      right: (_contWidth / 2) - _rad,
                      child: CircleAvatar(
                        radius: _rad,
                        backgroundColor: Colors.blue,
                        backgroundImage:
                            CachedNetworkImageProvider(_userData.imageUrl!),
                        //  NetworkImage(_userData.imageUrl!),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                getTranslated(context, 'Add_story'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocConsumer _buildUsersStories(
      List<StoryModel> _storyModelList, List<UserModel> _userStoryDataList) {
    return BlocConsumer<StoryCubit, StoryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetStoryLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Expanded(
          child: SizedBox(
            height: 140.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  // AppRoute.navTo(
                  //     context: context,
                  //     screenWidget: BlocProvider.value(
                  //       value: StoryCubit.get(context),
                  //       child: StorySceen(
                  //         storyId: _storyModelList[index].ownerId,
                  //         storyUsername: _userStoryDataList[index].username!,
                  //         storyDate: _storyModelList[index].dateTime!,
                  //       ),
                  //     ));
                  AppRoute.navToWithName(
                    context: context,
                    screenName: '/story',
                    arguments: {
                      "storyId": _storyModelList[index].ownerId,
                      "storyUsername": _userStoryDataList[index].username!,
                      "storyDate": _storyModelList[index].dateTime!
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  child: Column(
                    children: [
                      SizedBox(
                        width: _contWidth,
                        height: 120.h,
                        child: Stack(
                          children: [
                            Container(
                              width: _contWidth,
                              height: _contHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0.r),
                                image: DecorationImage(
                                    image: (_storyModelList[index].image != "")
                                        ? CachedNetworkImageProvider(
                                            _storyModelList[index].image!)
                                        //  NetworkImage(
                                        //     _storyModelList[index].image!)
                                        : const AssetImage(
                                                'assets/images/cover.jpg')
                                            as ImageProvider<Object>,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: _contHeight - _rad,
                              right: (_contWidth / 2) - _rad,
                              child: CircleAvatar(
                                radius: _rad,
                                backgroundColor: Colors.blue,
                                backgroundImage: CachedNetworkImageProvider(
                                    _userStoryDataList[index].imageUrl!),
                                // NetworkImage(
                                //     _userStoryDataList[index].imageUrl!),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(_userStoryDataList[index].username!),
                    ],
                  ),
                ),
              ),
              itemCount: _storyModelList.length,
            ),
          ),
        );
      },
    );
  }
}
