import 'dart:async';
import 'package:elare/variables.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart' as spl;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool f = false;
  double op = 0.0;
  int elareBlinking = 0;
  Timer tim;
  @override
  void initState() {
    super.initState();
    initialiseThings();
    getInterests();
    tim = Timer(Duration(milliseconds: 100), () {
      f = !f;
      setState(() {});
      stopTimer();
    });
  }

  void stopTimer() async {
    tim.cancel();
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.of(context).pushNamed("home");
    print(interests);
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
              duration: Duration(milliseconds: 1000),
              crossFadeState:
                  f ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Text(
                "ELARE",
                style: TextStyle(
                  fontSize: 56,
                  fontFamily: 'brandon',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
              secondChild: Text(
                "ELARE",
                style: TextStyle(
                  fontSize: 56,
                  fontFamily: 'brandon',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
