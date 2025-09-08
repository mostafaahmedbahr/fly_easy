import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/image/image_item.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/image/image_picker.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddChannelCubit cubit = AddChannelCubit.get(context);
    return BlocBuilder<AddChannelCubit, AddChannelState>(
      buildWhen: (previous, current) => current is PickImageSuccess,
      builder: (context, state) =>
          (cubit.pickedImage == null && cubit.channelDetails?.logo == null)
              ? const PickerWidget()
              : ImageItem(
                  path: AddChannelCubit.get(context).pickedImage?.path,
                  url: AddChannelCubit.get(context).channelDetails?.logo,
                  remove: () => AddChannelCubit.get(context).removeImage(),
                ),
    );
  }
}
