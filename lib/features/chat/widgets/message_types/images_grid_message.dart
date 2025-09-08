import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_image_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/image_message.dart';

class ImagesGridMessage extends StatelessWidget {
  const ImagesGridMessage({Key? key,required this.images}) : super(key: key);
  final List<ChatImageModel> images;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: images.length > 1 ? 2 : 1,
      childAspectRatio: 1,
      crossAxisSpacing: 5.w,
      mainAxisSpacing: 8.w,
      children: images
          .map((e) => ImageMessage(
        image: e,
        width: images.length > 1
            ? context.width * .35
            : context.width * .7,
      ))
          .toList(),
    );
  }
}
