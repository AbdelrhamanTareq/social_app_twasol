import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/data/models/story_model.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/follow_cubit.dart';
import 'package:social_app/logic/cubits/notification_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/logic/states/follow_states.dart';
import 'package:social_app/logic/states/posts_states.dart';
import 'package:social_app/logic/states/story_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/routes/route.dart';
import 'package:social_app/ui/screens/edit_profile_screen.dart';
import 'package:social_app/ui/screens/storey_screen.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/count_column_widget.dart';
import 'package:social_app/ui/widgets/post_widget.dart';
import 'package:social_app/ui/widgets/text_button.dart';

class PostOwnerProfile extends StatefulWidget {
  const PostOwnerProfile({
    Key? key,
    required this.ownerId,
  }) : super(key: key);

  final String ownerId;

  @override
  State<PostOwnerProfile> createState() => _PostOwnerProfileState();
}

class _PostOwnerProfileState extends State<PostOwnerProfile> {
  // _followUser() {
  //   BlocProvider.value(value: FollowCubits.get(context),child:  ,);
  // }

  @override
  void initState() {
    PostsCubits.get(context).getPostOwnerData(widget.ownerId);
    PostsCubits.get(context).getPostOwnerPosts(widget.ownerId);
    StoryCubit.get(context).getPostOwnerStories(widget.ownerId);
    FollowCubits.get(context).getPostOwnerFollowCount(widget.ownerId);
    super.initState();
  }

  @override
  void dispose() {
    // print("dispose");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubits, PostsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _ownerData = PostsCubits.get(context).ownerData;
          final _postData = PostsCubits.get(context).postOwnerPosts;
          final _likes = PostsCubits.get(context).likes;
          final int _postsCount = PostsCubits.get(context).postOwnerPostsCount;
          final _postOwnerStories = StoryCubit.get(context).postownerStoreies;

          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: (_ownerData == null || _postData == [] || _likes == {})
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 220.h,
                            child:
                                //  (_ownerData == null)
                                //     ? Container()
                                //     :
                                Image.network(
                              // coverImgUrl,
                              _ownerData.coverImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 170.h),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: AppConstant.rad / 2),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.0.r),
                                      // color: Colors.white,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.white,
                                      //     blurRadius: 5.0.r,
                                      //     offset: Offset(0.0, 5.0.h),
                                      //   ),
                                      // ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 15.0.h, bottom: 15.0.h),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: AppConstant.rad / 2,
                                          ),
                                          Text(
                                            // username,
                                            _ownerData.username!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 34.0.sp),
                                          ),
                                          Text(
                                            // email,
                                            _ownerData.email!,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.0.h,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 32.0.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: BuildCountColumn(
                                                    text: getTranslated(
                                                        context, "Posts"),
                                                    count:
                                                        _postsCount.toString(),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: BlocBuilder<
                                                      FollowCubits,
                                                      FollowStates>(
                                                    builder: (context, state) {
                                                      final int _followerCount =
                                                          FollowCubits.get(
                                                                  context)
                                                              .followerCount;
                                                      final int
                                                          _followingCount =
                                                          FollowCubits.get(
                                                                  context)
                                                              .followingCount;
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          BuildCountColumn(
                                                            text: getTranslated(
                                                                context,
                                                                "Followers"),
                                                            count:
                                                                _followerCount
                                                                    .toString(),
                                                          ),
                                                          BuildCountColumn(
                                                            text: getTranslated(
                                                                context,
                                                                "Following"),
                                                            count:
                                                                _followingCount
                                                                    .toString(),
                                                          ),
                                                          // buildColumn(
                                                          //   text: getTranslated(
                                                          //       context,
                                                          //       "Followers"),
                                                          //   count:
                                                          //       _followerCount
                                                          //           .toString(),
                                                          // ),
                                                          // buildColumn(
                                                          //   text: getTranslated(
                                                          //       context,
                                                          //       "Following"),
                                                          //   count:
                                                          //       _followingCount
                                                          //           .toString(),
                                                          // ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 30.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                BuildTextButton(
                                                  widget: TextButton(
                                                    onPressed: () {
                                                      // ToDo follow button
                                                      (widget.ownerId ==
                                                              AppConstant
                                                                  .userId)
                                                          ? AppRoute.navTo(
                                                              context: context,
                                                              screenWidget:
                                                                  BlocProvider
                                                                      .value(
                                                                value: PostsCubits
                                                                    .get(
                                                                        context),
                                                                child:
                                                                    const EditProfileScreen(),
                                                              ),
                                                            )
                                                          :
                                                          // () {
                                                          FollowCubits.get(
                                                                  context)
                                                              .followUser(widget
                                                                  .ownerId);
                                                      // };
                                                    },
                                                    child: BlocConsumer<
                                                            FollowCubits,
                                                            FollowStates>(
                                                        listener:
                                                            (context, state) {
                                                      if (state
                                                          is FollowUserSuccesState) {
                                                        NotificationCubit.get(
                                                                context)
                                                            .addNotification(
                                                                NotifiactionType
                                                                    .follow);
                                                      }
                                                    }, builder:
                                                            (context, state) {
                                                      final Map _isFollowedMap =
                                                          FollowCubits.get(
                                                                  context)
                                                              .userFollowing;
                                                      final bool _isFollowed =
                                                          _isFollowedMap[widget
                                                                  .ownerId] ??
                                                              false;
                                                      // print(
                                                      //     '_isFollowedMap === $_isFollowedMap');
                                                      // print(
                                                      //     '_isFollowed === $_isFollowed');
                                                      return Text(
                                                        (widget.ownerId ==
                                                                AppConstant
                                                                    .userId)
                                                            ? getTranslated(
                                                                context, "Edit")
                                                            : getTranslated(
                                                                context,
                                                                (_isFollowed)
                                                                    ? "unFollow"
                                                                    : "Follow"),
                                                        style: TextStyle(
                                                            color:
                                                                AppTheme.white),
                                                      );
                                                    }),
                                                  ),
                                                  width: 200.h,
                                                  height: 50.h,
                                                  isGradiantColor: true,
                                                ),
                                                Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          AppTheme.primaryColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  ),
                                                  child: const Center(
                                                    child: FaIcon(
                                                        FontAwesomeIcons
                                                            .facebookMessenger),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_postOwnerStories.isNotEmpty)
                                            SizedBox(
                                              height: 140.h,
                                              child: _buildUsersStories(
                                                  _postOwnerStories,
                                                  _ownerData),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 20.w),
                                            child: BuildPostWidget(
                                              data: _postData,
                                              userData: _ownerData,
                                              likes: _likes,
                                              isOwnerScreen: true,
                                              //ToDo
                                              // blocValue: PostsCubits(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //Image Avatar
                                Container(
                                  width: AppConstant.rad,
                                  height: AppConstant.rad,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3.0.r,
                                        offset: Offset(0.0, 5.0.h),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0.w),
                                    child: CircleAvatar(
                                      radius: AppConstant.rad,
                                      backgroundImage: NetworkImage(
                                        // profielImgUrl,
                                        _ownerData.imageUrl!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        }
        // ),
        // ),
        );
  }

  BlocConsumer _buildUsersStories(
      List<StoryModel> _storyModelList, UserModel _ownerData) {
    final double _contWidth = 80.0.w;
    final double _contHeight = 100.0.h;
    return BlocConsumer<StoryCubit, StoryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetStoryLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                AppRoute.navTo(
                    context: context,
                    screenWidget: BlocProvider.value(
                      value: StoryCubit.get(context),
                      child: StorySceen(
                        storyId: _storyModelList[index].ownerId,
                        storyDate: _storyModelList[index].dateTime!,
                        storyUsername: _ownerData.username!,
                      ),
                    ));
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
                                      ? NetworkImage(
                                          _storyModelList[index].image!)
                                      : const AssetImage(
                                              'assets/images/cover.jpg')
                                          as ImageProvider<Object>,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text(_userStoryDataList[index].username!),
                  ],
                ),
              ),
            ),
            itemCount: _storyModelList.length,
          ),
        );
      },
    );
  }
}
