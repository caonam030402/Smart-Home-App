import 'package:flutter/material.dart';
import 'package:smart_home/components/card_device.dart';
import 'package:smart_home/constants/path_icons.dart';

class ListDevices extends StatelessWidget {
  const ListDevices({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return CardDevice(
          icon: device.icon,
          isOnToDB: device.isOnToDB,
          nameDevice: device.name,
        );
      },
    );
  }
}

class Device {
  final String icon;
  final bool isOnToDB;
  final String name;

  Device({required this.icon, required this.isOnToDB, required this.name});
}

List<Device> devices = [
  Device(icon: PathIcons.ic_voice, isOnToDB: false, name: 'Lighting'),
  Device(icon: PathIcons.ic_voice, isOnToDB: true, name: 'Another Device'),
  Device(icon: PathIcons.ic_voice, isOnToDB: true, name: 'Another Device'),
  Device(icon: PathIcons.ic_voice, isOnToDB: true, name: 'Another Device'),

  // Thêm các thiết bị khác vào đây
];
