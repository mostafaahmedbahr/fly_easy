import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/plans/models/plan_model.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(PlansInitial());

  static PlansCubit get(BuildContext context) =>
      BlocProvider.of<PlansCubit>(context);

  List<PlanModel> plans = [];

  Future<void> getPlans() async {
    emit(GetPlansLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.getData(path: EndPoints.plans);
        if (response.statusCode == 200) {
          response.data['data'].forEach((plan) {
            plans.add(PlanModel.fromJson(plan));
          });
          emit(GetPlansSuccess());
        }
      } catch (error) {
        emit(GetPlansError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(GetPlansError(AppStrings.checkInternet));
    }
  }

  Future<void> choosePlan(int planId) async {
    emit(ChoosePlanLoad(planId));
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(path: EndPoints.selectPlan, data: {
          'plan_id': planId,
        });
        if (response.statusCode == 200) {
          HiveUtils.setUserData(UserModel.fromJson(response.data['data']));
          emit(ChoosePlanSuccess());
        }
      } catch (error) {
        emit(ChoosePlanError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(ChoosePlanError(AppStrings.checkInternet));
    }
  }
}
