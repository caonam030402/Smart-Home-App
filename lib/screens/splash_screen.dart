import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/constants/path_routes.dart';
import 'package:smart_home/screens/main_screen.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      GoRouter.of(context).go(PathRoute.main);
    });

    return AnimatedSplashScreen(
      centered: true,
      splashIconSize: double.infinity,
      splash: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Center(
                  child: SvgPicture.asset(
                PathIcons.ic_logo,
                height: 100,
                color: AppColors.primary,
              )),
            ),
            Text(
              'Smart Home',
              style: AppText.heading3.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ],
        ),
      ),
      nextScreen: MainScreen(),
    );
  }
}
