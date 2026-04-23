import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/show_case_widget.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/screens/add_community_bottom_sheet.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/screens/archived_teams_view.dart';
import 'package:new_fly_easy_new/features/teams/screens/joined_teams_view.dart';
import 'package:new_fly_easy_new/features/teams/screens/admin_teams_view.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_bloc_listener.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_global_state_listener.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../app/app_bloc/app_cubit.dart';
import '../../home/widgets/home_slider_images.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> with SingleTickerProviderStateMixin {
  TeamsCubit get cubit => context.read<TeamsCubit>();
  late TabController _tabController;
  late PagingController<int, TeamModel> _joinedTeamsPagingController;
  late PagingController<int, TeamModel> _adminTeamsPagingController;
  late PagingController<int, TeamModel> _archivedTeamsPagingController;
  GlobalKey? _createTeamsHintKey;
  GlobalKey? _archiveHintKey;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _joinedTeamsPagingController = cubit.joinedTeamsPagingController;
    _adminTeamsPagingController = cubit.adminTeamsPagingController;
    _archivedTeamsPagingController = cubit.archivedTeamsPagingController;
   // _startShowCase();
    // _showAdvSnackBar();
    // _createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            const TeamsGlobalStateListener(),
            const TeamsBlocListener(),
            TeamsTabBar(
              tabController: _tabController,
              archiveHintKey: _archiveHintKey,
            ),
            SizedBox(height: 24,),
            HomeSliderImages(),
            SizedBox(height: 12,),
            Expanded(
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: const [
                      AdminTeamsView(),
                      JoinedTeamsView(),
                      ArchivedTeamsView()
                    ])),
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    _joinedTeamsPagingController.dispose();
    _adminTeamsPagingController.dispose();
    _archivedTeamsPagingController.dispose();
    // _interstitialAd?.dispose();
    super.dispose();
  }
  GlobalKey? _notificationsHintKey;
  /// /////////////////////////////////////////
  /// /////////// Helper Methods ///////////////
  /// //////////////////////////////////////////

  AppBar _appBar() => AppBar(
    leadingWidth: context.width * .3,
        leading: Row(
          children: [
            IconButton(
              icon: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  CustomShowCase(
                    description: AppStrings.notificationsHint,
                    caseKey: _notificationsHintKey,
                    child: Icon(
                      // IconlyBroken.notification,
                      CupertinoIcons.bell,
                      size: 30,
                    ),
                  ),
                  BlocConsumer<GlobalAppCubit, GlobalAppState>(
                    listenWhen: (previous, current) =>
                    current is ReceiveUserNotification ||
                        current is ReceiveTeamNotification,
                    listener: (context, state) {
                      if (state is ReceiveTeamNotification ||
                          state is ReceiveUserNotification) {
                        //  _notificationsNum++;
                        context.read<HomeCubit>().notificationsCount++;
                        setState(() {}); // Trigger UI update
                      }
                    },
                    buildWhen: (previous, current) =>
                    current is ReceiveUserNotification ||
                        current is ReceiveTeamNotification,
                    builder: (context, state) => BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                      current is GetNotificationsCount,
                      builder: (context, state) => Visibility(
                        visible: context.read<HomeCubit>().notificationsCount > 0,
                        replacement: const SizedBox.shrink(),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 8,
                          child: Text(
                            // _notificationsNum > 99
                            //     ? '+99'
                            //     : '$_notificationsNum',
                            context.read<HomeCubit>().notificationsCount > 99
                                ? '+99'
                                : '${context.read<HomeCubit>().notificationsCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: _onNotificationsPressed,
              padding: EdgeInsets.zero,
              alignment: AlignmentDirectional.centerStart,
            ),
            IconButton(
                icon: CustomShowCase(
                    description: AppStrings.createTeamsHint,
                    caseKey: _createTeamsHintKey,
                    child: Icon(
                      Icons.group_add_outlined,
                      size: 22.sp,
                    )),
                onPressed: _onAddChannelPressed,
                padding: EdgeInsets.zero,
                alignment: AlignmentDirectional.centerStart),
          ],
        ),
        // actions: const [UserImage()],
        title: Text(
          LocaleKeys.teams.tr(),
        ),
        centerTitle: true,
      );
  void _onNotificationsPressed() {
    _resetNotifications();
    context.push(Routes.notifications);
  }
  void _resetNotifications() {
    context.read<HomeCubit>().resetNotificationsCounter();
    setState(() {}); // Trigger UI update
  }
  void _onAddChannelPressed() {
    (HiveUtils.hasMoreTeams())
        ? _showAddChannelSheet()
        : sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.plans);
  }
  void _showAddChannelSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      builder: (context) => FractionallySizedBox(
        heightFactor: .9,
        child: BlocProvider(
            create: (context) => AddChannelCubit(),
            child: const AddCommunitySheet(
              level: 1,
            )),
      ),
    );
  }

  void _startShowCase() {
    if (!CacheUtils.isCreateTeamHintShown()) {
      _createTeamsHintKey = GlobalKey();
      _archiveHintKey = GlobalKey();
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([_createTeamsHintKey!, _archiveHintKey!]));
      CacheUtils.setCreateTeamHint();
    }
  }


  /**
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 3) {
              _createInterstitialAd();
            }
          },
        ));
  }
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
  void _showAdvSnackBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppFunctions.showAdvSnackBar(context);
    });
  }
  **/
}
