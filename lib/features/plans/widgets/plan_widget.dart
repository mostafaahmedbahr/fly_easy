import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/paymob_manager/paymob_manager.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/plans/bloc/plans_cubit.dart';
import 'package:new_fly_easy_new/features/plans/models/plan_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanWidget extends StatelessWidget {
  const PlanWidget({Key? key, required this.color, required this.plan})
      : super(key: key);
  final Color color;
  final PlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 40.w),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${plan.price.toString()} LE',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 40.sp,
              color: Colors.white,
              fontFamily: AppFonts.poppins,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            plan.name.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30.sp,
              color: Colors.white,
              fontFamily: AppFonts.poppins,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          _PlanTypeWidget(plan: plan),
          SizedBox(height: 20.h,),
          Text(LocaleKeys.for_num_months.tr(args: [plan.months.toString()]), style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
              fontFamily: AppFonts.poppins),),
          SizedBox(
            height: 50.h,
          ),
          Container(
            width: context.width * .4,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: BlocBuilder<PlansCubit, PlansState>(
              buildWhen: (previous, current) =>
              current is ChoosePlanSuccess ||
                  current is ChoosePlanError ||
                  current is ChoosePlanLoad,
              builder: (context, state) =>
                  ElevatedButton(
                    onPressed: () async {
                      // await PlansCubit.get(context).choosePlan(plan.id);
                      _pay();
                    },
                    style: Theme
                        .of(context)
                        .elevatedButtonTheme
                        .style!
                        .copyWith(
                        shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.r))),
                        backgroundColor: const MaterialStatePropertyAll(
                            Color(0xffD9D9D9)),
                        textStyle: const MaterialStatePropertyAll(
                            TextStyle(
                                color: AppColors.lightPrimaryColor))),
                    child:
                    (state is ChoosePlanLoad && state.planId == plan.id)
                        ? const MyProgress(
                      color: AppColors.lightPrimaryColor,
                    )
                        : Text(
                      LocaleKeys.choose_plan.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: AppColors.lightPrimaryColor,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }


  Widget _subscribedContainer() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check,
              color: AppColors.lightPrimaryColor,
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              LocaleKeys.subscribed.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      );

  Future<void> _pay() async{
    PaymobManager().getPaymentKey(
        10,"EGP"
    ).then((String paymentKey) {
      launchUrl(
        Uri.parse("https://accept.paymob.com/api/acceptance/iframes/812741?payment_token=$paymentKey"),
      );
    });
  }
}

class _PlanTypeWidget extends StatelessWidget {
  const _PlanTypeWidget({Key? key, required this.plan}) : super(key: key);
  final PlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          _getType(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
              fontFamily: AppFonts.poppins),
        ),
      ],
    );
  }

  String _getType() {
    if (plan.type == PlanType.member.name) {
      return LocaleKeys.num_members.tr(args: [plan.count.toString()]);
    } else if (plan.type == PlanType.team.name) {
      return LocaleKeys.num_teams.tr(args: [plan.count.toString()]);
    } else if (plan.type == PlanType.community.name) {
      return LocaleKeys.num_communities.tr(args: [plan.count.toString()]);
    } else if (plan.type == PlanType.subcommunity.name) {
      return LocaleKeys.num_sub_communities.tr(args: [plan.count.toString()]);
    } else {
      return plan.librarySections![0].name;
    }
  }

}

