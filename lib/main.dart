import 'dart:ui';

import 'package:Movies_Channel/MovieTypes.dart';
import 'package:Movies_Channel/StartScreen.dart';
import 'package:Movies_Channel/lastScreen.dart';
import 'package:Movies_Channel/listScreen.dart';
import 'package:Movies_Channel/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:rating_dialog/rating_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/start": (BuildContext context) => StartScreen(),
        "/list": (BuildContext context) => ListScreen(),
        "/types": (BuildContext context) => MovieTypes(),
        "/last": (BuildContext context) => LastScreen(),
      },
    );
  }
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  bool _isInterstitialAdLoaded = false;
  bool keepExpandedWhileLoading = false;
  bool _isRewardedAdLoaded = false;
  bool _isRewardedVideoComplete = false;

  void initState() {
    super.initState();

    FacebookAudienceNetwork.init(
      testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
    );
    _showBannerAd();
    _showInterstitialAd();
    _showNativeAd();
    _showNativeBannerAd();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      listener: (result, value) {
        print(" $result --> $value");
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
      listener: (result, value) {},
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
          title: Center(child: Text("Movie Cinema")),
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
            _native,
            Positioned(
              top: 175,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    _rowButtons(Icons.videocam, "Start", () {
                      _showInterstitialAd();
                      Navigator.of(context).pushNamed("/start");
                    }),
                    _rowButtons(Icons.star, "Rate", show),
                    _rowButtons(Icons.share, "Share", () {}),
                    _rowButtons(Icons.more_horiz, "More", () {}),
                  ],
                ),
              ),
            ),
            Positioned(top: 560, child: _current),
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

  void show() {
    showDialog(
        context: context,
        builder: (context) {
          return RatingDialog(
            icon: Container(
              height: 250,
              width: 250,
              child: Image.asset('asset/back.png'),
            ),
            title: 'The Rating Dialog',
            description: 'Tap a Star to set your Rating!',
            onSubmitPressed: (int rating) {
              print('rating: $rating');
            },
            submitButton: 'SUBMIT',
            accentColor: Colors.black,
            positiveComment: 'Thanks For Your Review',
            negativeComment: 'Thanks For Your Review',
          );
        });
  }

  Widget _rowButtons(var icons, String title, var route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: route,
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
            width: 180,
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(icons),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
