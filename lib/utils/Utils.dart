import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/localization/language/languages.dart';
import 'package:water_tracker/utils/Constant.dart';
import 'package:water_tracker/utils/Preference.dart';

import 'Color.dart';

class Utils {
  static showToast(BuildContext context, String msg,
      {double duration = 2, ToastGravity? gravity}) {
    if (gravity == null) gravity = ToastGravity.BOTTOM;

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: Colur.tab_text.withOpacity(0.8),
        textColor: Colur.white,
        fontSize: 14.0);
  }

  static getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString()}-${dateTime.minute.toString()}-${dateTime.second.toString()}";
  }

  static getCurrentDate() {
    return "${DateFormat.yMd().format(DateTime.now())}";
  }

  static getCurrentDayTime() {
    return "${DateFormat.jm().format(DateTime.now())}";
  }

  static String getIntervalString(BuildContext context,int min)
  {

    switch (min) {
      case 30:
        return Languages.of(context)!.txtEveryHalfHour;
      case 60:
        return Languages.of(context)!.txtEveryOneHour;
      case 90:
        return Languages.of(context)!.txtEveryOneNHalfHour;
      case 120:
        return Languages.of(context)!.txtEveryTwoHour;
      case 150:
        return Languages.of(context)!.txtEveryTwoNHalfHour;
      case 180:
        return Languages.of(context)!.txtEveryThreeHour;
      case 210:
        return Languages.of(context)!.txtEveryThreeNHalfHour;
      case 240:
        return Languages.of(context)!.txtEveryFourHour;
      default :
        return "";
    }

  }

  static nonPersonalizedAds()  {
    if(Platform.isIOS) {
      if (Preference.shared.getString(Preference.TRACK_STATUS) != Constant.trackingStatus) {
        return true;
      } else {
        return false;
      }
    }else {
      return false;
    }
  }
}
