import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/constants/path_routes.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      GoRouter.of(context).go(PathRoute.onboarding);
    });
    return AnimatedSplashScreen(
      centered: true,
      splashIconSize: double.infinity,
      splash: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Center(
                child: SvgPicture.asset(
                  PathIcons.ic_logo,
                  height: 70,
                  color: AppColors.primary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Smart',
                  style: AppText.heading2.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                Text(
                  ' Home',
                  style: AppText.heading2.copyWith(
                      color: AppColors.black, fontWeight: FontWeight.w600),
                )
              ],
            ),
            Text(
              'Love Your Home',
              style: AppText.small.copyWith(
                  color: AppColors.black, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      nextScreen: Container(),
    );
  }
}
