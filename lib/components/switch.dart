import 'package:flutter/material.dart';
import 'package:smart_home/styles/app_colors.dart';

class SwitchCustom extends StatefulWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const SwitchCustom({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  State<SwitchCustom> createState() => _SwitchCustomState();
}

class _SwitchCustomState extends State<SwitchCustom> {
  bool isActive = true;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      inactiveTrackColor: AppColors.white,
      inactiveThumbColor: AppColors.primary,
      trackOutlineWidth: MaterialStatePropertyAll(0),
      activeColor: AppColors.white,
      onChanged: widget.onChanged,
    );
  }
}
