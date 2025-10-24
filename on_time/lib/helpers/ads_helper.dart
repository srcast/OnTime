import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_time/utils/ads.dart';

class AdsHelper {
  static InterstitialAd? _interstitialAd;
  static bool isInterstitialReady = false;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static Future<BannerAd?> getBannerAdd(BuildContext context) async {
    final width = MediaQuery.of(context).size.width.truncate();

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (size == null) return null;

    var bannerAd = BannerAd(
      adUnitId:
          Platform.isAndroid ? Ads.bannerUnitIdAndroid : Ads.bannerUnitIdiOS,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();

    return bannerAd;
  }

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          Platform.isAndroid
              ? Ads.interstitialUnitIdAndroid
              : Ads.interstitialUnitIdiOS,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialReady = true;

          // Quando o anúncio é fechado, carregamos outro
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load interstitial ad: $error');
          isInterstitialReady = false;
        },
      ),
    );
  }

  static void showInterstitial() {
    if (isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.show();
      isInterstitialReady = false;
      _interstitialAd = null;
    } else {
      debugPrint('[AdsHelper] Interstitial ainda não está pronto');
    }
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    isInterstitialReady = false;
  }
}
