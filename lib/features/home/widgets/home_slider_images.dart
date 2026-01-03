
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/custom_cached_network_image_new.dart';
import '../bloc/home_cubit.dart';
import 'home_slider_images_loading.dart';

class HomeSliderImages extends StatelessWidget {
  const HomeSliderImages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var homeCubit = context.read<HomeCubit>();
        return
          state is GetHomeBannersLoadingState || homeCubit.bannersModel==null? HomeSliderImagesLoading():
          CarouselSlider(
          items: homeCubit.bannersModel!.banners.map((slider) {
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomNetWorkImage(
                    height: 140.h,
                    width: MediaQuery.of(context).size.width,
                    imageUrl: slider.toString(),
                    raduis: 16,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: homeCubit.bannersModel!.banners
                        .asMap()
                        .entries
                        .map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: homeCubit.currentSliderIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ],
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            height: 170,
            aspectRatio: MediaQuery.of(context).size.width / 250,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              homeCubit.changeHomeSliderImages(index);
            },
          ),
        );
      },
    );
  }
}
