import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';

import 'enums.dart';

extension MediaQueryExtension on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get width => _size.width;

  double get height => _size.height;
}

extension NavigationExtension on BuildContext {
  void push(String routeName, {Object? arg}) {
    sl<AppRouter>()
        .navigatorKey
        .currentState!
        .pushNamed(routeName, arguments: arg);
    // Navigator.of(this).pushNamed(routeName, arguments: arg);
    // Navigator.pushNamed(this, routeName,arguments: arg);
  }

  void pushAndRemove(String routeName, {Object? arg}) {
    sl<AppRouter>()
        .navigatorKey
        .currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arg);

    // Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => false);
  }

  void popAndRemove(String routeName) {
    Navigator.popUntil(this, ModalRoute.withName(routeName));
  }

  void pop() {
    return Navigator.pop(this);
  }
}

extension DeviceTypeExtension on DeviceType {
  int getMinWidth() {
    switch (this) {
      case DeviceType.mobile:
        return 320;
      case DeviceType.ipad:
        return 481;
      case DeviceType.smallScreenLaptop:
        return 769;
      case DeviceType.largeScreenDesktop:
        return 1025;
      case DeviceType.extraLargeTV:
        return 1600;
    }
  }

  int getMaxWidth() {
    switch (this) {
      case DeviceType.mobile:
        return 550;
      case DeviceType.ipad:
        return 750;
      case DeviceType.smallScreenLaptop:
        return 1024;
      case DeviceType.largeScreenDesktop:
        return 1200;
      case DeviceType.extraLargeTV:
        return 3840; // any number more than 1200
    }
  }
}

extension Validation on String? {
  bool get isNullOrEmpty => (this != null && this!.isNotEmpty) ? false : true;
}

extension HeightExtension on num {
  SizedBox get height => SizedBox(
        height: toDouble(),
      );
}

extension WidthExtension on num {
  SizedBox get width => SizedBox(
        width: toDouble(),
      );
}
