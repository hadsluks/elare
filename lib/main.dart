import 'package:elare/BoyGirl.dart';
import 'package:elare/gametypes.dart';
import 'package:elare/interests.dart';
import 'package:elare/screens/onboarding/onboarding.dart';
import 'package:elare/signup.dart';
import 'package:elare/splashscreen.dart';
import 'package:elare/themes.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'boygirl': (c) => BoyGirl(),
          'gametype': (c) => GameTypes(),
          'splashscreen': (c) => SplashScreen(),
          'signup': (c) => SignUp(),
          'themes': (c) => ThemesPage(),
          'interests': (c) => Interests(),
          'onb': (c) => Onboarding(),
        },
        initialRoute: 'signup',
      ),
    );
