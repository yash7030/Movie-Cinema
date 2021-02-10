import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class MovieTypes extends StatefulWidget {
  @override
  _MovieTypesState createState() => _MovieTypesState();
}

class _MovieTypesState extends State<MovieTypes> {
  bool _isInterstitialAdLoaded = false;
  bool keepExpandedWhileLoading = false;

  void initState() {
    super.initState();

    FacebookAudienceNetwork.init(
      testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
    );
    _showBannerAd();
    // _showInterstitialAd();
    _showNativeAd();
    _showNativeBannerAd();
  }

  void _loadInterstitialAd() {
    log("message");
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }

  Widget _currentAd = SizedBox();
  Widget _current = SizedBox();
  Widget _native = SizedBox();
  _showBannerAd() {
    _currentAd = FacebookBannerAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        print("Banner Ad: $result -->  $value");
      },
    );
  }

  _showNativeBannerAd() {
    setState(() {
      _current = _nativeBannerAd();
    });
  }

  Widget _nativeBannerAd() {
    return FacebookNativeAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Colors.black,
      titleColor: Colors.amber,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Banner Ad: $result --> $value");
      },
    );
  }

  _showNativeAd() {
    setState(() {
      _native = _nativeAd();
    });
  }

  Widget _nativeAd() {
    return FacebookNativeAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650",
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.black,
      titleColor: Colors.amber,
      descriptionColor: Colors.white,
      buttonColor: Colors.black,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.deepPurple,
      listener: (result, value) {},
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Movie Cinema"),
          actions: [
            Column(
              children: [
                InkWell(
                  onTap: _showInterstitialAd,
                  child: Container(
                    height: 35,
                    width: 35,
                    child: Image.asset(
                      "asset/g.png",
                    ),
                  ),
                ),
                Text("Live TV")
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                color: const Color(0xff000000),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new AssetImage(
                    'asset/back.png',
                  ),
                ),
              ),
            ),

            Positioned(
              top: 10,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.797,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _native,
                      _rowButtons("All Genres"),
                      _rowButtons("English"),
                      _rowButtons("Hindi"),
                      _rowButtons("TV Sci Horro"),
                      _rowButtons("Acclaimed Us TV Dramas"),
                      _rowButtons("Exciting Tv Shows"),
                      _rowButtons("Dramas"),
                      _rowButtons("Romance"),
                      _rowButtons("Thriller"),
                      _rowButtons("Sci-Fi & Fantasy"),
                      _native,
                      _rowButtons("Horro"),
                      _rowButtons("Award Winning"),
                      _rowButtons("Anime"),
                      _rowButtons("History"),
                      _rowButtons("Sports"),
                      _rowButtons("Documentory"),
                      _rowButtons("Stand Up Comedy"),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(top: 560, child: _current),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _currentAd,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowButtons(String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RaisedButton(
        onPressed: () {
          _showInterstitialAd();
          Navigator.of(context).pushNamed("/last");
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
