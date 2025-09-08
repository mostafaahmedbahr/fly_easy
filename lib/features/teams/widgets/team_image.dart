import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamImage extends StatelessWidget {
  const TeamImage(
      {super.key,
      required this.imageUrl,
      required this.teamId,
      required this.width,
      required this.notificationsNumber});

  final String imageUrl;
  final String teamId;
  final double width;
  final int notificationsNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => ClipOval(
                child: Container(
              height: width,
              width: width,
              color: Colors.grey.withOpacity(.5),
            )),
            fadeInCurve: Curves.ease,
            fadeInDuration: const Duration(milliseconds: 300),
            fit: BoxFit.cover,
            height: width,
            width: width,
          ),
        ),
        Visibility(
          visible: notificationsNumber > 0,
          replacement: const SizedBox.shrink(),
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 12,
            child: Text(
              notificationsNumber > 99 ? '+99' : '$notificationsNumber',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          ),
        )
      ],
    );
  }
}
