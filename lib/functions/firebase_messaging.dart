import 'dart:io' show Platform;
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/dashboard_function.dart';
import 'package:swinpay/view/screens/dashboard/dashboard_page.dart';

import '../global/app_util.dart';
import '../main.dart';
import '../view/screens/splash_screen.dart';
import 'common_functions.dart';

class FireBaseMessaging {
  late FirebaseMessaging firebaseMessaging;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FireBaseMessaging._privateConstructor();

  static final FireBaseMessaging _instance =
      FireBaseMessaging._privateConstructor();

  factory FireBaseMessaging() {
    return _instance;
  }

  bool isFromKilledNotification = false;

  dynamic remoteMsg;

  AndroidBitmap<Object>? icon =
      DrawableResourceAndroidBitmap('@drawable/ic_launcher');

  late final ByteArrayAndroidBitmap largeIcon;
  ByteArrayAndroidBitmap? bigPicture;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
    description: 'This channel is used for important notifications.',
  );

  Future<void> initNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ignore: code-metrics, long-method
  Future<void> registerNotification() async {
    AppUtil.printData("registerNotification");
    //initialize Firebase Options
    await _initializeFirebaseMessaging();

    // Used to get the current FCM token
    await _getFirebaseToken();

    //initializing flutter loal notification plugin
    await _initializeLocalNotificationPlugin();

    // listen to Messages
    _listenToMessages();

    //listen when app is open from terminated state
    await _listenWhenAppIsOpenFromTerminated();

    //listen when app is open from minimized state
    _listenWhenAppIsOpenFromMinimized();

    //await _runWhileAppIsTerminated();
  }

  Future<void> _initializeFirebaseMessaging() async {
    // 1. Initialize the Firebase app
    await firebaseInit();

    firebaseMessaging = FirebaseMessaging.instance;

    // 2. On iOS, this helps to take the user permissions
    if (Platform.isIOS) {
      var settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      AppUtil.printData(
          'User granted permission: ${settings.authorizationStatus}');

      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    } else {
      await firebaseMessaging.requestPermission();
    }
  }

  Future<void> _getFirebaseToken() async {
    AppUtil.printData("_getFirebaseToken");

    // Used to get the current FCM token
    await firebaseMessaging.getToken().then((token) {
      if (token != null) {
        AppUtil.fcmToken = token;
        AppUtil.printData('FCM Token -> $token', isError: true);
      }
    }).catchError((e) {
      //AppUtil.fcmToken = "HitheshTestToken";
      AppUtil.printData(e.toString(), isError: true);
    });
  }

  Future<dynamic> firebaseInit() async {
    AppUtil.printData("I am in firebaseInit");
    try {
      if (Platform.isAndroid) {
        AppUtil.printData("I am in isAndroid");
        await Firebase.initializeApp(
          // options: const FirebaseOptions(
          //     apiKey: 'AIzaSyDQwGDdXze_CDkLv4a5jx-vBoFr2QEYZaY',
          //     appId: '1:229655078728:android:130e47cb64ec2dc024357d',
          //     messagingSenderId: '229655078728',
          //     projectId: 'swinkpay-vyvahar'),
        );
      } else {
        AppUtil.printData("I am in else");
        await Firebase.initializeApp();
      }
    } catch (e) {
      AppUtil.printData(e.toString(), isError: true);
    }
  }

  Future<void> _initializeLocalNotificationPlugin() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');

    final initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
        ) async {
          AppUtil.printData('ios Message notification title: ${title}');
          AppUtil.printData('ios Message notification body: ${body}');
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveNotificationResponse(NotificationResponse event) {
    try {
      AppUtil.printData('Nav ------- 01 -----------');
      AppUtil.printData(event.payload);
      AppUtil.printData(event.notificationResponseType.name);
      AppUtil.printData(event.notificationResponseType ==
          NotificationResponseType.selectedNotification);
      if (event.notificationResponseType ==
          NotificationResponseType.selectedNotification) {
        // RestartWidget.restartApp(Get.context!);
        AppUtil.printData(Get.currentRoute, isError: true);
        if (AppUtil.appLifecycleState == AppLifecycleState.inactive) {
          _navToDashboard();
        }else {
          Get.offAll(const SplashScreen());
        }
      }
      AppUtil.printData(event.notificationResponseType.name);
    } catch (e) {
      AppUtil.printData('onSelectNotification data: ${e.toString()}');
    }
  }

  void _navToDashboard(){
      if (Get.currentRoute != '/DashBoardPage') {
        Get.offAll(const DashBoardPage());
      } else {
        DashboardFunction().onRefresh(isOnRefresh: true);
      }
  }

  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        AppUtil.printData('Got a message whilst in the foreground!');
        AppUtil.printData('Message data: ${message.data}');
        AppUtil.printData('Message data: ${message.notification}');

        showNotification(message);
      } catch (e) {
        AppUtil.printData('_runWhileAppIsTerminated : ${e.toString()}');
      }
    });
  }

  Future<void> _listenWhenAppIsOpenFromTerminated() async {
    //This method will call when the app is in kill state
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      try {
        AppUtil.printData('${remoteMsg}111111111111111111111111111111',
            isError: true);
        AppUtil.printData('Got a message whilst in the while tapped!',
            isError: true);
        AppUtil.printData('Message data: ${message!.data}');
        AppUtil.printData('Message data: ${message!.notification!.title}');
        if (message != null) {
          AppUtil.printData('Got a message whilst in the while tapped!',
              isError: true);
          AppUtil.printData('Message data: ${message.data}');
          AppUtil.printData('Message data: ${message.notification}');
        }
      } catch (e) {
        AppUtil.printData(
            '_listenWhenAppIsOpenFromTerminated data: ${e.toString()}');
      }
    });
  }

  void _listenWhenAppIsOpenFromMinimized() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppUtil.printData('Message data: ${message.notification}');

      try {
        AppUtil.printData(
            'onMessageOpenedApp data: ${message.notification!.title}');
        AppUtil.printData(
            'onMessageOpenedApp data: ${message.notification!.body}');

        AppUtil.printData(
            'onMessageOpenedApp data: ${message.data['targetUrl']}');

        AppUtil.printData('Nav ------- 03 -----------');
        AppUtil.printData('22222222222222222222222222222222222', isError: true);

        if (message.data['title'] != null) {
          //  RestartWidget.restartApp(Get.context!);
          _navToDashboard();

        }
      } catch (e) {
        AppUtil.printData(
            '_listenWhenAppIsOpenFromMinimized data: ${e.toString()}');
      }
    });
  }

  Future<void> _runWhileAppIsTerminated() async {
    try {
      var details = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      AppUtil.printData(
          'main didNotificationLaunchApp: ${details!.didNotificationLaunchApp}');

      AppUtil.printData('Nav ------- 04 -----------');
      if (details.didNotificationLaunchApp) {
        AppUtil.printData('here details.didNotificationLaunchAp');
        if (details != null) {
          //  RestartWidget.restartApp(Get.context!);
        }
      }
    } catch (e) {
      AppUtil.printData('_runWhileAppIsTerminated : ${e.toString()}');
    }
  }

  Future<void> showNotification(RemoteMessage message) async {

    String title = message.data["title"] ?? "";
    String body = message.data["body"] ?? "";
    String amount = message.data["amount"] ?? "";

    AppUtil.printData('Message data .. .. ... .: 0');

    if (title != null) {
      title = title;
      body = body;
    }

    if (Platform.isIOS) {
      AppUtil.printData('Message data .. .. ... .: 5');
      if (title.isNotEmpty &&
          title.toLowerCase().contains('payment') &&
          amount.isNotEmpty) {
        speak('$title  ${CommonFunctions().formatRupeesAndPaise(amount)}');
      }
    } else {
      await _showNotificationWithImageAndroid(title, body);
      if (title.isNotEmpty &&
          title.toLowerCase().contains('payment') &&
          amount.isNotEmpty) {
        speak('$title  ${CommonFunctions().formatRupeesAndPaise(amount)}');
      }
    }
  }

  int notificationId = DateTime.now().millisecondsSinceEpoch ~/
      1000; // Generate a unique ID based on current timestamp

  Future<void> _showNotificationWithImageAndroid(
      String title, String body) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: 'phone_pe',
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> speak(String text) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
