import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:water_tracker/interfaces/TopBarClickListener.dart';
import 'package:water_tracker/localization/language/languages.dart';
import 'package:water_tracker/utils/Color.dart';
import 'package:water_tracker/utils/Debug.dart';
import 'package:water_tracker/utils/Preference.dart';
import 'package:water_tracker/utils/Utils.dart';
import 'package:timezone/timezone.dart' as tz;


import '../../main.dart';

class DrinkWaterReminderScreen extends StatefulWidget {
  @override
  _DrinkWaterReminderScreenState createState() =>
      _DrinkWaterReminderScreenState();
}

class _DrinkWaterReminderScreenState extends State<DrinkWaterReminderScreen>
    implements TopBarClickListener {
  bool isNotification = false;
  var startValue;
  var endValue;
  int dropdownIntervalValue = 30;
  final TextEditingController msgController = TextEditingController();

  String? _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _notificationMSgController = TextEditingController();

  String? prefStartTimeValue;
  String? prefEndTimeValue;
  String? prefNotiMsg;
  bool? showBack;

  @override
  void initState() {
    _getPreference();
    super.initState();
  }

  _getPreference() {
    prefStartTimeValue = Preference.shared.getString(Preference.START_TIME_REMINDER);
    prefEndTimeValue =
        Preference.shared.getString(Preference.END_TIME_REMINDER);
    isNotification =
        Preference.shared.getBool(Preference.IS_REMINDER_ON) ?? false;

    dropdownIntervalValue =
        Preference.shared.getInt(Preference.DRINK_WATER_INTERVAL) ?? 30;
    setState(() {
      if (prefStartTimeValue == null) {
        _startTimeController.text = "08:00 AM";
        prefStartTimeValue = "08:00";
      } else {
        var hr = int.parse(prefStartTimeValue!.split(":")[0]);
        var min = int.parse(prefStartTimeValue!.split(":")[1]);
        _startTimeController.text =
            DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));
      }
      if (prefEndTimeValue == null) {
        _endTimeController.text = "11:00 PM";
        prefEndTimeValue = "23:00";
      } else {
        var hr = int.parse(prefEndTimeValue!.split(":")[0]);
        var min = int.parse(prefEndTimeValue!.split(":")[1]);
        _endTimeController.text =
            DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    prefNotiMsg = Preference.shared
        .getString(Preference.DRINK_WATER_NOTIFICATION_MESSAGE) ?? Languages.of(context)!.txtDrinkWaterNotiMsg;
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    if (_notificationMSgController.text.isEmpty)
      _notificationMSgController.text =
          prefNotiMsg ?? Languages.of(context)!.txtDrinkWaterNotiMsg;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(left: 15) ,
              child: CommonTopBar(
                  Languages.of(context)!.txtDrinkWaterReminder,
                  this,
              ),
            ),
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: _notificationRadioButton(
                            context, fullWidth, fullHeight),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ]),
        ),
      ),
    );
  }

  _notificationRadioButton(
      BuildContext context, double fullWidth, double fullHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Languages.of(context)!.txtNotifications,
                style: TextStyle(
                    color: Colur.txt_black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(child: Container()),
              buildSwitch(),
            ],
          ),
          buildDivider(),

          buildTitleText(fullWidth, fullHeight, context,
              Languages.of(context)!.txtSchedule),


          InkWell(
            onTap: () {
              var hr = int.parse(prefStartTimeValue!.split(":")[0]);
              var min = int.parse(prefStartTimeValue!.split(":")[1]);

              TimeOfDay _startTime = TimeOfDay(hour: hr, minute: min);
              _selectTime(context, "START", _startTime).then((value) {
                if (isNotification) setWaterReminder();
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    Languages.of(context)!.txtStart,
                    style: TextStyle(
                        color: Colur.txt_black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _startTimeController.text,
                    style: TextStyle(
                        color: Colur.txt_black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colur.txt_black,
                    size: 20,
                  )
                ],
              ),
            ),
          ),

          buildDivider(),

          InkWell(
            onTap: () {
              var hr = int.parse(prefEndTimeValue!.split(":")[0]);
              var min = int.parse(prefEndTimeValue!.split(":")[1]);

              TimeOfDay _endTime = TimeOfDay(hour: hr, minute: min);
              _selectTime(context, "END", _endTime).then((value) {
                if (isNotification) setWaterReminder();
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    Languages.of(context)!.txtEnd,
                    style: TextStyle(
                        color: Colur.txt_black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _endTimeController.text,
                    style: TextStyle(
                        color: Colur.txt_black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colur.txt_black,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          buildDivider(),

          Container(
            child: Row(
              children: [
                Text(
                  Languages.of(context)!.txtInterval,
                  style: TextStyle(
                      color: Colur.txt_black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(child: Container()),
                _intervalDropdown(context),
              ],
            ),
          ),

          buildDivider(),

          buildTitleText(fullWidth, fullHeight, context,
              Languages.of(context)!.txtMessage),

          _buildTextField(context, fullWidth, fullHeight),
        ],
      ),
    );
  }

  _buildTextField(BuildContext context, double fullWidth, double fullHeight) {
    return Container(
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.done,
        controller: _notificationMSgController,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: Colur.txt_black, fontSize: 18, fontWeight: FontWeight.w500),
        cursorColor: Colur.txt_grey,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          if (_notificationMSgController.text.isEmpty)
            _notificationMSgController.text =
                prefNotiMsg ?? Languages.of(context)!.txtDrinkWaterNotiMsg;
          Preference.shared.setString(
              Preference.DRINK_WATER_NOTIFICATION_MESSAGE,
              _notificationMSgController.text);
          FocusScope.of(context).unfocus();

          if (isNotification) setWaterReminder();
        },
      ),
    );
  }

  Future<Null> _selectTime(
      BuildContext context, String s, TimeOfDay selectedTime) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ))!;
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        if (s == "START") {
          _startTimeController.text = DateFormat.jm().format(
              DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));

          if (selectedTime.hour > int.parse(prefEndTimeValue!.split(":")[0])) {
            _endTimeController.text = DateFormat.jm().format(DateTime(
                2021, 08, 1, selectedTime.hour + 1, selectedTime.minute));
            var newtime = (selectedTime.hour + 1).toString() +
                ' : ' +
                (selectedTime.minute).toString();
            prefEndTimeValue = newtime;
          }

          prefStartTimeValue = _time!;
        } else {
          _endTimeController.text = DateFormat.jm().format(
              DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));
          if (int.parse(prefStartTimeValue!.split(":")[0]) >
              selectedTime.hour) {
            _startTimeController.text = DateFormat.jm().format(DateTime(
                2021, 08, 1, selectedTime.hour - 1, selectedTime.minute));
            print(
                "${int.parse(prefStartTimeValue!.split(":")[0])}::::::${selectedTime.hour}");
            var newtime = (selectedTime.hour + 1).toString() +
                ' : ' +
                (selectedTime.minute).toString();
            prefStartTimeValue = newtime;
          }
          prefEndTimeValue = _time!;
        }

        Preference.shared.setString(Preference.END_TIME_REMINDER, prefEndTimeValue!);
        Preference.shared.setString(Preference.START_TIME_REMINDER, prefStartTimeValue!);

      });
  }


  buildTitleText(
      double fullWidth, double fullHeight, BuildContext context, String title) {
    return Container(
      margin:
          EdgeInsets.only(top: fullHeight * 0.02, bottom: fullHeight * 0.02),
      child: Text(
        title,
        style: TextStyle(
            color: Colur.txt_grey, fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }

  buildDivider() {
    return Divider(
      color: Colur.txt_grey,
    );
  }

  buildSwitch() {
    return Switch(
      onChanged: (bool value) async {
        var status = await Permission.notification.status;
        if (status.isDenied) {
          await Permission.notification.request();
        }

        if (status.isPermanentlyDenied) {
          openAppSettings();
        }

        if (isNotification == false) {
          setState(() {
            isNotification = true;
          });
        } else {
          setState(() {
            isNotification = false;
          });
        }
        Preference.shared.setBool(Preference.IS_REMINDER_ON, isNotification);
        if (isNotification)
          setWaterReminder();
        else {
          flutterLocalNotificationsPlugin.cancelAll();
        }
      },
      value: isNotification,
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {

  }

  _intervalDropdown(BuildContext context) {
    return DropdownButton(
        value: dropdownIntervalValue,
        iconDisabledColor: Colur.txt_black,
        iconEnabledColor: Colur.txt_black,
        underline: Container(
          color: Colur.transparent,
        ),
        dropdownColor: Colur.gray_light,
        items: [
          DropdownMenuItem(
            child: Text(Utils.getIntervalString(context,30), style: _commonTextStyle()),
            value: 30,
          ),
          DropdownMenuItem(
            child: Text(Utils.getIntervalString(context,60), style: _commonTextStyle()),
            value: 60,
          ),
          DropdownMenuItem(
            child: Text(Utils.getIntervalString(context,90), style: _commonTextStyle()),
            value: 90,
          ),
          DropdownMenuItem(
            child: Text(Utils.getIntervalString(context,120), style: _commonTextStyle()),
            value: 120,
          ),
          DropdownMenuItem(
            child: Text(Utils.getIntervalString(context,150), style: _commonTextStyle()),
            value: 150,
          ),
          DropdownMenuItem(
              child: Text(Utils.getIntervalString(context,180), style: _commonTextStyle()),
              value: 180),
          DropdownMenuItem(
              child: Text(Utils.getIntervalString(context,210), style: _commonTextStyle()),
              value: 210),
          DropdownMenuItem(
              child: Text(Utils.getIntervalString(context,240), style: _commonTextStyle()),
              value: 240),
        ],
        onChanged: (val) {
          setState(() {
            dropdownIntervalValue = val as int;
          });
          Preference.shared.setInt(Preference.DRINK_WATER_INTERVAL, dropdownIntervalValue);

          if (isNotification) setWaterReminder();

        });
  }

  _commonTextStyle() {
    return TextStyle(
        color: Colur.txt_black, fontSize: 17, fontWeight: FontWeight.w400);
  }

  setWaterReminder() async {
    var titleText = Languages.of(context)!.txtTimeToHydrate;
    var msg = _notificationMSgController.text;
    await flutterLocalNotificationsPlugin.cancelAll();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime startTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        int.parse(prefStartTimeValue!.split(":")[0]),
        int.parse(prefStartTimeValue!.split(":")[1]));
    tz.TZDateTime endTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        int.parse(prefEndTimeValue!.split(":")[0]),
        int.parse(prefEndTimeValue!.split(":")[1]));


    scheduledNotification(
        tz.TZDateTime scheduledDate, int notificationId) async {
      Debug.printLog(
          "Schedule Notification at ::::::==> ${scheduledDate.toIso8601String()}");
      Debug.printLog(
          "Schedule Notification at scheduledDate.millisecond::::::==> $notificationId");
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          titleText,
          msg,
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails('drink_water_reminder',
                'Drink Water', channelDescription: 'This is reminder for drinking water on time',icon: 'ic_notification'),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
      payload: scheduledDate.millisecondsSinceEpoch.toString());
    }

    var interVal = dropdownIntervalValue;
    var notificationId = 1;
    while (startTime.isBefore(endTime)) {
      tz.TZDateTime newScheduledDate = startTime;
      if (newScheduledDate.isBefore(now)) {
        newScheduledDate = newScheduledDate.add(const Duration(days: 1));
      }
      await scheduledNotification(newScheduledDate, notificationId);
      notificationId += 1;
      startTime = startTime.add(Duration(minutes: interVal));
    }
  }
}