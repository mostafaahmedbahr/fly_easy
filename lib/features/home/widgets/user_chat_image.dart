import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserChatImage extends StatelessWidget {
  const UserChatImage({Key? key,required this.width,required this.imageUrl}) : super(key: key);
final double width;
final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (context, url, error) =>
        const Icon(Icons.error),
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
    );
  }
}
