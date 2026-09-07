import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'storage_service.dart';

/// Wraps all ad logic in one place so screens never touch the ad SDK
/// directly. Premium users bypass every method here as a no-op.
///
/// Replace the test ad unit IDs below with your real AdMob IDs before
/// release, and keep separate IDs per platform (Android/iOS).
class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  static const String bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // test ID
  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // test ID

  RewardedAd? _rewardedAd;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _preloadRewarded();
  }

  Future<bool> _isPremium() => StorageService.instance.isPremium();

  BannerAd createBannerAd({required void Function() onLoaded}) {
    final banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) => onLoaded()),
    );
    banner.load();
    return banner;
  }

  void _preloadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (_) => _rewardedAd = null,
      ),
    );
  }

  /// Shows a rewarded interstitial before an exam starts. Premium users
  /// skip straight through. Returns true once the user may proceed.
  Future<bool> showBeforeExamAd() async {
    if (await _isPremium()) return true;
    if (_rewardedAd == null)
      return true; // fail-open: never block the exam on an ad failure

    bool proceed = false;
    final completer = Future<bool>(() async {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _preloadRewarded();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (_, __) => proceed = true);
      return proceed;
    });
    await completer;
    return true; // fail-open by design — see note above
  }
}
