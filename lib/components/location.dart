import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_text.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Chuyển đổi vị trí thành địa chỉ
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Lấy địa chỉ từ danh sách placemarks
      Placemark place = placemarks[0];
      String currentAddress = "${place.administrativeArea}, ${place.country}";

      // Cập nhật trạng thái của _currentAddress
      setState(() {
        _currentAddress = currentAddress;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_currentAddress ?? '',
        style: AppText.small.copyWith(
          color: AppColors.white,
        ));
  }
}
