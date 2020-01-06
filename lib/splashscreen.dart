import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool f = false;
  double op = 0.0;
  int elareBlinking = 0;
  Timer tim;
  @override
  void initState() {
    super.initState();
    tim = Timer.periodic(Duration(milliseconds: 2000), (t) {
      f = !f;
      if (elareBlinking == 1)
        stopTimer();
      else {
        elareBlinking++;
        setState(() {});
      }
    });
  }

  void stopTimer() {
    tim.cancel();
    Navigator.of(context).pushNamed("boygirl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 1500),
              crossFadeState:
                  f ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Text(
                "ELARE",
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              secondChild: Text(
                "ELARE",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
