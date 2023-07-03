import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_tracker/custom/bottomsheetdialogs/RatingDialog.dart';
import 'package:water_tracker/localization/language_data.dart';
import 'package:water_tracker/localization/locale_constant.dart';
import 'package:water_tracker/utils/Color.dart';
import 'package:water_tracker/utils/Preference.dart';
import '../../common/commonTopBar/CommonTopBar.dart';
import '../../interfaces/TopBarClickListener.dart';
import '../../localization/language/languages.dart';
import '../../utils/Constant.dart';
import 'package:intl/intl.dart';


class DrinkWaterSettingsScreen extends StatefulWidget {
  @override
  _DrinkWaterSettingsScreenState createState() =>
      _DrinkWaterSettingsScreenState();
}

class _DrinkWaterSettingsScreenState extends State<DrinkWaterSettingsScreen>
    implements TopBarClickListener {
  String? targetValue;
  bool isReminder = false;
  late List<String> targetList;
  var fullHeight;
  var fullWidth;
  var prefTargetValue;

  List<LanguageData> languages =LanguageData.languageList();
  String? prefDays, prefLanguage;
  LanguageData? _languagesChosenValue = LanguageData.languageList()[0];

  String? _daysChosenValue = DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[1];
  List<String>? days;
  int? prefDayInNum;

  TextEditingController _textFeedback = TextEditingController();
  bool? showBack;

  @override
  void initState() {
    targetList = [
      '500',
      '1000',
      '1500',
      '2000',
      '2500',
      '3000',
      '3500',
      '4000',
      '4500',
      '5000'
    ];
    _getPreferences();
    super.initState();
  }

  _getPreferences() {
    prefLanguage = Preference.shared.getString(Preference.LANGUAGE);
    if (prefLanguage == null) {
      _languagesChosenValue = languages[9];
    } else {
      _languagesChosenValue = languages.where((element) => (element.languageCode == prefLanguage)).toList()[0];
    }

    prefTargetValue =
        Preference.shared.getString(Preference.TARGET_DRINK_WATER);
    if (targetValue == null && prefTargetValue == null) {
      targetValue = targetList[3];
    } else {
      targetValue = prefTargetValue;
    }
    isReminder = Preference.shared.getBool(Preference.IS_REMINDER_ON) ?? false;

  }


  @override
  Widget build(BuildContext context) {
    fullHeight = MediaQuery.of(context).size.height;
    fullWidth = MediaQuery.of(context).size.width;

    if (_languagesChosenValue == null) _languagesChosenValue = languages[9];
    List<String> allDays = DateFormat.EEEE(getLocale().languageCode).dateSymbols.STANDALONEWEEKDAYS;
    days = [
      allDays[0],
      allDays[1],
      allDays[6],
    ];
    if (_daysChosenValue == null) _daysChosenValue = days![1];
    prefDayInNum = Preference.shared.getInt(Preference.FIRST_DAY_OF_WEEK_IN_NUM) ?? 1;
    if(prefDayInNum == 1) {
      _daysChosenValue = days!.isNotEmpty?days![1]:days![1];
    } else if(prefDayInNum == 0){
      _daysChosenValue = days![0];
    } else{
      _daysChosenValue = days![2];
    }


    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: CommonTopBar(
                  Languages.of(context)!.txtSettings,
                  this,
                ),
              ),
              buildListView(context),
            ],
          ),
        ),
      ),
    );
  }

  buildListView(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      Languages.of(context)!.txtTarget,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      Languages.of(context)!.txtTargetDesc,
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: DropdownButton(
                      dropdownColor: Colur.gray_light,
                      underline: Container(
                        color: Colur.transparent,
                      ),
                      value: targetValue,
                      iconEnabledColor: Colur.txt_black,
                      items:
                          targetList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            "$value ml",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colur.txt_black,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          targetValue = value;
                          Preference.shared.setString(Preference.TARGET_DRINK_WATER,
                              targetValue.toString());
                        });
                      },
                    ),
                  ),
                  Divider(
                    color: Colur.txt_grey,
                    indent: fullWidth * 0.04,
                    endIndent: fullWidth * 0.04,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      Languages.of(context)!
                          .txtGeneralSettings
                          .toUpperCase(),
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  ListTile(
                    title:  Text(
                      Languages.of(context)!.txtLanguageOptions,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: DropdownButton<LanguageData>(
                      value: _languagesChosenValue,
                      elevation: 2,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      iconEnabledColor: Colur.txt_black,
                      iconDisabledColor: Colur.txt_black,
                      dropdownColor:
                      Colur.gray_light,
                      underline: Container(
                        color: Colur.transparent,
                      ),
                      isDense: true,
                      items: languages
                          .map<DropdownMenuItem<LanguageData>>(
                            (e) => DropdownMenuItem<LanguageData>(
                          value: e,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                e.flag,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(" "+e.name,style: TextStyle(fontSize: 20),)
                            ],
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (LanguageData? value) {
                        if (value != null)
                          setState(() {
                            _languagesChosenValue = value;
                            Preference.shared.setString(
                                Preference.LANGUAGE,
                                _languagesChosenValue!
                                    .languageCode);
                            changeLanguage(context, _languagesChosenValue!.languageCode);
                          });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      Languages.of(context)!
                          .txtFirstDayOfWeek,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: DropdownButton<String>(
                      value: _daysChosenValue,
                      elevation: 2,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      iconEnabledColor: Colur.txt_black,
                      iconDisabledColor: Colur.txt_black,
                      dropdownColor:
                      Colur.gray_light,
                      underline: Container(
                        color: Colur.transparent,
                      ),
                      isDense: true,
                      items: days!.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _daysChosenValue = value;
                          Preference.shared.setString(
                              Preference.FIRST_DAY_OF_WEEK,
                              _daysChosenValue.toString());
                          if(_daysChosenValue == days![0]) {
                            Preference.shared.setInt(
                                Preference.FIRST_DAY_OF_WEEK_IN_NUM,0);
                          }
                          if(_daysChosenValue == days![1]) {
                            Preference.shared.setInt(
                                Preference.FIRST_DAY_OF_WEEK_IN_NUM,1);
                          }
                          if(_daysChosenValue == days![2]) {
                            Preference.shared.setInt(
                                Preference.FIRST_DAY_OF_WEEK_IN_NUM,-1);
                          }
                        });
                      },
                    ),

                  ),

                  _supportUsWidget(),





                ],
              ),
            ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {

  }

  _supportUsWidget() {
    return Container(
      child: Column(children: [
        Divider(
          color: Colur.txt_grey,
          indent: fullWidth * 0.04,
          endIndent: fullWidth * 0.04,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0),
          child: Text(
            Languages.of(context)!.txtSupportUs.toUpperCase(),
            style: TextStyle(
                color: Colur.txt_grey,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        ),

        InkWell(
          onTap: () {
            _textFeedback.text = "";
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: TextField(
                      controller: _textFeedback,
                      textInputAction: TextInputAction.done,
                      minLines: 1,
                      maxLines: 10,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                      keyboardType: TextInputType.text,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: Languages.of(context)!
                            .txtFeedbackOrSuggestion,
                        hintStyle: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          Languages.of(context)!
                              .txtCancel
                              .toUpperCase(),
                          style: TextStyle(

                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          Languages.of(context)!
                              .txtSubmit
                              .toUpperCase(),
                          style: TextStyle(

                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: '${Constant.EMAIL_PATH}',
                            query: encodeQueryParameters(<String,
                                String>{
                              'subject': Languages.of(context)!
                                  .txtWaterTrackerFeedback,
                              'body': '${_textFeedback.text}'
                            }),
                          );
                          launchUrl(
                              Uri.parse(emailLaunchUri.toString()))
                              .then((value) =>
                              Navigator.of(context).pop());

                          setState(() {});
                        },
                      ),
                    ],
                  );
                });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/ic_email.webp",
                  color: Colur.txt_grey,
                  scale: 4,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25.0),
                    child: Text(
                      Languages.of(context)!.txtFeedback,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: false,
                builder: (context) {
                  return Wrap(
                    children: [
                      RatingDialog(),
                    ],
                  );
                });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/ic_star_white.webp",
                  color: Colur.txt_grey,
                  scale: 3.5,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25.0),
                    child: Text(
                      Languages.of(context)!.txtRateUs,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: (){
            launchURLPrivacyPolicy();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/ic_privacy_policy.webp",
                  color: Colur.txt_grey,
                  scale: 4,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25.0),
                    child: Text(
                      Languages.of(context)!.txtPrivacyPolicy,
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),



      ],),
    );
  }

  void launchURLPrivacyPolicy() async {
    var url = Constant.getPrivacyPolicyURL();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
