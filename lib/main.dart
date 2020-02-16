import 'package:elare/Home.dart';
import 'package:elare/gametypes.dart';
import 'package:elare/interests.dart';
import 'package:elare/screens/onboarding/onboarding.dart';
import 'package:elare/signup.dart';
import 'package:elare/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'gametype': (c) => GameTypes(),
          'splashscreen': (c) => SplashScreen(),
          'signup': (c) => SignUp(),
          'interests': (c) => Interests(),
          'onb': (c) => Onboarding(),
          'home': (c) => Home(),
        },
        initialRoute: 'splashscreen',
      ),
    );
