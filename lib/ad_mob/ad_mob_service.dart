import 'dart:io';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-8718188273675259/7569025252';
    }else if(Platform.isIOS){
      return 'ca-app-pub-8718188273675259/1719283847';
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-8718188273675259/8692290229';
    }else if(Platform.isIOS){
      return 'ca-app-pub-8718188273675259/7762351931';
    }
    return null;
  }

  static String? get rewardedAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-5231374671199362/5715079611';
    }else if(Platform.isIOS){
      return '';
    }
    return null;
  }

  static void createBannerAd(void Function(Ad)? onAdLoaded) {
    BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerAdUnitId!,
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            if (kDebugMode) {
              print(error.message);
              print(error.responseInfo);
              print(
                  'Failed//////////////////////////////////////////////////////');
            }
            ad.dispose();
          },
          onAdClosed: (ad) {
            if (kDebugMode) {
              print('Closed//////////////////////////////////////////////////////////');
            }
            ad.dispose();
          },
          onAdLoaded: onAdLoaded,
        ),
        request: const AdRequest())
        .load();
  }


}

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
// const String testDevice = 'YOUR_DEVICE_ID';
// const int maxFailedLoadAttempts = 3;
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );
//
//   static const interstitialButtonText = 'InterstitialAd';
//   static const rewardedButtonText = 'RewardedAd';
//   static const rewardedInterstitialButtonText = 'RewardedInterstitialAd';
//   static const fluidButtonText = 'Fluid';
//   static const inlineAdaptiveButtonText = 'Inline adaptive';
//   static const anchoredAdaptiveButtonText = 'Anchored adaptive';
//   static const nativeTemplateButtonText = 'Native template';
//   static const webviewExampleButtonText = 'Register WebView';
//   static const adInspectorButtonText = 'Ad Inspector';
//
//   InterstitialAd? _interstitialAd;
//   int _numInterstitialLoadAttempts = 0;
//
//   RewardedAd? _rewardedAd;
//   int _numRewardedLoadAttempts = 0;
//
//   RewardedInterstitialAd? _rewardedInterstitialAd;
//   int _numRewardedInterstitialLoadAttempts = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: [testDevice]));
//     _createInterstitialAd();
//     _createRewardedAd();
//     _createRewardedInterstitialAd();
//   }
//
//   void _createInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-7319269804560504/8512599311'
//             : 'ca-app-pub-3940256099942544/4411468910',
//         request: request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             print('$ad loaded');
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             _interstitialAd!.setImmersiveMode(true);
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('InterstitialAd failed to load: $error.');
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;
//             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               _createInterstitialAd();
//             }
//           },
//         ));
//   }
//
//   void _showInterstitialAd() {
//     if (_interstitialAd == null) {
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//     );
//     _interstitialAd!.show();
//     _interstitialAd = null;
//   }
//
//   void _createRewardedAd() {
//     RewardedAd.load(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-3940256099942544/5224354917'
//             : 'ca-app-pub-3940256099942544/1712485313',
//         request: request,
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (RewardedAd ad) {
//             print('$ad loaded.');
//             _rewardedAd = ad;
//             _numRewardedLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('RewardedAd failed to load: $error');
//             _rewardedAd = null;
//             _numRewardedLoadAttempts += 1;
//             if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
//               _createRewardedAd();
//             }
//           },
//         ));
//   }
//
//   void _showRewardedAd() {
//     if (_rewardedAd == null) {
//       print('Warning: attempt to show rewarded before loaded.');
//       return;
//     }
//     _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createRewardedAd();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createRewardedAd();
//       },
//     );
//
//     _rewardedAd!.setImmersiveMode(true);
//     _rewardedAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//           print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//         });
//     _rewardedAd = null;
//   }
//
//   void _createRewardedInterstitialAd() {
//     RewardedInterstitialAd.load(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-3940256099942544/5354046379'
//             : 'ca-app-pub-3940256099942544/6978759866',
//         request: request,
//         rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//           onAdLoaded: (RewardedInterstitialAd ad) {
//             print('$ad loaded.');
//             _rewardedInterstitialAd = ad;
//             _numRewardedInterstitialLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('RewardedInterstitialAd failed to load: $error');
//             _rewardedInterstitialAd = null;
//             _numRewardedInterstitialLoadAttempts += 1;
//             if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               _createRewardedInterstitialAd();
//             }
//           },
//         ));
//   }
//
//   void _showRewardedInterstitialAd() {
//     if (_rewardedInterstitialAd == null) {
//       print('Warning: attempt to show rewarded interstitial before loaded.');
//       return;
//     }
//     _rewardedInterstitialAd!.fullScreenContentCallback =
//         FullScreenContentCallback(
//           onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
//               print('$ad onAdShowedFullScreenContent.'),
//           onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
//             print('$ad onAdDismissedFullScreenContent.');
//             ad.dispose();
//             _createRewardedInterstitialAd();
//           },
//           onAdFailedToShowFullScreenContent:
//               (RewardedInterstitialAd ad, AdError error) {
//             print('$ad onAdFailedToShowFullScreenContent: $error');
//             ad.dispose();
//             _createRewardedInterstitialAd();
//           },
//         );
//
//     _rewardedInterstitialAd!.setImmersiveMode(true);
//     _rewardedInterstitialAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//           print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//         });
//     _rewardedInterstitialAd = null;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _interstitialAd?.dispose();
//     _rewardedAd?.dispose();
//     _rewardedInterstitialAd?.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Builder(builder: (BuildContext context) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('AdMob Plugin example app'),
//             actions: <Widget>[
//               PopupMenuButton<String>(
//                 onSelected: (String result) {
//                   switch (result) {
//                     case interstitialButtonText:
//                       _showInterstitialAd();
//                       break;
//                     case rewardedButtonText:
//                       _showRewardedAd();
//                       break;
//                     case rewardedInterstitialButtonText:
//                       _showRewardedInterstitialAd();
//                       break;
//                     case adInspectorButtonText:
//                       MobileAds.instance.openAdInspector((error) => log(
//                           'Ad Inspector ${error == null
//                                   ? 'opened.'
//                                   : 'error: ${error.message ?? ''}'}'));
//                       break;
//                     default:
//                       throw AssertionError('unexpected button: $result');
//                   }
//                 },
//                 itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                   const PopupMenuItem<String>(
//                     value: interstitialButtonText,
//                     child: Text(interstitialButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: rewardedButtonText,
//                     child: Text(rewardedButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: rewardedInterstitialButtonText,
//                     child: Text(rewardedInterstitialButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: fluidButtonText,
//                     child: Text(fluidButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: inlineAdaptiveButtonText,
//                     child: Text(inlineAdaptiveButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: anchoredAdaptiveButtonText,
//                     child: Text(anchoredAdaptiveButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: nativeTemplateButtonText,
//                     child: Text(nativeTemplateButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: webviewExampleButtonText,
//                     child: Text(webviewExampleButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: adInspectorButtonText,
//                     child: Text(adInspectorButtonText),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           body: const SafeArea(child: SizedBox()),
//         );
//       }),
//     );
//   }
// }




