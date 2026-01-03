
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeSliderImagesLoading extends StatelessWidget {
  const HomeSliderImagesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width:   double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        autoPlay: true,
        height: 170,
        aspectRatio: MediaQuery.of(context).size.width / 250,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          // homeCubit.changeHomeSliderImages(index);
        },
      ),
    );
  }
}
