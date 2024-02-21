import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home/components/switch.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_text.dart';

class CardDevice extends StatefulWidget {
  final icon;
  final nameDevice;
  final isOnToDB;

  const CardDevice({super.key, this.icon, this.nameDevice, this.isOnToDB});

  @override
  State<CardDevice> createState() => _CardDeviceState();
}

class _CardDeviceState extends State<CardDevice> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isOnToDB ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.greyLight.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(
                0.0,
                0.0,
              ),
            )
          ],
          gradient: LinearGradient(
            colors: [
              !isActive
                  ? AppColors.white.withOpacity(1)
                  : AppColors.primary.withOpacity(0.5),
              !isActive
                  ? AppColors.white.withOpacity(1)
                  : AppColors.primary.withOpacity(0.9)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100)),
                child: SvgPicture.asset(
                  widget.icon ?? PathIcons.ic_voice,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.wifi_2_bar_outlined,
                size: 30,
                color: isActive
                    ? AppColors.white
                    : AppColors.black.withOpacity(0.7),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.nameDevice ?? '',
                  style: AppText.large.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppColors.white
                        : AppColors.black.withOpacity(0.7),
                  )),
              Text(
                '1 Device',
                style: AppText.small.copyWith(
                  color: isActive
                      ? AppColors.white
                      : AppColors.black.withOpacity(0.7),
                ),
              )
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(isActive ? 'On' : 'Off',
                  style: TextStyle(
                    color: isActive
                        ? AppColors.white
                        : AppColors.black.withOpacity(0.7),
                  )),
              const Spacer(),
              SwitchCustom(
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
                value: isActive,
              )
            ],
          )
        ],
      ),
    );
  }
}
