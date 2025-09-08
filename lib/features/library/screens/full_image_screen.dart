import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';

class FullImageScreen extends StatelessWidget {
  const FullImageScreen({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Hero(
              tag: imageUrl,
              transitionOnUserGestures: true,
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: context.height,
                  width: context.width,
                  placeholder: (context, url) => Container(
                    height: context.height,
                    width: context.width,
                    color: Colors.grey.withOpacity(.5),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeInCurve: Curves.ease,
                  fadeInDuration: const Duration(milliseconds: 300),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            IconButton(
                onPressed: () => context.pop(),
                icon:  Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ))
          ],
        ),
      ),
    );
  }
}
