import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.choose_language.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 20.h,
            ),
            _LanguageTile(
                languageCode: 'en', languageName: LocaleKeys.english.tr()),
            _LanguageTile(
                languageCode: 'ar', languageName: LocaleKeys.arabic.tr()),
            _LanguageTile(
                languageCode: 'fr', languageName: LocaleKeys.french.tr()),
            _LanguageTile(
                languageCode: 'de', languageName: LocaleKeys.german.tr()),
            _LanguageTile(
                languageCode: 'es', languageName: LocaleKeys.spanish.tr()),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile(
      {Key? key, required this.languageCode, required this.languageName})
      : super(key: key);
  final String languageCode;
  final String languageName;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(
        languageName,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      value: languageCode,
      groupValue: context.locale.languageCode,
      onChanged: (value) async {
        await context.setLocale(Locale(languageCode));
        if (context.mounted) {
          GlobalAppCubit.get(context).changeLanguage();
        }
      },
      enableFeedback: true,
      activeColor: Theme.of(context).indicatorColor,
    );
  }
}
