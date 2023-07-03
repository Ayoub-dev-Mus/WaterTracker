import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:water_tracker/ad_helper.dart';
import 'package:water_tracker/localization/locale_constant.dart';
import 'package:water_tracker/ui/home/HomeScreen.dart';
import 'package:water_tracker/utils/Color.dart';
import 'package:water_tracker/utils/Debug.dart';
import 'package:water_tracker/utils/Preference.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/subjects.dart';
import 'package:water_tracker/utils/Utils.dart';


import 'dbhelper/DataBaseHelper.dart';
import 'localization/localizations_delegate.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
BehaviorSubject<String?>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preference().instance();
  await initPlugin();
  await DataBaseHelper().initialize();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_notification');

  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? notificationResponse) async {
        if (notificationResponse!.payload != null) {
          debugPrint('notification payload: ${notificationResponse.payload}');
        }
        selectedNotificationPayload = notificationResponse.payload;
        selectNotificationSubject.add(notificationResponse.payload);
      });
  await _initGoogleMobileAds();



  _configureLocalTimeZone();
  _loadInterstitialAd();
  runApp(MyApp());
}

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
}

Future<void> initPlugin() async {
  try {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      var _authStatus = await AppTrackingTransparency.requestTrackingAuthorization();
      Preference.shared.setString(Preference.TRACK_STATUS, _authStatus.toString());
    }
  } on PlatformException {}

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  Debug.printLog("UUID:" + uuid);
}

int? _adCount = Preference.shared.getInt(Preference.AD_COUNT) ?? 1;

_loadInterstitialAd() {
  if (_adCount! % 2 == 0 ) {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(
          nonPersonalizedAds: Utils.nonPersonalizedAds()
      ),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
         ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
            },
          );

          Debug.printLog("interstitial loaded");
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }
  _adCount = _adCount! + 1;
  Preference.shared.setInt(Preference.AD_COUNT, _adCount!);
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class MyApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;


  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    _locale = getLocale();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('pt', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('ja', ''),
        Locale('ru', ''),
        Locale('ur', ''),
        Locale('hi', ''),
        Locale('vi', ''),
        Locale('id', ''),
        Locale('bn', ''),
        Locale('ta', ''),
        Locale('te', ''),
        Locale('tr', ''),
        Locale('ko', ''),
        Locale('pa', ''),
        Locale('it', ''),
        Locale('sq', ''),
        Locale('az', ''),
        Locale('my', ''),
        Locale('hr', ''),
        Locale('cs', ''),
        Locale('nl', ''),
        Locale('el', ''),
        Locale('gu', ''),
        Locale('hu', ''),
        Locale('kn', ''),
        Locale('ml', ''),
        Locale('mr', ''),
        Locale('nb', ''),
        Locale('or', ''),
        Locale('fa', ''),
        Locale('pl', ''),
        Locale('ro', ''),
        Locale('sv', ''),
        Locale('th', ''),
        Locale('uk', ''),
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colur.white,
            brightness: Brightness.light
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colur.transparent,
        ),
      ),
      theme: ThemeData(
        splashColor: Colur.transparent,
        highlightColor: Colur.transparent,
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colur.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: HomeScreen(),
      ),
    );
  }
}
