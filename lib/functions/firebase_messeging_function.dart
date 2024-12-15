// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:swinpay/functions/common_functions.dart';
// import '../global/app_util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
//
// class FireBaseMessaging {
//   FireBaseMessaging._privateConstructor();
//   static final FireBaseMessaging _instance = FireBaseMessaging._privateConstructor();
//   factory FireBaseMessaging() => _instance;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//
//
//   Future<dynamic> firebaseInit() async {
//     if (Platform.isAndroid) {
//       await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: 'AIzaSyAFOIG1rLP3MYDKfLuqEi1BEIamNdhZj5U',
//             appId: '1:346153573495:android:6df3271b06db868076ba72',
//             messagingSenderId: '346153573495',
//             projectId: 'testing-eb699'
//         ),
//       );
//     } else {
//       await Firebase.initializeApp();
//     }
//     _setFCMToken();
//     await initNotification(); // Initialize notification channel
//     return;
//   }
//
//   Future<void> _setFCMToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       if (token != null) {
//         AppUtil.printData('Token: $token');
//         AppUtil.fcmToken = token;
//       }
//     }).catchError((dynamic e) {
//       AppUtil.printData(e.toString());
//     });
//   }
//
//
//
//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'money_received_channel', // id
//     'Money Received', // title
//     description: 'Channel for money received notifications', // description
//     importance: Importance.max,
//     playSound: true,
//   );
//
//   Future<void> initNotification() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
//
//   Future<void> showMoneyReceivedNotification(int notificationId, String title, String body, String amount) async {
//      String bodyText ='$amount $body';
//     try {
//       await flutterLocalNotificationsPlugin.show(
//         notificationId,
//         title,
//         bodyText,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             importance: Importance.max,
//
//             priority: Priority.high,
//             playSound: false,
//             icon: '@drawable/ic_launcher',
//           ),
//         ),
//         payload: 'phone_pe',
//       );
//     } catch (e) {
//       print('Error showing notification: $e');
//     }
//   }
//   int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Generate a unique ID based on current timestamp
//
//   void setupForegroundMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       String title = message.data["title"]?? "";
//       String body = message.data["body"]?? "";
//       String amount =message.data["amount"]??"";
//
//       showMoneyReceivedNotification(notificationId,title,body,amount);
//       if(title.isNotEmpty&& title.toLowerCase().contains('payment')) {
//         speak('$title  ${CommonFunctions().formatRupeesAndPaise(amount)}');
//       }
//     });
//   }
//
//   void onMsgOpen(){
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('11111111111111111111111jjehe');
//     });
//   }
//
//   Future<void> speak(String text) async {
//     FlutterTts flutterTts = FlutterTts();
//     await flutterTts.setLanguage('en-US');
//     await flutterTts.setPitch(5);
//     await flutterTts.speak(text);
//   }
//
//
// }
//
//
//
//
//
//
