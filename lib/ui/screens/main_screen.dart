import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_app/logic/cubits/home_cubit.dart';
import 'package:social_app/logic/cubits/internet_connection_cubit.dart';

import 'package:social_app/logic/states/home_states.dart';
import 'package:social_app/logic/states/internet_connection_states.dart';

import 'package:social_app/ui/widgets/bottom_nav_icon.dart';
import '../widgets/error_widget.dart' as err;

class MainScreen1 extends StatelessWidget {
  const MainScreen1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubits, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _homeCubit = HomeCubits.get(context);
          return BlocBuilder<ConnectionCubit, InternectConnectionState>(
              builder: (context, state) {
            final _isConnected =
                BlocProvider.of<ConnectionCubit>(context).isConnected ?? false;
            if (state is NoInternetState && _isConnected == false) {
              return const err.ErrorWidget();
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: _homeCubit.screens[_homeCubit.currentIndex],
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _homeCubit.currentIndex,
                    onTap: (int index) {
                      _homeCubit.changeIndex(index);
                    },
                    items: [
                      bottomNavIcon(
                        icon: FontAwesomeIcons.home,
                        activeColor: Colors.purple[50]!,
                      ),
                      bottomNavIcon(
                        icon: FontAwesomeIcons.search,
                        activeColor: Colors.purple[50]!,
                      ),
                      bottomNavIcon(
                        icon: FontAwesomeIcons.plus,
                        activeColor: Colors.purple[50]!,
                      ),
                      bottomNavIcon(
                        icon: FontAwesomeIcons.bell,
                        activeColor: Colors.purple[50]!,
                      ),
                      bottomNavIcon(
                        icon: FontAwesomeIcons.userAlt,
                        activeColor: Colors.purple[50]!,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
