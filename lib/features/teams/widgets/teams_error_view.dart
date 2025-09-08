import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/no_internet_widget.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class TeamsErrorView extends StatelessWidget {
  const TeamsErrorView({Key? key,required this.message}) : super(key: key);
final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: message ==
            LocaleKeys.check_internet.tr()
            ? const NoInternetWidget()
            : CustomErrorWidget(
            message:message));
  }
}
