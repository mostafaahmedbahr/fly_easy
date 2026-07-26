// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'core/paymob_manager/paymob_manager.dart';
//
// class TestPayMob extends StatefulWidget {
//   const TestPayMob({super.key});
//
//   @override
//   State<TestPayMob> createState() => _TestPayMobState();
// }
//
// class _TestPayMobState extends State<TestPayMob> {
//   Future<void> _pay() async{
//     PaymobManager().getPaymentKey(
//         10,"EGP"
//     ).then((String paymentKey) {
//       launchUrl(
//         Uri.parse("https://accept.paymob.com/api/acceptance/iframes/812741?payment_token=$paymentKey"),
//       );
//     });
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Center(
//         child: ElevatedButton(onPressed: (){
//           _pay();
//         }, child: Text("Test Pay mob")),
//       ),
//     );
//   }
// }

/// ios
/// app ID : ca-app-pub-8718188273675259~5095938995
/// unit ID: ca-app-pub-8718188273675259/4216754205
///
///  android
///  app ID : ca-app-pub-8718188273675259~5794121186
///  unit ID: ca-app-pub-8718188273675259/7229664422