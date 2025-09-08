import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: AppColors.lightPrimaryColor,
          size: 50,
        ),
        Expanded(child: Text(message))
      ],
    );
  }
}
