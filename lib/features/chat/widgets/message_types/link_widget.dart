import 'package:flutter/material.dart';
 import 'package:flutter_link_previewer/flutter_link_previewer.dart';

class LinkWidget extends StatefulWidget {
  const LinkWidget({super.key,required this.url});
final String url;
  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  dynamic previewData;

  @override
  Widget build(BuildContext context) {
    return LinkPreview(
      // textStyle: const TextStyle(color: Colors.black),
      // metadataTextStyle:
      // const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      // metadataTitleStyle:
      // const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      enableAnimation: true,
      animationDuration: const Duration(seconds: 1),

      // openOnPreviewImageTap: true,
      // openOnPreviewTitleTap: true,
      // onPreviewDataFetched: (data) {
      //   setState(() {
      //     previewData = data;
      //   });
      // },
      // previewData: previewData,
      text: widget.url,
      onLinkPreviewDataFetched: (linkPreviewData ) {
          setState(() {
            previewData = linkPreviewData ;
          });
      },
      // width: context.width,

    );
  }
}
// AnyLinkPreview(
// link: 'https://www.youtube.com/watch?v=gPGESeQtHlE',
// displayDirection: UIDirection.uiDirectionVertical,
// cache: const Duration(days: 10),
// showMultimedia: true,
// backgroundColor: Colors.grey[300],
// errorWidget: Container(
// color: Colors.grey[300],
// child:  Text(AppStrings.errorMessage),
// ),
// borderRadius: 10.r,
// bodyMaxLines: 2,
// bodyTextOverflow: TextOverflow.ellipsis,
// removeElevation: false,
// )
