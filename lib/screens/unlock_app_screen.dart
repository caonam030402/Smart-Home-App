import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/constants/path_images.dart';
import 'package:smart_home/constants/path_routes.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_text.dart';

class UnlockAppScreen extends StatefulWidget {
  const UnlockAppScreen({super.key});

  @override
  State<UnlockAppScreen> createState() => _UnlockAppScreenState();
}

class _UnlockAppScreenState extends State<UnlockAppScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) => (value) {
          setState(() {
            _supportState = value;
          });
        });
  }

  void _authenticate() async {
    try {
      _getAvailableBiometrics();
      bool authenticated = await auth.authenticate(
          authMessages: Iterable.empty(),
          localizedReason: 'Subrice',
          options: AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
    } catch (e) {}
  }

  void _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print(availableBiometrics);

    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.5),
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 238, 241, 242).withOpacity(0),
          ),
          Positioned(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text('Welcome back',
                        style: AppText.heading1.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 40)),
                    Text(
                      'Unlock with Fingerprint',
                      style: AppText.medium.copyWith(color: AppColors.white),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.black.withOpacity(0.1),
                            AppColors.black.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _authenticate,
                            child: SvgPicture.asset(
                              PathIcons.ic_touch_id,
                              height: 80,
                              color: AppColors.white,
                            ),
                          ),
                          // SizedBox(
                          //   height: 50,
                          // ),
                          // Text(
                          //   'OR',
                          //   style:
                          //       AppText.large.copyWith(color: AppColors.white),
                          // ),
                          // SizedBox(
                          //   height: 50,
                          // ),
                          // SvgPicture.asset(
                          //   height: 80,
                          //   PathIcons.ic_face_id,
                          //   color: AppColors.white,
                          // )
                        ],
                      ),
                    ),
                    Spacer(),
                    SlideAction(
                      onSubmit: () {
                        context.go(PathRoute.main);
                        return null;
                      },
                      sliderButtonIcon: const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.primary,
                      ),
                      outerColor: AppColors.primary,
                      innerColor: AppColors.white,
                      elevation: 0,
                      submittedIcon: const Icon(
                        Icons.done,
                        size: 30,
                        color: AppColors.white,
                      ),
                      child: Text(
                        'Mở khóa bằng mật khẩu',
                        style: AppText.medium.copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
