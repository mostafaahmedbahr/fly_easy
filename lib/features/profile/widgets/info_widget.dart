import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/profile/bloc/profile_cubit.dart';
import 'package:new_fly_easy_new/features/profile/widgets/pick_image_bottom_sheet.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';
import 'dart:math' as math;

class InfoWidget extends StatefulWidget {
  const InfoWidget({Key? key}) : super(key: key);

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  ProfileCubit get cubit=>ProfileCubit.get(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            BlocBuilder<ProfileCubit,ProfileState>(
              buildWhen: (previous, current) => current is UpdateImageSuccess,
              builder: (context, state) =>  CircleNetworkImage(
                  width: 110.w, imageUrl: HiveUtils.getUserData()!.image),
            ),
            PositionedDirectional(
                end: 0,
                bottom: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  enableFeedback: true,
                  onTap:_showImageSourceBottomSheet,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.w),
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.circle,
                      color: AppColors.lightPrimaryColor,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) => current is RefreshUserData,
            builder: (context, state) => Text(
                  HiveUtils.getUserData()!.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
        SizedBox(
          height: 5.h,
        ),
        Text(
          HiveUtils.getUserData()!.email,
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }

  void _showImageSourceBottomSheet(){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r))),
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
          heightFactor: .25,
          child: ImageSourceBottomSheet(
            cubit: cubit,
          )),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({super.key, this.diameter = 200});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}
