import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:permission_handler/permission_handler.dart'; // أضف هذا

import '../core/utils/theme.dart';
import 'app_bloc/app_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (context) => GlobalAppCubit()..requestContactsPermission(),
        child: BlocBuilder<GlobalAppCubit, GlobalAppState>(
          builder: (context, state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: _getThemeMode(),
            darkTheme: AppTheme.darkTheme(),
            theme: AppTheme.lightTheme(),
            onGenerateRoute: sl<AppRouter>().generateRoute,
            initialRoute: _getInitialRoute(),
            navigatorKey: sl<AppRouter>().navigatorKey,
          ),
        ),
      ),
    );
  }

  /// ////////////////////////
  /// ///// Helper Methods //////
  /// //////////////////////////

  String _getInitialRoute() {
    if (!CacheUtils.isOpenedBefore()) {
      return Routes.welcome;
    } else {
      if (CacheUtils.isLoggedIn()) {
        return Routes.layout;
      } else {
        return Routes.welcome;
      }
    }
  }

  ThemeMode _getThemeMode() {
    if (CacheUtils.isDarkMode()) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}