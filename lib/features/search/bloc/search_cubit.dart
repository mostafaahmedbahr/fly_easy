import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(BuildContext context)=>BlocProvider.of<SearchCubit>(context);

  static const _pageSize = 15;

  String? currentTeamId, currentUserId;


  String? usersSearchKey;
  Future<void> getAvailableUsers(
      PagingController<int, MemberModel> membersPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'search':usersSearchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.myContacts, query: queryParameters);
        if (response.statusCode == 200) {
          List<MemberModel> list = [];
          response.data['data'].forEach((team) {
            list.add(MemberModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            membersPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            membersPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        membersPagingController.error = errorMessage;
        emit(ErrorState(errorMessage));
      }
    } else {
      emit(ErrorState(AppStrings.checkInternet));
    }
  }


  List<TeamModel> myTeams = [];
  String? teamsSearchKey;
  Future<void> getMyTeams(PagingController<int, TeamModel> teamsPagingController, int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'search':teamsSearchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.allTeams, query: queryParameters);
        if (response.statusCode == 200) {
          List<TeamModel> list = [];
          response.data['data'].forEach((team) {
            list.add(TeamModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            teamsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            teamsPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        teamsPagingController.error = errorMessage;
        emit(ErrorState(errorMessage));
      }
    } else {
      emit(ErrorState(AppStrings.checkInternet));
    }
  }
}
