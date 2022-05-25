import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/logic/cubits/story_cubit.dart';
import 'package:social_app/logic/states/story_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';

class StorySceen extends StatefulWidget {
  const StorySceen({
    Key? key,
    required this.storyId,
    required this.storyUsername,
    required this.storyDate,
  }) : super(key: key);

  final String storyId;
  final String storyUsername;
  final Timestamp storyDate;

  @override
  State<StorySceen> createState() => _StorySceenState();
}

class _StorySceenState extends State<StorySceen> {
  final StoryController _controller = StoryController();

  @override
  void initState() {
    StoryCubit.get(context).getStoryData(widget.storyId);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  BlocProvider(
        //   create: (context) => StoryCubit()..getStoryData(widget.id),
        //   child:
        BlocConsumer<StoryCubit, StoryStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final _cubit = StoryCubit.get(context);
              final _data = _cubit.storyDataList;
              return Scaffold(
                // backgroundColor: Colors.grey,
                body: (state is GetStoryDataLoadingState)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height / 1.1,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0.w, right: 15.0.w, top: 100.0.h),
                              child: StoryView(
                                storyItems: _data.map((element) {
                                  // int index = _data.indexOf(element);
                                  if (element.hasMedia) {
                                    return StoryItem.inlineProviderImage(
                                      NetworkImage(element.image!),
                                      roundedTop: false,
                                      caption: Text(
                                        element.caption!,
                                      ),
                                    );
                                  } else {
                                    return StoryItem.text(
                                      title: element.text!,
                                      backgroundColor: Colors.blue,
                                    );
                                  }
                                }).toList(),
                                controller: _controller,
                                repeat: true,
                                onComplete: () {
                                  log("s com");
                                },
                                onStoryShow: (s) {
                                  log("s show");
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0.w, vertical: 30.0.h),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: AppConstant.circleAvataRad,
                                  ),
                                  //ToDO...............
                                  title: Text(widget.storyUsername),
                                  subtitle: Text(
                                    AppConstant.dateFormat.format(
                                      widget.storyDate.toDate(),
                                    ),
                                  ),

                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const FaIcon(AppConstant.xIcon)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            });
    // ,
    // );
  }
}
