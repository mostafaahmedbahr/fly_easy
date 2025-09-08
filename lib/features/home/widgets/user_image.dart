import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w),
        child: InkWell(
          onTap: () => sl<AppRouter>()
              .navigatorKey
              .currentState!
              .pushNamed(Routes.profile),
          child: BlocBuilder<GlobalAppCubit,GlobalAppState>(
            buildWhen: (previous, current) => current is RefreshUserImage,
            builder: (context, state) =>  CircleAvatar(
              radius: 20.h,
              backgroundImage: CachedNetworkImageProvider(HiveUtils.getUserData()!.image),
            ),
          ),
        ));
  }
}
