import 'package:elare/BoyGirl.dart';
import 'package:elare/gametypes.dart';
import 'package:flutter/material.dart';
import 'package:elare/OddEven.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'boygirl': (c) => BoyGirl(),
          'oddeven': (c) => OddEven(),
          'gametype': (c) => GameTypes(),
        },
        initialRoute: 'oddeven',
      ),
    );
