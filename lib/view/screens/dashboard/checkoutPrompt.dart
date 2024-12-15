// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:swinpay/global/app_color.dart';
// import 'package:swinpay/global/app_string.dart';
// import 'package:swinpay/view/screens/dashboard/dashboard_page2.dart';
// import 'package:swinpay/view/widgets/buttons.dart';
// import 'package:swinpay/view/widgets/shapes.dart';
//
// class CheckOutPrompt {
//   CheckOutPrompt._privateConstructor();
//
//   static final CheckOutPrompt _instance = CheckOutPrompt._privateConstructor();
//
//   factory CheckOutPrompt() {
//     return _instance;
//   }
//
//   void show() => Get.dialog(
//         _body(),
//         barrierDismissible: false,
//       );
//
//   Widget _body() => AlertDialog(
//         contentPadding: const EdgeInsets.all(0),
//         backgroundColor: AppColors.card,
//         content: Card(
//             margin: const EdgeInsets.all(0),
//             shape: Shapes().cardRoundedBorder(allRadius: 15),
//             color: AppColors.card,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 15),
//                 Container(
//                     alignment: Alignment.centerRight,
//                     margin: const EdgeInsets.only(right: 10),
//                     child: IconButton(
//                         onPressed: () => Navigator.pop(Get.context!),
//                         icon: const Icon(Icons.cancel))),
//                 const SizedBox(height: 15),
//                 Text(
//                   AppString().plzConfirmCheckOutUWillBeLoggedOut,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 15),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 42),
//                   width: double.infinity,
//                   child: Buttons().raisedButton(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       buttonText: AppString().ok,
//                       onTap: () {
//                         Navigator.pop(Get.context!);
//                         Get.to(const DashBoardPage2());
//                       }),
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             )),
//       );
// }
