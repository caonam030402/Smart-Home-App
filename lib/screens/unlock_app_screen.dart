import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_home/components/pass_code.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/constants/path_images.dart';
import 'package:smart_home/constants/path_routes.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
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
      bool authenticated = await auth.authenticate(
          authMessages: Iterable.empty(),
          localizedReason: 'Vui lòng xác thực nó',
          options: AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      print(authenticated);
      if (authenticated) {
        context.go(PathRoute.main);
      }
    } catch (e) {
      print(e);
    }
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
                      height: 40,
                    ),
                    Image.asset(PathImage.im_home_art, height: 200),

                    Text('Welcome Back !',
                        style: AppText.heading1.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 40)),
                    // Text(
                    //   'Smart Home',
                    //   style: AppText.medium.copyWith(color: AppColors.white),
                    // ),
                    Text(
                      'Unlock with passcode',
                      style: AppText.large.copyWith(color: AppColors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          PassCode(),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 60,
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              'Submit',
                              style: AppText.large
                                  .copyWith(color: AppColors.white),
                            )),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.white, width: 2),
                                color: AppColors.white.withOpacity(0),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Or you unlock with Fingerprint',
                      style: AppText.large.copyWith(color: AppColors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
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
                              height: 70,
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
