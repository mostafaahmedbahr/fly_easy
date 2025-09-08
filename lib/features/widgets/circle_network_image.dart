import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  CircleNetworkImage({Key? key, required this.width, required this.imageUrl})
      : super(key: key);
  String imageUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => ClipOval(
            child: Container(
          height: width,
          width: width,
          color: Colors.grey.withOpacity(.5),
        )),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fadeInCurve: Curves.ease,
        fadeInDuration: const Duration(milliseconds: 300),
        fit: BoxFit.cover,
        // You can use BoxFit.fill, BoxFit.contain, etc.
        width: width,
        height: width,
      ),
    );
  }
}
