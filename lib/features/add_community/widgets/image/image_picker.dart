import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';

class PickerWidget extends StatelessWidget {
  const PickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AddChannelCubit.get(context).pickImage(),
      child: Container(
        decoration:  BoxDecoration(
          color:Theme.of(context).primaryColorLight,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        height: context.height * .9 * .18,
        width: context.height * .9 * .18,
        child:DottedBorder(
            radius: const Radius.circular(15),
            borderType: BorderType.RRect,
            dashPattern: const [8],
            strokeWidth: 2,
            color:Theme.of(context).indicatorColor,
            child:  Align(
              child: Icon(Icons.add_circle_outline,color:Theme.of(context).indicatorColor,size: 50,),
            )),
      ),
    );
  }
}


