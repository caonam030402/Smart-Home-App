import 'package:flutter/material.dart';

Color argbToSRGB(argbColor) {
  int alpha = (argbColor >> 24) & 0xFF;
  int red = (argbColor >> 16) & 0xFF;
  int green = (argbColor >> 8) & 0xFF;
  int blue = argbColor & 0xFF;

  return Color.fromARGB(alpha, red, green, blue);
}
