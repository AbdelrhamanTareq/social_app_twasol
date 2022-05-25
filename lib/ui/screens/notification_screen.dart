import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/data/models/notification_model.dart';
import 'package:social_app/data/models/user_model.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/notification_cubit.dart';
import 'package:social_app/logic/states/notification_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/widgets/header_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  // void initState() {
  //   NotificationCubit.get(context).getNotificationData(id);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotifiactionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _cubit = NotificationCubit.get(context);
          final List<NotificationModel> _data = _cubit.notificationsList;
          final List<UserModel> _userData = _cubit.userList;
          return SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 40.0.h, horizontal: 20.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    headerText: getTranslated(context, "Notification"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 20.0.r,
                              backgroundImage:
                                  NetworkImage(_userData[index].imageUrl!),
                            ),
                            title: Row(
                              children: [
                                Text(_userData[index].username!),
                                _getFollowTypeText(_data[index].type, context),
                                // Text(
                                //   "${_data[index].type} ${getTranslated(context, 'your_post')}",
                                //   style: TextStyle(color: AppTheme.grey),
                                // ),
                              ],
                            ),
                            subtitle: Text(
                              AppConstant.dateFormat.format(
                                (_data[index].dateTime)!.toDate(),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(color: Colors.grey);
                        },
                        itemCount: _data.length),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Text _getFollowTypeText(String type, BuildContext context) {
    if (type == "like") {
      return Text(
          "${getTranslated(context, 'like')} ${getTranslated(context, 'your_post')}");
    } else if (type == "comment") {
      return Text(
          "${getTranslated(context, 'comment')} ${getTranslated(context, 'on_your_post')}");
    } else {
      return Text("${getTranslated(context, 'start_following_you')} ");
    }
  }
}
