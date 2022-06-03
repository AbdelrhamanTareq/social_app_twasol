import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:social_app/data/models/post_model.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/comments_cubit.dart';
import 'package:social_app/logic/cubits/follow_cubit.dart';
import 'package:social_app/logic/cubits/notification_cubit.dart';
import 'package:social_app/logic/cubits/posts_cubit.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/routes/route.dart';
import 'package:social_app/ui/screens/comments_screen.dart';
import 'package:social_app/ui/screens/post_owner_profile.dart';
import 'package:social_app/ui/theme/app_theme.dart';

class BuildPostWidget extends StatelessWidget {
  const BuildPostWidget({
    Key? key,
    required List<PostModel> data,
    required UserModel userData,
    required Map<String, dynamic> likes,
    required bool isOwnerScreen,
    // required PostsCubits blocValue,
  })  : _data = data,
        _userData = userData,
        _likes = likes,
        _isOwnerScreen = isOwnerScreen,
        // _blocValue = blocValue,
        super(key: key);

  final List<PostModel> _data;
  final UserModel _userData;
  final Map<String, dynamic> _likes;
  final bool _isOwnerScreen;
  // final PostsCubits _blocValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.zero,
      color: AppTheme.grey,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.only(bottom: 3.0.h),
          // elevation: 100,
          // shadowColor: Colors.black54,
          color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8.0.w),
                leading: InkWell(
                  onTap: () {
                    if (!_isOwnerScreen) {
                      AppRoute.navToWithName(
                          context: context,
                          screenName: '/post_owner_proifle',
                          arguments: _data[index].ownerId!);
                      // AppRoute.navTo(
                      //   context: context,
                      //   screenWidget: Builder(builder: (_) {
                      //     return MultiBlocProvider(
                      //       providers: [
                      //         BlocProvider<PostsCubits>.value(
                      //           value: PostsCubits.get(context),
                      //         ),
                      //         BlocProvider<StoryCubit>.value(
                      //           value: StoryCubit.get(context),
                      //         ),
                      //         BlocProvider<FollowCubits>.value(
                      //           value: FollowCubits.get(context),
                      //         ),
                      //         BlocProvider<NotificationCubit>.value(
                      //           value: NotificationCubit.get(context),
                      //         ),
                      //       ],
                      //       child: PostOwnerProfile(
                      //         ownerId: _data[index].ownerId!,
                      //       ),
                      //     );
                      //     // return BlocProvider<PostsCubits>.value(
                      //     //   value: _blocValue,
                      //     //   child: PostOwnerProfile(
                      //     //     ownerid: _data[index].ownerId!,
                      //     //   ),
                      //     // );
                      //   }),
                      // );
                    }
                  },
                  child: CircleAvatar(
                    radius: 25.0.r,
                    backgroundColor: Colors.amber,
                    backgroundImage: NetworkImage(_data[index].userImage ?? ""),
                  ),
                ),
                title: Text(
                  _data[index].username!,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.globe,
                      size: 13.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      AppConstant.dateFormat.format(
                        _data[index].dateTime!.toDate(),
                      ),
                      style: TextStyle(color: AppTheme.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.ellipsisH),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0.w),
                alignment: (AppConstant.align == "Left")
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                width: double.infinity,
                child: Text(
                  _data[index].postText!,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              if (_data[index].postImage != null)
                FullScreenWidget(
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 400.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                        child: Hero(
                          tag: '${_data[index].id!}+$index',
                          child: Image.network(
                            _data[index].postImage ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.0.w),
                child: Container(
                  width: double.infinity,
                  alignment: (AppConstant.align == "Left")
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    // ToDo adjust like database
                    "${getTranslated(context, "likeb_by")} ${PostsCubits.get(context).likeCountMap[_data[index].id]}",
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      PostsCubits.get(context).addOrRemoveLike(
                        userId: _userData.uid!,
                        ownerId: _data[index].ownerId!,
                        postId: _data[index].id!,
                      );
                    },
                    icon: FaIcon(
                      _likes[_data[index].id][_userData.uid] ?? false
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: _likes[_data[index].id][_userData.uid] ?? false
                          ? Colors.red
                          : Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  IconButton(
                    onPressed: () {
                      AppRoute.navToWithName(
                          context: context,
                          screenName: '/comments',
                          arguments: {
                            "postId": _data[index].id!,
                            "commentOwnerId": _userData.uid!,
                            "commentOwnerImage": _userData.imageUrl!,
                            "commentOwnerUsername": _userData.username!,
                          });
                      // AppRoute.navTo(
                      //   context: context,
                      //   screenWidget: MultiBlocProvider(
                      //     providers: [
                      //       BlocProvider<CommentsCubits>.value(
                      //         value: CommentsCubits.get(context),
                      //       ),
                      //       BlocProvider.value(
                      //         value: NotificationCubit.get(context),
                      //       ),
                      //     ],
                      //     child: CommentsScreen(
                      //       postId: _data[index].id!,
                      //       commentOwnerId: _userData.uid!,
                      //       commentOwnerImage: _userData.imageUrl!,
                      //       commentOwnerUsername: _userData.username!,
                      //     ),
                      //   ),
                      // );
                    },
                    icon: const FaIcon(FontAwesomeIcons.comment),
                  ),
                  SizedBox(width: 7.w),
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.paperPlane),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.bookmark),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
        itemCount: _data.length,
      ),
    );
  }
}
