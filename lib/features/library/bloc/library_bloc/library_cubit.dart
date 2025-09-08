import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/library/models/section_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitial());

  static LibraryCubit get(BuildContext context) =>
      BlocProvider.of<LibraryCubit>(context);

  static const _pageSize = 15;

  Future<void> getAllSections(
      PagingController<int, SectionModel> sectionsPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
        };
        final response = await DioHelper.getData(
            path: EndPoints.allLibrarySections, query: queryParameters);
        if (response.statusCode == 200) {
          List<SectionModel> list = [];
          response.data['data'].forEach((section) {
            list.add(SectionModel.fromJson(section));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            sectionsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            sectionsPagingController.appendPage(list, nextPageKey as int);
          }
          HiveUtils.cacheSections(list);
        }
      } catch (error) {
        final String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        sectionsPagingController.error = errorMessage;
        emit(GetSectionsError(errorMessage));
      }
    } else {
      var cachedSections = HiveUtils.getCachedSections();
      if (cachedSections.isNotEmpty) {
        sectionsPagingController.appendLastPage(cachedSections);
      } else {
        sectionsPagingController.error = AppStrings.checkInternet;
        emit(GetSectionsError(AppStrings.checkInternet));
      }
    }
  }
}
