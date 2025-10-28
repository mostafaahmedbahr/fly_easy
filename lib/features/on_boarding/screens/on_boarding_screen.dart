// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
// import 'package:new_fly_easy_new/core/routing/routes.dart';
// import 'package:new_fly_easy_new/core/utils/colors.dart';
// import 'package:new_fly_easy_new/core/utils/images.dart';
// import 'package:new_fly_easy_new/features/on_boarding/widgets/customPage.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});
//
//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }
//
// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   late final PageController _pageController;
//   bool _isLast = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(bottom: 15.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: PageView(
//                   scrollDirection: Axis.horizontal,
//                   controller: _pageController,
//                   children: _onBoardingPages,
//                   onPageChanged: (value) => _changeIsLast(value),
//                 ),
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           _navigateToLogin();
//                         },
//                         child: Text(
//                           'Skip',
//                           style: TextStyle(
//                               color: const Color(0xFF2D2B2E).withOpacity(.6),
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w600),
//                         )),
//                     SmoothPageIndicator(
//                       controller: _pageController,
//                       count: _onBoardingPages.length,
//                       effect:  ExpandingDotsEffect(
//                         activeDotColor: AppColors.lightPrimaryColor,
//                         dotHeight: 8,
//                         dotWidth: 8,
//                         dotColor:  const Color(0xFF2D2B2E).withOpacity(.6),
//                       ),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           if (_isLast) {
//                             _navigateToLogin();
//                           } else {
//                             _pageController.nextPage(
//                               duration: const Duration(milliseconds: 750),
//                               curve: Curves.fastLinearToSlowEaseIn,
//                             );
//                           }
//                         },
//                         child: Text('Next',
//                             style: Theme.of(context).textTheme.titleLarge)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   final List<Widget> _onBoardingPages = [
//     const CustomPage(
//         title: 'Welcome to TeamsApp.',
//         image: AppImages.onBoarding1,
//         description:
//             'Teams is a mobile app that revolutionizes how companies work. \nTeams is a smart and easy way to improve your business performance and communication.'),
//     const CustomPage(
//         title: 'Expand your network daily with new connections',
//         image: AppImages.onBoarding2,
//         description: 'Create your own teams, add friends, chat and share information, make high-quality and secured voice and video calls, and more.'),
//     const CustomPage(
//         title: 'Create your first team now ',
//         image: AppImages.onBoarding3,
//         description:
//             'Teams is a highly secure mobile application that uses the best end-to-end encryption technology to protect your data and communication.'),
//   ];
//
// /// ////////////////////////////////////////
// /// ///////////////// Helper Methods ////////
// /// ///////////////////////////////////////
//
//   _changeIsLast(int page) {
//     if (page == 2) {
//       _isLast = true;
//     } else {
//       _isLast = false;
//     }
//   }
//
//   _navigateToLogin() {
//     CacheUtils.setIsOpenedBefore();
//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       Routes.welcome,
//       (route) => false,
//     );
//   }
// }
