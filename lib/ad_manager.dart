import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8146225151395890~8393215900";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8146225151395890/9042817125";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8146225151395890/2191451823";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}