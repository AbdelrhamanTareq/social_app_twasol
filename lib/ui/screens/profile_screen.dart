import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/follow_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/logic/states/follow_states.dart';
import 'package:social_app/logic/states/posts_states.dart';
import 'package:social_app/logic/states/story_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/routes/route.dart';

import 'package:social_app/ui/screens/edit_profile_screen.dart';

import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/count_column_widget.dart';
import 'package:social_app/ui/widgets/post_widget.dart';
import 'package:social_app/ui/widgets/text_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.ownerId,
  }) : super(key: key);

  final String ownerId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // print("init state");
    // print("id = ${widget.ownerid} ");
    PostsCubits.get(context).getPostOwnerData(widget.ownerId);
    PostsCubits.get(context).getPostOwnerPosts(widget.ownerId);
    StoryCubit.get(context).getOwnerStories();
    FollowCubits.get(context).getPostOwnerFollowCount(widget.ownerId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //BlocProvider(
        // create: (_) => PostsCubits()
        //   ..getPostOwnerData(widget.ownerid)
        //   ..getPostOwnerPosts(widget.ownerid)
        //   ..getPostData(),
        // child:
        BlocConsumer<PostsCubits, PostsStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final _userData = PostsCubits.get(context).ownerData;
              final _postData = PostsCubits.get(context).postOwnerPosts;
              final _postsCount = PostsCubits.get(context).postOwnerPostsCount;
              final _likes = PostsCubits.get(context).likes;

              // print("postData = ${_likes}");
              return Scaffold(
                body: (
                        //state is GetPostOwnerDataLoadingState ||
                        // state is GetPostOwnerPostsLoadingState ||
                        _userData == null || _postData == [] || _likes == {})
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
                                    //  (_userData == null)
                                    //     ? Container()
                                    //     :
                                    Image.network(
                                  // coverImgUrl,
                                  _userData.coverImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 150.h),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: AppConstant.rad / 2),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0.r),
                                          color:
                                              // Colors.white
                                              Theme.of(context).canvasColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8.0.r,
                                              offset: Offset(0.0, 5.0.h),
                                            ),
                                          ],
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
                                                  _userData.username!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                  // TextStyle(
                                                  //     fontWeight: FontWeight.bold,
                                                  //     fontSize: 34.0.sp),
                                                  ),
                                              Text(
                                                  // email,
                                                  _userData.email!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                  // TextStyle(
                                                  //   fontSize: 13.sp,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  ),
                                              SizedBox(
                                                height: 30.0.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 32.0.w),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: BuildCountColumn(
                                                          text: getTranslated(
                                                              context, "Posts"),
                                                          count: _postsCount
                                                              .toString()),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: BlocBuilder<
                                                          FollowCubits,
                                                          FollowStates>(
                                                        builder:
                                                            (context, state) {
                                                          final int
                                                              _followerCount =
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
                                                                count: _followerCount
                                                                    .toString(),
                                                              ),
                                                              BuildCountColumn(
                                                                text: getTranslated(
                                                                    context,
                                                                    "Following"),
                                                                count: _followingCount
                                                                    .toString(),
                                                              ),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    BuildTextButton(
                                                      widget: TextButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          getTranslated(context,
                                                              "add_story"),
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .white),
                                                        ),
                                                      ),
                                                      width: 150.h,
                                                      height: 50.h,
                                                      // isGradiantColor: true,
                                                      color: AppTheme.red,
                                                    ),
                                                    BuildTextButton(
                                                      color:
                                                          AppTheme.accentColor,
                                                      widget: TextButton(
                                                        onPressed: () {
                                                          AppRoute.navTo(
                                                            context: context,
                                                            screenWidget: BlocProvider<
                                                                    PostsCubits>.value(
                                                                value: PostsCubits
                                                                    .get(
                                                                        context),
                                                                child:
                                                                    const EditProfileScreen()),
                                                          );
                                                        },
                                                        child: Text(
                                                          getTranslated(context,
                                                              "Edit_Profile"),
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .white),
                                                        ),
                                                      ),
                                                      width: 150.h,
                                                      height: 50.h,
                                                      // isGradiantColor: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              _buildOwnerStories(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.h,
                                                    horizontal: 0),
                                                child: BuildPostWidget(
                                                  // blocValue:
                                                  // PostsCubits.get(context),
                                                  data: _postData,
                                                  userData: _userData,
                                                  likes: _likes,
                                                  isOwnerScreen: true,
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
                                        color: Theme.of(context).canvasColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0.r,
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
                                            _userData.imageUrl!,
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
            );
  }

  BlocConsumer _buildOwnerStories() {
    final cubit = StoryCubit.get(context);
    return BlocConsumer<StoryCubit, StoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _ownerStoreies = cubit.ownerStoreies;
          if (state is GetOwnerStoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox(
            height: 140.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 15.w, right: 10.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: AppConstant.width,
                      height: 120.h,
                      child: Stack(
                        children: [
                          Container(
                            width: AppConstant.width,
                            height: AppConstant.contHeight,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0.r),
                              // color: Colors.red,
                              image: DecorationImage(
                                  image: (_ownerStoreies[index].image != "")
                                      ? NetworkImage(
                                          _ownerStoreies[index].image!)
                                      : const AssetImage(
                                              'assets/images/cover.jpg')
                                          as ImageProvider<Object>,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: _ownerStoreies.length,
            ),
          );
        });
  }

//   Column _buildColumn({required String text, required String count}) {
//     return Column(
//       children: <Widget>[
//         Text(
//           text,
//           style: Theme.of(context)
//               .textTheme
//               .headline6!
//               .copyWith(fontSize: 18.0.sp),
//         ),
//         Text(
//           count,
//           style: Theme.of(context)
//               .textTheme
//               .headline6!
//               .copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
}
