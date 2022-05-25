import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/comments_cubit.dart';
import 'package:social_app/logic/cubits/notification_cubit.dart';
import 'package:social_app/logic/states/comments_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/text_field.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    Key? key,
    required this.postId,
    required this.commentOwnerId,
    required this.commentOwnerImage,
    required this.commentOwnerUsername,
  }) : super(key: key);
  final String postId;
  final String commentOwnerId;
  final String commentOwnerImage;
  final String commentOwnerUsername;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  void dispose() {
    // _commentController.dispose();
    // _searchController.dispose();
    _searchController.clear();
    _commentController.clear();
    super.dispose();
  }

  final _commentController = TextEditingController();

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentsCubits>.value(
      value: CommentsCubits.get(context)..getPostComments(widget.postId),
      child: BlocConsumer<CommentsCubits, CommentsStates>(
          listener: (context, state) {
        if (state is AddCommentsSuccesState) {
          // NotificationCubit.get(context).addNotification(
          //   NotifiactionType.comment,
          //   notData: _commentController.text
          // );
          NotificationCubit.get(context).addNotification(
              NotifiactionType.comment,
              notData: _commentController.text);
        }
      }, builder: (context, state) {
        final _data = CommentsCubits.get(context).commentsModelList;
        final _cubit = CommentsCubits.get(context);

        // if (_data != null || State is GetCommentsLoadingState) {
        //   print("data = $_data");
        // }
        // else if()
        if (state is AddCommentsLoadingState) {
          return Scaffold(
            // backgroundColor: Colors.red,
            body:

                //  const Center(
                //   child: CircularProgressIndicator(),
                // ),
                Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, 'Posting....'),
                    style: TextStyle(fontSize: 25.0.sp),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: (_data == null)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 50.0.h, horizontal: 15.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.0.h),
                            Text(
                                "${getTranslated(context, 'Comments')}:  ${_data.length}",
                                style: Theme.of(context).textTheme.headline4),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0.h),
                              child: BuildTextFormField(
                                labelText: getTranslated(context, 'Search'),
                                radiuas: 10.0.r,
                                validator: (val) {},
                                prefixIcon:
                                    const FaIcon(FontAwesomeIcons.search),
                                controller: _searchController,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _data.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        backgroundImage: NetworkImage(
                                            _data[index].commentOwnerImage),
                                      ),
                                      title: Text(
                                          _data[index].commentOwnerUsername),
                                      subtitle: Text(
                                        AppConstant.dateFormat.format(
                                          _data[index].commentTime.toDate(),
                                        ),
                                      ),
                                      trailing:
                                          const FaIcon(FontAwesomeIcons.cog),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0.h),
                                      child: Container(
                                        width: double.infinity,
                                        alignment: (AppConstant.align == "Left")
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                        child: Text(
                                          _data[index].comment,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 50.0.h,
                        padding: EdgeInsets.all(10.0.h),
                        color: Colors.grey[800],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200.w,
                              child: TextFormField(
                                // maxLines: 3,
                                controller: _commentController,
                                onTap: () {},
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: getTranslated(
                                      context, 'Write_a_comment!'),
                                  hintStyle: TextStyle(
                                      fontSize: 15.0.sp,
                                      color: (AppConstant.mode == true)
                                          ? AppTheme.black
                                          : AppTheme.white),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.paperPlane),
                              color: (AppConstant.mode == true)
                                  ? AppTheme.black
                                  : AppTheme.white,
                              iconSize: 20.0.sp,
                              onPressed: () {
                                _cubit.addComment(
                                  postId: widget.postId,
                                  comment: _commentController.text,
                                  commentOwnerId: widget.commentOwnerId,
                                  commentOwnerImage: widget.commentOwnerImage,
                                  commentOwnerUsername:
                                      widget.commentOwnerUsername,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
