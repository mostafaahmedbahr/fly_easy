import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/plans/bloc/plans_cubit.dart';
import 'package:new_fly_easy_new/features/plans/widgets/plan_widget.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  PlansCubit get cubit => PlansCubit.get(context);

  @override
  void initState() {
    Future.microtask(() => cubit.getPlans());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(LocaleKeys.pricing_and_plans.tr()),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios))
            : null,
      ),
      body: BlocListener<PlansCubit, PlansState>(
        listener: (context, state) {
          if (state is ChoosePlanSuccess) {
            AppFunctions.showToast(
                message: LocaleKeys.you_subscribed_success.tr(),
                state: ToastStates.success);
          } else if (state is ErrorState) {
            AppFunctions.showToast(
                message: state.error, state: ToastStates.error);
          }
        },
        child: BlocBuilder<PlansCubit, PlansState>(
          builder: (context, state) => state is GetPlansLoad
              ? const MyProgress(           )
              : state is GetPlansError
                  ? Center(
                      child: CustomErrorWidget(message: state.error),
                    )
                  : cubit.plans.isEmpty
                      ?  Center(
                          child: EmptyWidget(
                              text: LocaleKeys.no_plans_yet.tr(),
                              image: AppImages.emptyTeams),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 15.h),
                          itemBuilder: (context, index) => PlanWidget(
                              color:(index%2==0)? AppColors.lightPrimaryColor:AppColors.lightSecondaryColor,
                              plan: cubit.plans[index]),
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: 15.h,
                          ),
                          itemCount: cubit.plans.length,
                        ),
        ),
      ),
    );
  }
}
