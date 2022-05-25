import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/ui/theme/app_theme.dart';

BottomNavigationBarItem bottomNavIcon({
  required IconData icon,
  required Color activeColor,
}) {
  return BottomNavigationBarItem(
    icon: FaIcon(
      icon,
      color: activeColor,
    ),
    label: "",
    activeIcon: ShaderMask(
      child: FaIcon(
        icon,
        color: Colors.white,
      ),
      shaderCallback: (Rect boundes) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[AppTheme.primaryColor, AppTheme.accentColor],
          // tileMode: TileMode.repeated,
        ).createShader(boundes);
      },
    ),
  );
}
