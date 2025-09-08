// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class ConnectionStatus {
//   final Connectivity connectivity;
//
//   ConnectionStatus(this.connectivity);
//
//   Future<bool> isConnected(BuildContext context) async {
//     ConnectivityResult result = await connectivity.checkConnectivity();
//     if (result == ConnectivityResult.mobile ||
//         result == ConnectivityResult.wifi ||
//         result == ConnectivityResult.ethernet) {
//       return true;
//     } else if (result == ConnectivityResult.none) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           'Check your internet connection',
//           style: Theme.of(context)
//               .textTheme
//               .bodySmall!
//               .copyWith(fontSize: 20, color: Colors.white),
//         ),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       ));
//       return false;
//     } else {
//       return false;
//     }
//   }
// }

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetStatus {
  Connectivity connection;
  InternetStatus(this.connection);

  Future<List<ConnectivityResult>> get connectionStatus => connection.checkConnectivity();

  Future<bool> checkConnectivity() async {
    final results = await connectionStatus;

    // Check if any of the connectivity results indicate internet access
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn) ||
        results.contains(ConnectivityResult.other);
  }
}