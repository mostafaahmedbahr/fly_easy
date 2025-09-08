import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'invite_members_state.dart';

class InviteMembersCubit extends Cubit<InviteMembersState> {
  InviteMembersCubit() : super(InviteMembersInitial());

  static InviteMembersCubit get(BuildContext context) =>
      BlocProvider.of<InviteMembersCubit>(context);

  static const _pageSize = 15;
  String? searchKey;
  Future<void> getMembers({
    required int pageKey,
    required PagingController<int, MemberModel> pagingController,
  }) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'search': searchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.members, query: queryParameters);
        if (response.statusCode == 200) {
          List<MemberModel> list = [];
          response.data['data'].forEach((member) {
            list.add(MemberModel.fromJson(member));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            pagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        pagingController.error = errorMessage;
        emit(GetMembersError(errorMessage));
      }
    }
  }

  List<MemberModel> selectedMembers = [];

  void selectMember(MemberModel member) {
    selectedMembers.add(member);
  }

  void unSelectMember(int memberId) {
    selectedMembers.removeWhere((element) => element.id == memberId);
  }
}
