import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/paymob_manager/paymob_manager.dart';

class TestPayMob extends StatefulWidget {
  const TestPayMob({super.key});

  @override
  State<TestPayMob> createState() => _TestPayMobState();
}

class _TestPayMobState extends State<TestPayMob> {
  Future<void> _pay() async{
    PaymobManager().getPaymentKey(
        10,"EGP"
    ).then((String paymentKey) {
      launchUrl(
        Uri.parse("https://accept.paymob.com/api/acceptance/iframes/812741?payment_token=$paymentKey"),
      );
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: ElevatedButton(onPressed: (){
          _pay();
        }, child: Text("Test Pay mob")),
      ),
    );
  }
}
