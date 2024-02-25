import 'package:blur/blur.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/components/circle_color_picker.dart';
import 'package:smart_home/components/tool_bar.dart';
import 'package:smart_home/constants/path_images.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
import 'package:smart_home/styles/app_text.dart';

class LightManagementScreen extends StatefulWidget {
  const LightManagementScreen({Key? key}) : super(key: key);

  @override
  State<LightManagementScreen> createState() => _LightManagementScreenState();
}

class _LightManagementScreenState extends State<LightManagementScreen> {
  late CircleColorPickerController _controller;
  late Color currentColor;
  late bool isOnLight;
  double brightness = 50;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isOnLight = true;
    currentColor = Colors.blue;
    _controller = CircleColorPickerController(initialColor: currentColor);
    isSelected = List.generate(colors.length, (index) => false);
  }

  List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref("");

    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data is Map && data.containsKey('light_control')) {
        final lightControl = data['light_control'];
        if (lightControl is Map && lightControl.containsKey('status')) {
          setState(() {
            isOnLight = lightControl['status'];
          });
        }
      }
    });

    return Scaffold(
      appBar: ToolBar(
          title: 'Light',
          action: Switch(
            inactiveTrackColor: AppColors.white,
            inactiveThumbColor: AppColors.primary,
            trackOutlineWidth: const MaterialStatePropertyAll(0),
            activeColor: AppColors.primary,
            value: isOnLight,
            onChanged: (value) {
              setState(() {
                isOnLight = value;
              });
              databaseReference.update({"light_control/status": value});
            },
          )),
      body: Stack(
        children: [
          Image.asset(PathImage.im_home,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover)
              .blurred(
            colorOpacity: 0.1,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(5)),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 238, 241, 242).withOpacity(0.7),
          ),
          Stack(children: [
            Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: CircleColorPicker(
                    controller: _controller,
                    onChanged: (color) {
                      setState(() => currentColor = color);
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.paddingBothSidesPage),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Popular Presets',
                          style: AppText.large,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 0; i < colors.length; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    databaseReference.update(
                                      {
                                        "light_control/colors/": {
                                          "blue": _controller.color.blue,
                                          "red": _controller.color.red,
                                          "green": _controller.color.green
                                        }
                                      },
                                    );
                                    currentColor = colors[i];
                                    _controller.color = currentColor;
                                    for (var j = 0;
                                        j < isSelected.length;
                                        j++) {
                                      isSelected[j] = (j == i);
                                    }
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 55,
                                    ),
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: colors[i],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                    ),
                                    Positioned(
                                        right: 0,
                                        left: 0,
                                        bottom: 0,
                                        child: isSelected[i]
                                            ? Icon(
                                                Icons.arrow_drop_up,
                                                color: colors[i],
                                              )
                                            : Container())
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Brightness',
                          style: AppText.large,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.light_mode,
                              size: 18,
                            ),
                            Expanded(
                              child: Slider(
                                inactiveColor: AppColors.black.withOpacity(0.2),
                                activeColor: AppColors.white,
                                thumbColor: AppColors.primary,
                                value: brightness,
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    brightness = value;
                                  });
                                },
                              ),
                            ),
                            const Text('50%')
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(
                          height: AppStyles.paddingBothSidesPage,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              child: !isOnLight
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppColors.greyLight.withOpacity(0.8))
                  : Container(),
            ),
            //   Positioned(
            //     left: 0,
            //     right: 0,
            //     bottom: 0,
            //     child: Padding(
            //       padding: EdgeInsets.all(AppStyles.paddingBothSidesPage),
            //       child: SlideAction(
            //         reversed: !isOnLight,
            //         alignment: Alignment.center,
            //         key: _key,
            //         onSubmit: () {
            //           databaseReference
            //               .update({"light_control/status": !isOnLight});
            //           setState(() {
            //             !isOnLight == true
            //                 ? isOnLight = false
            //                 : isOnLight = true;
            //           });
            //         },
            //         sliderButtonIcon: SvgPicture.asset(
            //           PathIcons.ic_power,
            //           height: 25,
            //           color: !isOnLight
            //               ? AppColors.primary.withOpacity(1)
            //               : AppColors.white.withOpacity(0.8),
            //         ),
            //         outerColor: !isOnLight
            //             ? AppColors.primary.withOpacity(1)
            //             : AppColors.white.withOpacity(1),
            //         innerColor: !isOnLight
            //             ? AppColors.white.withOpacity(1)
            //             : AppColors.black.withOpacity(0.8),
            //         elevation: 0,
            //         child: Text(
            //           !isOnLight ? 'Light On' : 'Light Off',
            //           style: AppText.large.copyWith(
            //               color: !isOnLight
            //                   ? AppColors.white.withOpacity(1)
            //                   : AppColors.black.withOpacity(0.5)),
            //         ),
            //         submittedIcon: const Icon(
            //           Icons.done,
            //           size: 30,
            //           color: AppColors.black,
            //         ),5
            //       ),2
            //     ),5555
            //   )
            // ],
          ])
        ],
      ),
    );
  }
}
