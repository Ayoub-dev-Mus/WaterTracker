import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5680303985160573/2053069536';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5680303985160573/2053069536';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5680303985160573/4550923139";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5680303985160573/4550923139";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}