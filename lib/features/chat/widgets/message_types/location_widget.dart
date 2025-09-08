import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget(
      {Key? key,
      required this.locationUrl,
      required this.color,
      required this.margin})
      : super(key: key);
  final String locationUrl;
  final EdgeInsetsGeometry margin;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: margin,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                border: Border.all(color: color, width: 2)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              child: SvgPicture.asset(
                AppImages.map,
                fit: BoxFit.cover,
                height: context.height * .3,
                width: context.width*.72,
              ),
            ),
          ),
          const Icon(
            Icons.location_on,
            size: 100,
            color: Colors.red,
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if(await canLaunchUrl(Uri.parse(locationUrl))){
      launchUrl(Uri.parse(locationUrl),mode: LaunchMode.externalApplication);
    }
  }
}
