import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit() : super(TeamsInitial());

  static const _pageSize = 15;
  final PagingController<int, TeamModel> joinedTeamsPagingController = PagingController<int, TeamModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, TeamModel> adminTeamsPagingController = PagingController<int, TeamModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, TeamModel> archivedTeamsPagingController = PagingController<int, TeamModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);

  Future<void> getJoinedTeams(int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.guestChannels, query: queryParameters);
        if (response.statusCode == 200) {
          List<TeamModel> list = [];
          response.data['data'].forEach((team) {
            list.add(TeamModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            joinedTeamsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            joinedTeamsPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        joinedTeamsPagingController.error = errorMessage;
        // emit(GetGuestChannelsError(errorMessage));
      }
    } else {
      String errorMessage = LocaleKeys.check_internet.tr();
      joinedTeamsPagingController.error = errorMessage;
    }
  }
  Future<void> getAdminTeams(int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.adminChannels, query: queryParameters);
        if (response.statusCode == 200) {
          List<TeamModel> list = [];
          response.data['data'].forEach((team) {
            list.add(TeamModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            adminTeamsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            adminTeamsPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        adminTeamsPagingController.error = errorMessage;
        emit(GetAdminChannelsError(errorMessage));
      }
    } else {
      String errorMessage = LocaleKeys.check_internet.tr();
      adminTeamsPagingController.error = errorMessage;
      emit(GetAdminChannelsError(errorMessage));
    }
  }
  Future<void> getArchivedTeams(int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.archivedChannels, query: queryParameters);
        if (response.statusCode == 200) {
          List<TeamModel> list = [];
          response.data['data'].forEach((team) {
            list.add(TeamModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            archivedTeamsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            archivedTeamsPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        archivedTeamsPagingController.error = errorMessage;
        // emit(GetArchivedTeamsError(errorMessage));
      }
    } else {
      String errorMessage = LocaleKeys.check_internet.tr();
      archivedTeamsPagingController.error = errorMessage;
    }
  }

  Future<void> deleteTeam(int teamId) async {
    emit(DeleteTeamLoad());
    try {
      final response = await DioHelper.deleteData(
          path: '${EndPoints.deleteChannel}/$teamId');
      if (response.statusCode == 200) {
        UserModel updatedUserCharge = UserModel.fromJson(response.data['data']);
        await HiveUtils.setUserData(updatedUserCharge);
        emit(DeleteTeamSuccess(teamId));
      }
    } catch (error) {
      emit(DeleteChannelError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> deleteCommunity(int communityId, int teamId) async {
    emit(DeleteTeamLoad());
    try {
      final response = await DioHelper.deleteData(
          path: '${EndPoints.deleteChannel}/$communityId');
      if (response.statusCode == 200) {
        UserModel updatedUserCharge = UserModel.fromJson(response.data['data']);
        await HiveUtils.setUserData(updatedUserCharge);
        emit(DeleteCommunitySuccess(teamId, communityId));
      }
    } catch (error) {
      emit(DeleteChannelError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }
  Future<void> deleteSubCommunitySuccess(int teamId, int communityId, int subCommunityId) async {
    emit(DeleteTeamLoad());
    try {
      final response = await DioHelper.deleteData(
          path: '${EndPoints.deleteChannel}/$subCommunityId');
      if (response.statusCode == 200) {
        UserModel updatedUserCharge = UserModel.fromJson(response.data['data']);
        await HiveUtils.setUserData(updatedUserCharge);
        emit(DeleteSubCommunitySuccess(teamId, communityId, subCommunityId));
      }
    } catch (error) {
      emit(DeleteChannelError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> archiveChannel(int channelId) async {
    emit(AddToArchiveLoad());
    try {
      final response = await DioHelper.postData(
          path: EndPoints.archiveChannel, data: {'channel_id': channelId});
      if (response.statusCode == 200) {
        emit(AddToArchiveSuccess(channelId));
      }
    } catch (error) {
      emit(AddToArchiveError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> deleteArchiveChannel(int channelId) async {
    emit(DeleteArchiveLoad());
    try {
      final response = await DioHelper.deleteData(
          path: '${EndPoints.deleteChannel}/$channelId');
      if (response.statusCode == 200) {
        UserModel updatedUserCharge = UserModel.fromJson(response.data['data']);
        await HiveUtils.setUserData(updatedUserCharge);
        emit(DeleteArchiveSuccess(channelId));
      }
    } catch (error) {
      emit(DeleteArchiveError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> duplicateChannel(int channelId) async {
    emit(DuplicateChannelLoad());
    try {
      final response = await DioHelper.postData(
          path: EndPoints.duplicateChannel, data: {'channel_id': channelId});
      if (response.statusCode == 200) {
        UserModel updatedUserCharge = UserModel.fromJson(response.data['data']);
        await HiveUtils.setUserData(updatedUserCharge);
        emit(DuplicateChannelSuccess());
      }
    } catch (error) {
      emit(DuplicateChannelError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }
}
