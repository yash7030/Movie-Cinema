import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class LastScreen extends StatefulWidget {
  @override
  _LastScreenState createState() => _LastScreenState();
}

class _LastScreenState extends State<LastScreen> {
  bool _isInterstitialAdLoaded = false;
  bool keepExpandedWhileLoading = false;

  void initState() {
    super.initState();

    FacebookAudienceNetwork.init(
      testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
    );

    _showNativeAd();
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

  Widget _native = SizedBox();

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

  final styles = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[800],
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _native,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Most of the Movies are available in MOVIE CINEMA. Movies from all languages are available in voot TV. With the trial version of MOVIE CINEMA you can watch any movies for free.",
                    style: styles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Hey!! you can watch it free Follow these Steps!!",
                    style: styles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "1. Click The Below Button and Go To The Next Page",
                    style: styles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "2. Click On Any Of The Ads(Pop up Ads / Ads on the Bottom)",
                    style: styles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "3. When The Ads is clicked You Will be Redirected To Playstore",
                    style: styles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "4. Install The App wich you clicked on the AD",
                    style: styles,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "5. After Doing The Following Steps Reyurn To the App",
                    style: styles,
                  ),
                ),
                _rowButtons("WATCH NOW!"),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
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
