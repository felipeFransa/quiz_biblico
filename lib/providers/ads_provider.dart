import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class AdsProvider extends ChangeNotifier {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;

  bool get isRewardedReady => _isRewardedReady;

  String get _interstitialAdUnitId => Platform.isAndroid
      ? AppConstants.androidInterstitialAdUnitId
      : AppConstants.iosInterstitialAdUnitId;

  String get _rewardedAdUnitId => Platform.isAndroid
      ? AppConstants.androidRewardedAdUnitId
      : AppConstants.iosRewardedAdUnitId;

  Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      await MobileAds.instance.initialize();
      _loadInterstitial();
      _loadRewarded();
    } catch (e) {
      // Ad initialization failed — app continues without ads
      debugPrint('AdMob init error: $e');
    }
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
        },
      ),
    );
  }

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          notifyListeners();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedReady = false;
              notifyListeners();
              _loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedReady = false;
              notifyListeners();
              _loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedReady = false;
          notifyListeners();
        },
      ),
    );
  }

  Future<void> maybeShowInterstitial() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesCompleted =
        prefs.getInt(AppConstants.keyGamesCompleted) ?? 0;
    final next = gamesCompleted + 1;
    await prefs.setInt(AppConstants.keyGamesCompleted, next);

    if (next % AppConstants.gamesBeforeInterstitial == 0 &&
        _isInterstitialReady &&
        _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  Future<void> showRewarded({required VoidCallback onRewarded}) async {
    if (!_isRewardedReady || _rewardedAd == null) {
      onRewarded(); // fallback: grant reward anyway if ad not ready
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (_, __) => onRewarded(),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }
}
