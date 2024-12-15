import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/screens/splash_screen.dart';
import 'functions/firebase_messaging.dart';
import 'global/app_theme.dart';

//import 'package:firebase_app_check/firebase_app_check.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppUtil.printData('i am from main', isError: true);
  print("Handling a background message: ${message.messageId}");
  await FireBaseMessaging().showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FireBaseMessaging().registerNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FireBaseMessaging().initNotification();

  ByteData data = await PlatformAssetBundle()
      .load('assets/start_swinkpay_fintech_com_2024.crt');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DateTime? time;

  @override
  void initState() {
    super.initState();
    //FireBaseMessaging().registerNotification();
    AppUtil.printData("I am in initState");
    AppUtil.printData("I am in initState registerNotification");
    WidgetsBinding.instance.addObserver(this); // Make sure to add this line
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Ensure proper null check
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppUtil.appLifecycleState = state;
    AppUtil.printData('--------I am state changed $state', isError: true);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      AppUtil.printData('--------I am detached/inactive', isError: true);

      return;
    }
    if (state == AppLifecycleState.paused) {
      time = DateTime.now();
      AppUtil.printData('--------I am /paused $time', isError: true);
    }

    if (state == AppLifecycleState.resumed) {
      AppUtil.printData(
          '--------I am called after old : ${time} : new ${DateTime.now()}',
          isError: true);
      if (time != null) {
        var min = DateTime.now().difference(time!).inMinutes;
        AppUtil.printData('--------I resumed check ${min} ', isError: true);
        if (min >= 5) {
          Get.offAll(SplashScreen());
        } else {
          AppUtil.printData('--------I resumed after ${min} ', isError: true);
        }

        time = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!),
      theme: AppTheme().theme,
      home: const SplashScreen(),
    );
  }
}
