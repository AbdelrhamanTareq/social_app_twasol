import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:social_app/localiziation/localization_constant.dart';
import 'package:social_app/logic/cubits/search_cubit.dart';
import 'package:social_app/logic/states/search_states.dart';
import 'package:social_app/shared/app_constant.dart';
import 'package:social_app/ui/routes/route.dart';
import 'package:social_app/ui/screens/post_owner_profile.dart';
import 'package:social_app/ui/theme/app_theme.dart';
import 'package:social_app/ui/widgets/text_button.dart';
import 'package:social_app/ui/widgets/text_field.dart';

// enum SearchType { Post, People }

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  // late SearchType _searchType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubits, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _cubit = SearchCubits.get(context);
          final _searchType = SearchCubits.get(context).searchType;
          return DefaultTabController(
            length: 2,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 70.0.h, horizontal: 15.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: _key,
                          child: BuildTextFormField(
                            labelText: getTranslated(context, "Search"),
                            controller: _searchController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return getTranslated(context, "search_error");
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0.w),
                      BuildTextButton(
                        widget: IconButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              if (_searchType == SearchType.People) {
                                _cubit.searchPeaople(
                                    _searchController.text.trim());
                                return;
                              }
                              _cubit.searchPost(_searchController.text.trim());
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.search,
                            color: AppTheme.white,
                          ),
                        ),
                        width: 50.0.w,
                        height: 50.0.h,
                        isGradiantColor: true,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25.0.h,
                  ),
                  TabBar(
                    // labelStyle: Theme.of(context).textTheme.headline6,

                    onTap: (val) {
                      // print('val === $val');
                      // if (val == 0) {
                      //   _searchType = SearchType.People;
                      // }
                      // _searchType = SearchType.Post;
                      _cubit.getSearchType(val);
                    },
                    // unselectedLabelColor: Colors.black,
                    labelColor: Theme.of(context).textTheme.headline6!.color,
                    // labelStyle: TextStyle(color: Colors.black),
                    tabs: [
                      Tab(
                        text: getTranslated(context, "People"),
                      ),
                      Tab(
                        text: getTranslated(context, "Post"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildSearchPeopleWidget(context, state),
                        _buildSearchPostWidget(context, state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

// ToDo see why loading state in search doesnt come
// ToDo impelment search like and comment

_buildSearchPeopleWidget(BuildContext context, SearchStates state) {
  final _data = SearchCubits.get(context).userModelList;
  if (_data.isEmpty) {
    return Center(
      child: Text(getTranslated(context, "No_data_Start")),
    );
  } else if (state is SearchPeopleLoadingState) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ListView.separated(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          radius: AppConstant.circleAvataRad,
          backgroundColor: AppTheme.red,
          backgroundImage: NetworkImage(_data[index].imageUrl!),
        ),
        title: Text(_data[index].username!),
        trailing: const Icon(AppConstant.xIcon),
      ),
      itemCount: _data.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 10.0.h,
      ),
    );
  }
}

_buildSearchPostWidget(BuildContext context, SearchStates state) {
  final _data = SearchCubits.get(context).postModelList;
  if (_data.isEmpty) {
    return Center(
      child: Text(getTranslated(context, "No_data_Start")),
    );
  } else if (state is SearchPostLoadingState) {
    print("stateeeeeeeeeeeeeeeee");
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: InkWell(
              onTap: () {
                AppRoute.navTo(
                  context: context,
                  screenWidget: PostOwnerProfile(
                    ownerId: _data[index].ownerId!,
                  ),
                );
              },
              child: CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage(_data[index].userImage ?? ""),
              ),
            ),
            title: Text(
              _data[index].username!,
              style: TextStyle(color: AppTheme.black),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.globe,
                  size: 13.sp,
                  color: AppTheme.grey,
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
              // color: Colors.red,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: Text(
              _data[index].postText!,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          FullScreenWidget(
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: 400.h,
                // color: Colors.grey,

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
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Text(
                  // "likeb by rebacca_jane and ${PostsCubits.get(context).likeCountMap[_data[index].id]} others",
                  ""
                  // textAlign: TextAlign.left,
                  ),
            ),
          ),
          // SizedBox(height: 5.h),
          Row(
            // mainAxisAlignment:
            // MainAxisAlignment.spaceBetween,
            children: [
              // IconButton(
              //   onPressed: () {
              //     // PostsCubits.get(context).addOrRemoveLike(
              //     //   userId: _userData.uid!,
              //     //   ownerId: _data[index].ownerId!,
              //     //   postId: _data[index].id!,
              //     // );
              //   },
              //   icon: FaIcon(
              //     _likes[_data[index].id][_userData.uid] ?? false
              //         ? FontAwesomeIcons.solidHeart
              //         : FontAwesomeIcons.heart,
              //     color: _likes[_data[index].id][_userData.uid] ?? false
              //         ? Colors.red
              //         : Colors.black,
              //   ),
              // ),
              SizedBox(width: 7.w),
              IconButton(
                onPressed: () {
                  // AppRoute.navTo(
                  //   context: context,
                  //   screenWidget: CommentsScreen(
                  //     postId: _data[index].id!,
                  //     commentOwnerId: _userData.uid!,
                  //     commentOwnerImage: _userData.imageUrl!,
                  //     commentOwnerUsername: _userData.username!,
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
      itemCount: _data.length,
    );
  }
}
