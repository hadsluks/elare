import 'package:elare/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (c) => Home(),
        },
        initialRoute: 'home',
      ),
    );
