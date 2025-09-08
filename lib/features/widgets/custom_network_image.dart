import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedNetworkImage extends StatelessWidget {
  const RoundedNetworkImage({super.key,required this.image,this.width,this.height,this.radius});

  final String image;
  final double? height;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius??0),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          color: Colors.grey.withOpacity(.5),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fadeInCurve: Curves.ease,
        fadeInDuration: const Duration(milliseconds: 300),
        fit: BoxFit.cover,
        // You can use BoxFit.fill, BoxFit.contain, etc.
        width: width,
        height: height,
      ),
    );
  }
}
