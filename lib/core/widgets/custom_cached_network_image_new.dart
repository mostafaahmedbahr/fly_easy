import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class CustomNetWorkImage extends StatelessWidget {
  const CustomNetWorkImage({super.key, required this.imageUrl, required this.raduis,
    this.width,
    this.height, this.fit,
  });
  final String imageUrl;
  final double raduis;
  final double? height;
  final double? width;
  final  BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(raduis),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        fit:fit ?? BoxFit.contain,
        placeholder: (context, url) =>   Center(child:   Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(raduis),
            ),
          ),
        )),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}