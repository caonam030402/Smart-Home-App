import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/constants/path_images.dart';
import 'package:smart_home/constants/path_routes.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
import 'package:smart_home/styles/app_text.dart';
import 'package:slide_to_act/slide_to_act.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionState> _key = GlobalKey();
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(PathImage.im_home,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppStyles.paddingBothSidesPage),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      PathIcons.ic_logo,
                      color: AppColors.primary,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Smart',
                      style: AppText.heading4.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ' Home',
                      style: AppText.heading4.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Easier Life With Smart Home',
                  style: TextStyle(
                      fontSize: 50,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Explore our app's onboarding screen for a smooth start. Discover features quickly and begin your smart home journey hassle-free. Let's get started!",
                  style: AppText.medium.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.w400),
                ),
                Spacer(),
                SlideAction(
                  key: _key,
                  onSubmit: () {
                    // Future.delayed(
                    //   Duration(seconds: 1),
                    //   () => _key.currentState!.activate(),
                    // );
                    context.go(PathRoute.main);
                  },
                  sliderButtonIcon: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.primary,
                  ),
                  outerColor: AppColors.primary,
                  innerColor: AppColors.white,
                  elevation: 0,
                  child: Text(
                    'Start',
                    style: AppText.heading4.copyWith(color: AppColors.white),
                  ),
                  submittedIcon: Icon(
                    Icons.done,
                    size: 30,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
