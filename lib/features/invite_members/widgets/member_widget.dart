import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/invite_members/bloc/invite_members_cubit.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class MemberWidget extends StatefulWidget {
  const MemberWidget({Key? key, required this.member, this.isSelected = false})
      : super(key: key);
  final MemberModel member;
  final bool isSelected;

  @override
  State<MemberWidget> createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  InviteMembersCubit get cubit => InviteMembersCubit.get(context);
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleNetworkImage(
          width: 45.w,
          imageUrl: widget.member.image,
        ),
        10.w.width,
        Expanded(child:Text(
          widget.member.name,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),),
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         widget.member.name,
        //         style: Theme.of(context)
        //             .textTheme
        //             .labelSmall!
        //             .copyWith(fontWeight: FontWeight.w600),
        //       ),
        //       SizedBox(height: 3.h,),
        //       Text(
        //         widget.member.phone,
        //         style: Theme.of(context)
        //             .textTheme
        //             .bodySmall!
        //             .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
        //       )
        //     ],
        //   ),
        // ),
        InkWell(
          onTap: () {
            if (isSelected) {
              cubit.unSelectMember(widget.member.id);
            } else {
              cubit.selectMember(widget.member);
            }
            setState(() {
              isSelected = !isSelected;
            });
          },
          enableFeedback: true,
          radius: 20,
          child: Container(
            height: 25.w,
            width: 25.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).indicatorColor
                    : Colors.transparent,
                border: Border.all(color: Theme.of(context).indicatorColor)),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  )
                : null,
          ),
        ),
        10.w.width
      ],
    );
  }
}
