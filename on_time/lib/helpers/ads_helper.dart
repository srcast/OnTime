class AdsHelper {
  // static InterstitialAd? _interstitialAd;
  // static bool isInterstitialReady = false;
  // static Timer? _retryTimer;
  // static int _retryCount = 0;

  // static Future<void> initialize() async {
  //   await MobileAds.instance.initialize();
  // }

  // static Future<BannerAd?> getBannerAdd(BuildContext context) async {
  //   final width = MediaQuery.of(context).size.width.truncate();

  //   final AnchoredAdaptiveBannerAdSize? size =
  //       await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

  //   if (size == null) return null;

  //   final completer = Completer<BannerAd?>();

  //   var bannerAd = BannerAd(
  //     adUnitId:
  //         Platform.isAndroid ? Ads.bannerUnitIdAndroid : Ads.bannerUnitIdiOS,
  //     size: size,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) => completer.complete(ad as BannerAd),
  //       onAdFailedToLoad: (ad, error) {
  //         debugPrint('Banner failed to load: $error');
  //         ad.dispose();
  //         if (!completer.isCompleted) {
  //           completer.complete(null);
  //         }
  //       },
  //     ),
  //   )..load();

  //   return completer.future;
  // }

  // static void loadInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId:
  //         Platform.isAndroid
  //             ? Ads.interstitialUnitIdAndroid
  //             : Ads.interstitialUnitIdiOS,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _interstitialAd = ad;
  //         isInterstitialReady = true;

  //         // Quando o anúncio é fechado, carregamos outro
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             _retryTimer?.cancel();
  //             _retryTimer = Timer(const Duration(seconds: 30), () {
  //               loadInterstitialAd();
  //             });
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             ad.dispose();
  //             _retryTimer?.cancel();
  //             _retryTimer = Timer(const Duration(seconds: 30), () {
  //               loadInterstitialAd();
  //             });
  //           },
  //         );
  //       },
  //       onAdFailedToLoad: (error) {
  //         isInterstitialReady = false;
  //         _retryCount++;
  //         final delay = Duration(seconds: (30 * _retryCount).clamp(30, 300));
  //         _retryTimer?.cancel();
  //         _retryTimer = Timer(delay, () {
  //           loadInterstitialAd();
  //         });
  //       },
  //     ),
  //   );
  // }

  // static void showInterstitial() {
  //   if (isInterstitialReady && _interstitialAd != null) {
  //     _interstitialAd!.show();
  //     isInterstitialReady = false;
  //     _interstitialAd = null;
  //   }
  // }

  // static void dispose() {
  //   _interstitialAd?.dispose();
  //   _interstitialAd = null;
  //   isInterstitialReady = false;
  // }
}
