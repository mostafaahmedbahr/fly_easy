import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({Key? key, required this.onPress,required this.title}) : super(key: key);
  final VoidCallback onPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: BlocBuilder<AddChannelCubit, AddChannelState>(
        buildWhen: (previous, current) =>
            current is CreateChannelSuccess ||
            current is CreateChannelError ||
            current is CreateChannelLoad,
        builder: (context, state) => CustomButton(
            width: context.width * .5,
            onPress: onPress,
            buttonType: 1,
            child: state is CreateChannelLoad
                ? const MyProgress(
                    color: Colors.white,
                  )
                : ButtonText(
                    title: title)),
      ),
    );
  }
}
