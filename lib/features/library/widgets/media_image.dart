import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/features/library/models/image_model.dart';

class MediaPhoto extends StatelessWidget {
  const MediaPhoto({Key? key, required this.image}) : super(key: key);
  final ImageModel image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image.imageUrl,
      transitionOnUserGestures: true,
      child: GestureDetector(
        onTap: () => sl<AppRouter>()
            .navigatorKey
            .currentState!
            .pushNamed(Routes.fullImageScreen, arguments: image.imageUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(18.r)),
          child: CachedNetworkImage(
            imageUrl: image.imageUrl,
            placeholder: (context, url) => Container(
              color: Colors.grey.withOpacity(.5),
            ),
            errorWidget: (context, url, error) => Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(.4),
              child: const Icon(Icons.error),
            ),
            fadeInCurve: Curves.ease,
            fadeInDuration: const Duration(milliseconds: 300),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
