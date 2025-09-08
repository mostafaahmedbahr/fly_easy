import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProgress extends StatelessWidget {
  const MyProgress({super.key, this.color,this.stroke});

  final Color? color;
  final double? stroke;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return  Center(
        child: CupertinoActivityIndicator(
          radius: 15,
          color:color?? Theme.of(context).progressIndicatorTheme.color,
        ),
      );
    } else {
      return Center(
          child: CircularProgressIndicator(
        color:color?? Theme.of(context).progressIndicatorTheme.color,
            strokeAlign:stroke?? .9,
      ));
    }
  }
}
