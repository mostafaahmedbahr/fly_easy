import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({Key? key,required this.onTab,}) : super(key: key);
final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    // AddChannelCubit cubit=AddChannelCubit.get(context);
    return InkWell(
      enableFeedback: true,
      radius: 25.r,
      onTap: onTab,
      child: CircleAvatar(
        backgroundColor: AppColors
            .lightSecondaryColor
            .withOpacity(.5),
        radius: 22.r,
        child: Icon(Icons.add,
            color: Theme.of(context).indicatorColor,
            size: 25),
      ),
    );
  }
}
