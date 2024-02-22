import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_home/components/circle_color_picker.dart';
import 'package:smart_home/components/light_adjustment_bar.dart';
import 'package:smart_home/components/tool_bar.dart';
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
  late List<bool> isSelected; // Danh sách lưu trữ trạng thái của mỗi màu
  final GlobalKey<SlideActionState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    currentColor = Colors.blue; // Set initial color
    _controller = CircleColorPickerController(initialColor: currentColor);
    isSelected = List.generate(
        colors.length, (index) => false); // Khởi tạo isSelected trong initState
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
    print(_controller.color);
    return Scaffold(
      appBar: ToolBar(title: 'Activity Tracker'),
      body: Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < colors.length; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentColor = colors[i];
                                _controller.color = currentColor;
                                for (var j = 0; j < isSelected.length; j++) {
                                  isSelected[j] = (j == i);
                                }
                              });
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: colors[i],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: isSelected[i]
                                      ? Colors.black
                                      : Colors
                                          .transparent, // Thêm border nếu màu được chọn
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Spacer(),
                    SlideAction(
                      key: _key,
                      onSubmit: () {},
                      sliderButtonIcon: const Icon(
                        Icons.turn_left,
                        color: AppColors.white,
                      ),
                      outerColor: AppColors.greyLight.withOpacity(0.4),
                      innerColor: AppColors.primary,
                      elevation: 0,
                      child: Text(
                        'Slide to power Off',
                        style: AppText.large
                            .copyWith(color: AppColors.black.withOpacity(0.5)),
                      ),
                      submittedIcon: const Icon(
                        Icons.done,
                        size: 30,
                        color: AppColors.white,
                      ),
                    ),
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
    );
  }
}
