import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home/screens/main_screen.dart';
import 'package:smart_home/styles/app_colors.dart';

class BottomNavigationItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Menus index;
  final Menus name;
  final String icon;
  final String iconActive;

  const BottomNavigationItem(
      {super.key,
      required this.onPressed,
      required this.index,
      required this.name,
      required this.icon,
      required this.iconActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        index == name ? iconActive : icon,
        colorFilter: ColorFilter.mode(
            index == name ? AppColors.primary : AppColors.black,
            BlendMode.srcIn),
      ),
    ));
  }
}
