import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get txtSettings;

  String get txtTarget;

  String get txtReminder;

  String get txtTargetDesc;

  String get txtDrinkWaterReminder;

  String get txtNotifications;

  String get txtSchedule;

  String get txtStart;

  String get txtEnd;

  String get txtInterval;

  String get txtMessage;

  String get txtGood;

  String get txtToday;

  String get txtDrinkWater;

  String get txtMl;

  String get txtWeek;

  String get txtWeeklyAverage;

  String get txtTodayRecords;

  String get txtNextTime;

  String get txtTerrible;

  String get txtBad;

  String get txtOkay;

  String get txtGreat;

  String get txtBestWeCanGet;

  String get txtRate;

  String get txtCancel;

  String get txtSave;

  String get txtDelete;

  String get txtDrinkWaterNotiMsg;

  String get txtTimeToHydrate;

  String get txtTurnedOff;

  String get txtSaveChanges;

  String get txtGeneralSettings;

  String get txtLanguageOptions;

  String get txtFirstDayOfWeek;

  String get txtSupportUs;

  String get txtFeedback;

  String get txtRateUs;

  String get txtPrivacyPolicy;

  String get txtEveryHalfHour;

  String get txtEveryOneHour;

  String get txtEveryOneNHalfHour;

  String get txtEveryTwoHour;

  String get txtEveryTwoNHalfHour;

  String get txtEveryThreeHour;

  String get txtEveryThreeNHalfHour;

  String get txtEveryFourHour;

  String get txtRatingOnGooglePlay;

  String get txtWaterTrackerFeedback;

  String get txtSubmit;

  String get txtFeedbackOrSuggestion;

  String get txtExitMessage;
}
