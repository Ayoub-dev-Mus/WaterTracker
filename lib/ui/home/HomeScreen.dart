import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:water_tracker/ad_helper.dart';
import 'package:water_tracker/localization/language/languages.dart';
import 'package:water_tracker/ui/drinkWaterReminder/DrinkWaterReminderScreen.dart';
import 'package:water_tracker/ui/drinkWaterScreen/DrinkWaterLevelScreen.dart';
import 'package:water_tracker/ui/drinkWaterSettings/DrinkWaterSettingsScreen.dart';
import 'package:water_tracker/utils/Color.dart';
import 'package:water_tracker/utils/Debug.dart';
import 'package:water_tracker/utils/Utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController = PageController(initialPage: 1);
  int currentIndex = 1;
  DateTime? currentBackPressTime;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _loadBanner();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar (
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(
                milliseconds: 250,
              ),
              curve: Curves.easeIn,
            );
          },
          currentIndex: 1,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                    child: Image.asset(
                      'assets/icons/water/tab_reminder.png',
                      color: currentIndex == 0 ? Colur.graph_water : Colur.tab_text,
                      scale: 4.5,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      Languages.of(context)!.txtReminder,
                      style: TextStyle(
                        color:
                        currentIndex == 0 ? Colur.graph_water : Colur.tab_text,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                    child: Image.asset(
                     'assets/icons/water/tab_drinkwater.png',
                      color: currentIndex == 1 ? Colur.graph_water : Colur.tab_text,
                      scale: 4.5,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      Languages.of(context)!.txtDrinkWater,
                      style: TextStyle(
                        color:
                        currentIndex == 1 ? Colur.graph_water : Colur.tab_text,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                    child: Image.asset(
                      'assets/icons/water/tab_settings.png',
                      color: currentIndex == 2 ? Colur.graph_water : Colur.tab_text,
                      scale: 4.5,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      Languages.of(context)!.txtSettings,
                      style: TextStyle(
                        color:
                        currentIndex == 2 ? Colur.graph_water : Colur.tab_text,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              label: "",
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  children: <Widget>[
                    DrinkWaterReminderScreen(),
                    DrinkWaterLevelScreen(),
                    DrinkWaterSettingsScreen()
                  ],
                ),
              ),
            ),

            if(_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(
        nonPersonalizedAds: Utils.nonPersonalizedAds()
      ),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          Debug.printLog("banner loaded");
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          Debug.printLog('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 3)) {
      currentBackPressTime = now;
      Utils.showToast(context, Languages.of(context)!.txtExitMessage, duration: 3);
      return Future.value(false);
    }
    return Future.value(true);
  }



}
