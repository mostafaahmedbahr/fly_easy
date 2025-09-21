import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/ad_mob/ad_mob_service.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/search/bloc/search_cubit.dart';
import 'package:new_fly_easy_new/features/search/screens/search_members_view.dart';
import 'package:new_fly_easy_new/features/search/screens/search_teams_view.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/widgets/tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  SearchCubit get cubit => SearchCubit.get(context);
  late TabController _tabController;
  final PagingController<int, MemberModel> _membersPagingController = PagingController<int, MemberModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, TeamModel> _teamsPagingController = PagingController<int, TeamModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _showAdvSnackBar();
    // _createInterstitialAd();
  }

  @override
  void dispose() {
    _membersPagingController.dispose();
    _teamsPagingController.dispose();
    // _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listenWhen: (previous, current) => current is ErrorState,
      listener: (context, state) {
        if (state is ErrorState) {
          AppFunctions.showToast(
              message: state.error, state: ToastStates.error);
        }
      },
      child: Scaffold(
        appBar: _appBar(),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              TabBarWidget(tabController: _tabController, tabs: [
                Tab(child: Text(LocaleKeys.members.tr())),
                Tab(child: Text(LocaleKeys.teams.tr())),
              ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                    SearchTeamView(
                        teamsPagingController: _teamsPagingController),
                    SearchMembersView(
                      membersPagingController: _membersPagingController,
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          LocaleKeys.search.tr(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      );

  /// ////////////////////////////////
  /// ///////// Helper Methods ////////
  /// ////////////////////////////////

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

  void _showAdvSnackBar(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppFunctions.showAdvSnackBar(context);
    });
  }
}
