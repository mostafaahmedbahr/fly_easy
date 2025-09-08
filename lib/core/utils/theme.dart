import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
        // primarySwatch: AppColors.getLightMaterialColor(),
        fontFamily: AppFonts.mulish,
        colorScheme: const ColorScheme.light(primary: Colors.white),
        useMaterial3: true,
        primaryColor: AppColors.lightPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.lightPrimaryColor),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontSize: 16.sp,
              color: AppColors.lightPrimaryColor,
              fontWeight: FontWeight.w700),
          iconTheme:  IconThemeData(color: AppColors.lightPrimaryColor,size: 20.sp),
        ),
        // tabBarTheme: const TabBarTheme(indicatorColor: AppColors.tabBarIndicator),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.sp,
              color: AppColors.titleLarge,
              fontWeight: FontWeight.w700),

          titleMedium: TextStyle(
              fontSize: 18.sp,
              color: AppColors.titleMedium,
              fontWeight: FontWeight.w400),

          /// for text button
          titleSmall: TextStyle(
            fontSize: 10.sp,
            color: AppColors.titleSmall,
            fontWeight: FontWeight.w700,
          ),

          /// for hint
          bodySmall: TextStyle(
            fontSize: 12.sp,
            color: AppColors.bodySmall,
            fontWeight: FontWeight.w600,
          ),

          bodyMedium: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.bodyMedium,
          ),

          labelSmall: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.labelSmall,
          ),

          labelMedium: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.labelMedium,
          ),
          headlineLarge: TextStyle(
            fontFamily: AppFonts.mulish,
            fontSize: 60.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.lightPrimaryColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightPrimaryColor,
        ),
        focusColor: AppColors.lightPrimaryColor,
        disabledColor: AppColors.lightSecondaryColor,
        indicatorColor: AppColors.lightPrimaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor:
              const WidgetStatePropertyAll(AppColors.lightPrimaryColor),
          padding: const WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(vertical: 10)),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r))),
          enableFeedback: true,
          textStyle: WidgetStatePropertyAll(TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: AppFonts.poppins)),
          // textStyle: ,
        )),
        cardColor: AppColors.lightCardColor,
        primaryColorLight: AppColors.tabBarIndicator,
        primaryColorDark: Colors.black,
      );

  static ThemeData darkTheme() => ThemeData(
        // primarySwatch: AppColors.getLightMaterialColor(),
        fontFamily: AppFonts.mulish,
        colorScheme: const ColorScheme.light(primary: Colors.white),
        useMaterial3: true,
        primaryColor: Colors.white,
        // tabBarTheme:
        //     const TabBarTheme(indicatorColor: AppColors.darkTabIndicator),
        scaffoldBackgroundColor: AppColors.darkScaffoldBackGround,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark, // For iOS (dark icons)
          ),
          centerTitle: true,
          backgroundColor: AppColors.darkAppBarBackGround,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontSize: 16.sp,
              color: AppColors.darkTitleLarge,
              fontWeight: FontWeight.w700),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.sp,
              color: AppColors.darkTitleLarge,
              fontWeight: FontWeight.w700),

          titleMedium: TextStyle(
              fontSize: 18.sp,
              color: AppColors.darkTitleLarge,
              fontWeight: FontWeight.w400),

          /// for text button
          titleSmall: TextStyle(
            fontSize: 10.sp,
            color: AppColors.darkTitleLarge,
            fontWeight: FontWeight.w700,
          ),

          /// for hint
          bodySmall: TextStyle(
            fontSize: 12.sp,
            color: AppColors.bodySmall,
            fontWeight: FontWeight.w600,
          ),

          bodyMedium: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBodyMedium,
          ),

          labelSmall: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.darkLabelSmall,
          ),
          labelMedium: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontFamily: AppFonts.mulish,
            fontSize: 60.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        focusColor: AppColors.lightPrimaryColor,
        disabledColor: AppColors.darkSecondaryColor,
        indicatorColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor:
              const WidgetStatePropertyAll(AppColors.lightPrimaryColor),
          padding: const WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(vertical: 10)),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r))),
          enableFeedback: true,
          textStyle: WidgetStatePropertyAll(TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: AppFonts.poppins)),
          // textStyle: ,
        )),
        cardColor: AppColors.darkCardColor,
        primaryColorLight: AppColors.darkFileColor,
        primaryColorDark: AppColors.darkFileColor,
      );
}
