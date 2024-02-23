import 'package:blur/blur.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_home/components/circle_color_picker.dart';
import 'package:smart_home/components/light_adjustment_bar.dart';
import 'package:smart_home/components/tool_bar.dart';
import 'package:smart_home/constants/path_icons.dart';
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
  double brightness = 50;
  late List<bool> isSelected;
  final GlobalKey<SlideActionState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      appBar: ToolBar(title: 'Light'),
      body: Stack(
        children: [
          Image.asset(PathImage.im_home,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover)
              .blurred(
            colorOpacity: 0.1,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromARGB(255, 238, 241, 242).withOpacity(0.7),
          ),
          StreamBuilder(
            stream: databaseReference.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              final dynamic rawData = snapshot.data!.snapshot.value;

              if (rawData == null || !(rawData is Map)) {
                return Text('Data is not available or invalid.');
              }

              final lightControlData = rawData['light_control'];

              bool isOnLight = false;

              if (lightControlData is Map) {
                isOnLight = lightControlData['status'] ?? false;
              }

              return Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Center(
                          child: CircleColorPicker(
                            controller: _controller,
                            onChanged: (color) {
                              setState(() => currentColor = color);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppStyles.paddingBothSidesPage),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Popular Presets',
                                  style: AppText.large,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (var i = 0; i < colors.length; i++)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
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
                                                borderRadius: BorderRadius.all(
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
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
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
                                        inactiveColor:
                                            AppColors.black.withOpacity(0.2),
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
                                    Text('50%')
                                  ],
                                ),
                                Spacer(),
                                SizedBox(
                                  height: AppStyles.paddingBothSidesPage,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: !isOnLight
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: AppColors.greyLight.withOpacity(0.8))
                        : Container(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.all(AppStyles.paddingBothSidesPage),
                      child: SlideAction(
                        reversed: !isOnLight,
                        alignment: Alignment.center,
                        key: _key,
                        onSubmit: () {
                          databaseReference
                              .update({"light_control/status": !isOnLight});
                          setState(() {
                            !isOnLight == true
                                ? isOnLight = false
                                : isOnLight = true;
                          });
                        },
                        sliderButtonIcon: SvgPicture.asset(
                          PathIcons.ic_power,
                          height: 25,
                          color: !isOnLight
                              ? AppColors.primary.withOpacity(1)
                              : AppColors.white.withOpacity(0.8),
                        ),
                        outerColor: !isOnLight
                            ? AppColors.primary.withOpacity(1)
                            : AppColors.white.withOpacity(1),
                        innerColor: !isOnLight
                            ? AppColors.white.withOpacity(1)
                            : AppColors.black.withOpacity(0.8),
                        elevation: 0,
                        child: Text(
                          !isOnLight ? 'Light On' : 'Light Off',
                          style: AppText.large.copyWith(
                              color: !isOnLight
                                  ? AppColors.white.withOpacity(1)
                                  : AppColors.black.withOpacity(0.5)),
                        ),
                        submittedIcon: const Icon(
                          Icons.done,
                          size: 30,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
