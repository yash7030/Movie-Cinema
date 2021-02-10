import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Myapp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: const Color(0xff000000),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: new AssetImage(
                  'asset/m2.jpg',
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 60,
            right: 0,
            bottom: 520,
            child: Container(
              height: 350,
              width: 350,
              child: Image(
                image: new AssetImage(
                  'asset/m7.png',
                ),
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              backgroundColor: Colors.black.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
