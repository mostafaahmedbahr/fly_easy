import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';

class ChatMediaImage extends StatelessWidget {
  const ChatMediaImage({Key? key,required this.imageUrl}) : super(key: key);
final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:imageUrl,
      transitionOnUserGestures: true,
      child: GestureDetector(
        onTap: () => sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.fullImageScreen,arguments:imageUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(18.r)),
          child: CachedNetworkImage(imageUrl:imageUrl,
            placeholder: (context, url) => Container(color: Colors.grey.withOpacity(.5),),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fadeInCurve: Curves.ease,
            fadeInDuration: const Duration(milliseconds: 300),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
