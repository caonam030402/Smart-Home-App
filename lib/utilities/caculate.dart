import 'dart:math' as math;

double calculateSensibleTemperature(num temperature, num humidity) {
  // Constants for the calculation (valid for temperatures in Celsius)
  final double a = 17.27;
  final double b = 237.7;

  // Calculate the saturation vapor pressure (e) and actual vapor pressure (es)
  final double es = 6.112 * (math.exp((a * temperature) / (b + temperature)));
  final double e = (humidity / 100) * es;

  // Calculate the dew point temperature (Td)
  final double Td = (b * (math.log(e / 6.112))) / (a - (math.log(e / 6.112)));

  // Calculate the sensible temperature using the dry-bulb temperature and dew point
  final double sensibleTemperature = temperature - (0.33 * (temperature - Td));

  return sensibleTemperature;
}

bool isRainPossible(double humidity) {
  final double humidityThreshold =
      80; // Ngưỡng độ ẩm tương đối để xem xét có khả năng mưa (ví dụ: 80%)

  if (humidity >= humidityThreshold) {
    return true; // Có khả năng mưa
  } else {
    return false; // Không có khả năng mưa
  }
}
