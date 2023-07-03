import 'dart:developer';

class Debug {
  static const DEBUG = true;

  static printLog(String str) {
    if (DEBUG) log(str);
  }
}