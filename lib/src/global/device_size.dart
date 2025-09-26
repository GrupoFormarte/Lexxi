import 'package:flutter/material.dart';

enum DeviceSize { XS, S, M, L, XL }

class DeviceSizeClassifier {
  static DeviceSize classify(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 320) {
      return DeviceSize.XS; // Dispositivo extra pequeño
    } else if (screenWidth >= 320 && screenWidth < 360) {
      return DeviceSize.S; // Dispositivo pequeño
    } else if (screenWidth >= 360 && screenWidth < 600) {
      return DeviceSize.M; // Dispositivo mediano
    } else if (screenWidth >= 600 && screenWidth < 820) {
      return DeviceSize.L; // Dispositivo grande
    } else {
      return DeviceSize.XL; // Dispositivo extra grande
    }
  }

  static bool isMall(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.width;
    

    // print(['tamano',screenWidth]);
   if (screenWidth < 320) {
      return true; // Dispositivo extra pequeño
    } else if (screenWidth >= 320 && screenWidth < 360) {
      return true; // Dispositivo pequeño
    } else if (screenWidth >= 360 && screenWidth < 600) {
      return true; // Dispositivo mediano
    } else if (screenWidth >= 600 && screenWidth < 820) {
      return false; // Dispositivo grande
    } else {
      return false; // Dispositivo extra grande
    }
  }
}
