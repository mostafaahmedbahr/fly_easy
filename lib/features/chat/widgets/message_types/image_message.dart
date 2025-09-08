import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_image_model.dart';

class ImageMessage extends StatelessWidget {
  ImageMessage({Key? key, required this.image, required this.width})
      : super(key: key);
  ChatImageModel image;
  double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (previous, current) => current is UploadImageSuccess && current.imageVirtualId==image.virtualId,
            builder: (context, state) => Stack(
              alignment: Alignment.center,
              children: [
                FittedBox(
                    fit: BoxFit.cover,
                    child: image.imageUrl != null
                        ? InkWell(
                            onTap: () => sl<AppRouter>()
                                .navigatorKey
                                .currentState!
                                .pushNamed(Routes.fullImageScreen,
                                    arguments: image.imageUrl),
                            child: CachedNetworkImage(
                              imageUrl: image.imageUrl!,
                              width: width,
                              height: width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey.withOpacity(.5)),
                              fadeInCurve: Curves.ease,
                              fadeInDuration: const Duration(milliseconds: 300),
                            ),
                          )
                        : Image.file(
                            image.file!,
                            width: width,
                            height: width,
                            fit: BoxFit.cover,
                          )),
                Visibility(
                    visible: image.imageUrl == null,
                    replacement: const SizedBox.shrink(),
                    child: const MyProgress(color: AppColors.lightPrimaryColor))
              ],
            ),
          ),
        ));
  }
}
