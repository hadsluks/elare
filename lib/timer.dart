import 'dart:async';

import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final _GameTimerState gtstate = new _GameTimerState();
  void start() {
    gtstate.start();
  }

  @override
  _GameTimerState createState() => gtstate;
}

class _GameTimerState extends State<GameTimer> {
  Timer tim;
  int min = 2, sec = 0;
  void start() {
    tim = new Timer.periodic(new Duration(seconds: 1), (t) {
      if (sec == 0) {
        sec = 60;
        min--;
      }
      sec--;
      if (sec == 0 && min == 0) tim.cancel();
      setState(() {});
    });
  }
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tim.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/18,
      width: MediaQuery.of(context).size.width/4,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.red,
        borderRadius: new BorderRadius.circular(60.0),
      ),
      child: new Text(
        "0$min:" + (sec < 10 ? "0" + sec.toString() : sec.toString()),
        style: new TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width/22.5,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
