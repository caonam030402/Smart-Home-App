import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smart_home/components/card_device.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/styles/app_colors.dart';

class ListDevices extends StatelessWidget {
  const ListDevices({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref("");

    return StreamBuilder(
      stream: databaseReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final dynamic rawData = snapshot.data!.snapshot.value;

        if (rawData == null || !(rawData is Map)) {
          return Text('Data is not available or invalid.');
        }

        final fanControlData = rawData['fan_control'];
        final lightControlData = rawData['light_control'];

        bool isOnFan = false;
        bool isOnLight = false;

        if (fanControlData is Map && lightControlData is Map) {
          isOnFan = fanControlData['status'] ?? false;
          isOnLight = lightControlData['status'] ?? false;

          List<Device> devices = [
            Device(
                icon: PathIcons.ic_voice,
                isOnToDB: isOnLight,
                name: 'Lighting'),
            Device(icon: PathIcons.ic_voice, isOnToDB: isOnFan, name: 'Fan'),
          ];

          return Skeletonizer(
            enabled: false,
            effect: ShimmerEffect(highlightColor: AppColors.primary),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
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
            ),
          );
        }
        return Container();
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
