import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(text: LocaleKeys.check_internet.tr(), image: AppImages.noInternet,repeat: false,);
  }
}
