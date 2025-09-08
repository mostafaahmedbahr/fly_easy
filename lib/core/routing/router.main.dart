part of 'router.dart';

class AppRouter {
  AppRouter();

  final navigatorKey = GlobalKey<NavigatorState>();

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return _getPageRoute(const OnBoardingScreen());
      case Routes.welcome:
        return _getPageRoute(const WelcomeScreen());
      case Routes.login:
        return _getPageRoute(BlocProvider(
            create: (context) => LoginCubit(), child: const LoginScreen()));
      case Routes.register:
        return _getPageRoute(BlocProvider(
            create: (context) => RegisterCubit(),
            child: const RegisterScreen()));
      case Routes.forgetPassRoute:
        return _getPageRoute(BlocProvider(
          create: (context) => ForgetPasswordCubit(),
          child: const ForgetPasswordScreen(),
        ));
      case Routes.layout:
        return _getPageRoute(ShowCaseWidget(builder:(context) => const LayoutScreen(),));
      case Routes.inviteMembers:
        InviteIdentifier args = settings.arguments as InviteIdentifier;
        return _getPageRoute(BlocProvider(
            create: (context) => InviteMembersCubit(),
            child: InviteMembersScreen(
              inviteIdentifier: args,
            )));
      case Routes.otp:
        var email = settings.arguments as String;
        return _getPageRoute(BlocProvider(
            create: (context) => OtpCubit(),
            child: OtpScreen(
              email: email,
            )));
      case Routes.profile:
        return _getPageRoute(BlocProvider(
            create: (context) => ProfileCubit(), child: const ProfileScreen()));
      case Routes.plans:
        return _getPageRoute(BlocProvider(
            create: (context) => PlansCubit(), child: const PlansScreen()));
      case Routes.editProfile:
        ProfileCubit cubit = settings.arguments as ProfileCubit;
        return _getPageRoute(BlocProvider(
          create: (context) => EditProfileCubit(),
          child: EditProfileScreen(profileCubit: cubit),
        ));
      case Routes.fullImageScreen:
        String imageUrl = settings.arguments as String;
        return _getPageRoute(FullImageScreen(imageUrl: imageUrl));
      case Routes.videoFullScreen:
        VideoPlayerController controller =
            settings.arguments as VideoPlayerController;
        return _getPageRoute(VideoFullScreen(videoController: controller));
      case Routes.chat:
        TeamChatInfoModel chatInfo = settings.arguments as TeamChatInfoModel;
        return _getPageRoute(BlocProvider(
          create: (context) => ChatCubit(),
          child: ChatScreen(
            chatInfo: chatInfo,
          ),
        ));
      case Routes.scanQr:
        return _getPageRoute(const ScanScreen());
      case Routes.contacts:
        ChatCubit cubit = settings.arguments as ChatCubit;
        return _getPageRoute(BlocProvider(
            create: (context) => ContactsCubit(),
            child: ContactsScreen(
              chatCubit: cubit,
            )));
      case Routes.forwardMessageScreen:
        var info = settings.arguments as ForwardInfoModel;
        return _getPageRoute(BlocProvider(
          create: (context) => ForwardMessageCubit(),
          child: ForwardMessageScreen(info: info, isExternalShare: false),
        ));
      case Routes.shareExternal:
        var info = settings.arguments as ForwardInfoModel;
        return _getPageRoute(BlocProvider(
          create: (context) => ForwardMessageCubit(),
          child: ForwardMessageScreen(info: info, isExternalShare: true),
        ));
      case Routes.librarySectionScreen:
        SectionModel section = settings.arguments as SectionModel;
        return _getPageRoute(BlocProvider(
          create: (context) => SectionCubit(),
          child: SectionScreen(section: section),
        ));
      case Routes.notifications:
        return _getPageRoute(BlocProvider(
          create: (context) => NotificationsCubit(),
          child: const NotificationsScreen(),
        ));
      case Routes.search:
        return _getPageRoute(BlocProvider(
          create: (context) => SearchCubit(),
          child: ShowCaseWidget(builder:(context) => const SearchScreen() ),
        ));
    }
    return null;
  }

  PageRoute _getPageRoute(Widget child) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: (context) => child,
      );
    } else {
      return CustomPageRouter(child);
    }
  }
}

class CustomPageRouter<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomPageRouter(this.child)
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                child,
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              const begin = 0.0;
              const end = 1.0;
              var tween = Tween<double>(begin: begin, end: end);
              return FadeTransition(
                opacity: animation.drive(tween),
                child: child,
              );
            });
}
