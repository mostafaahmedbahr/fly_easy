import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChargeCounter extends StatelessWidget {
  const ChargeCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.lightSecondaryColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child:IntrinsicHeight(
        child: BlocBuilder<GlobalAppCubit,GlobalAppState>(
          buildWhen: (previous, current) => current is RefreshTeamsAfterAdd || current is RefreshTeamsAfterUpdate,
          builder: (context, state) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _CounterInfoWidget(title: LocaleKeys.teams.tr(), value: HiveUtils.getUserData()!.remainsTeamsCount.toString())),
              const _CounterDivider(),
              Expanded(child: _CounterInfoWidget(title:LocaleKeys.communities.tr(), value: HiveUtils.getUserData()!.remainsCommunitiesCount.toString())),
              const _CounterDivider(),
              Expanded(child: _CounterInfoWidget(title: LocaleKeys.sub_community.tr(), value: HiveUtils.getUserData()!.remainsSubCommunitiesCount.toString())),
              const _CounterDivider(),
              Expanded(child: _CounterInfoWidget(title: LocaleKeys.member.tr(), value: HiveUtils.getUserData()!.remainsMembersCount.toString())),

            ],
          ),
        ),
      ),
    );
  }
}

class _CounterInfoWidget extends StatelessWidget {
  const _CounterInfoWidget({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(title, style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          maxLines: 2,
          ),
        ),
        SizedBox(height: 5.h,),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 14.sp),)
      ],
    );
  }
}

class _CounterDivider extends StatelessWidget {
  const _CounterDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5.w,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 8.w,
        vertical: 5.h
      ),
    );
  }
}


