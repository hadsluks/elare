import 'dart:async';

import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final _GameTimerState gtstate = new _GameTimerState();
  final Function gameOver;
  final int gameMode;
  GameTimer({this.gameOver, this.gameMode});
  void start() {
    gtstate.start();
  }

  void reset() {
    gtstate.reset();
  }

  void stop() {
    gtstate.stop();
  }

  void modeChange(int mode) => gtstate.modeChange(mode);

  @override
  _GameTimerState createState() => gtstate;
}

class _GameTimerState extends State<GameTimer> {
  Timer tim, fadeTim;
  int origMin, origSec;
  int min, sec;
  int gameMode;
  bool op = true;
  @override
  void initState() {
    super.initState();
    gameMode = widget.gameMode;
    if (gameMode == 1) {
      origMin = 0;
      origSec = 0;
    } else {
      origMin = 0;
      origSec = 15;
    }
    min = origMin;
    sec = origSec;
  }

  void stop() {
    if (tim != null) tim.cancel();
    if (fadeTim != null) fadeTim.cancel();
    op = true;
    if (this.mounted) setState(() {});
  }

  void start() {
    fadeTim = new Timer.periodic(new Duration(milliseconds: 500), (t) {
      op = !op;
      if (fadeTim.isActive && this.mounted) setState(() {});
    });
    tim = new Timer.periodic(new Duration(seconds: 1), (t) {
      if (gameMode == 1) {
        sec++;
        if (sec == 60) {
          sec = 0;
          min++;
        }
        if (tim.isActive && this.mounted) setState(() {});
      } else if (gameMode == 2) {
        if (sec == 0) {
          sec = 60;
          min--;
        }
        sec--;
        if (tim.isActive && this.mounted) setState(() {});
        if (sec == 0 && min == 0) {
          widget.gameOver();
          this.stop();
        }
      }
    });
  }

  void modeChange(int mode) {
    if (mode == 1) {
      origMin = 0;
      origSec = 0;
    } else if (mode == 2) {
      origMin = 0;
      origSec = 15;
    }
    min = origMin;
    sec = origSec;
    gameMode = mode;
    setState(() {});
  }

  void reset() {
    min = origMin;
    sec = origSec;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (tim != null) tim.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(
        milliseconds: 500,
      ),
      opacity: op ? 1.0 : 0.0,
      child: Container(
        height: MediaQuery.of(context).size.height / 18,
        width: MediaQuery.of(context).size.width / 4,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: new BorderRadius.circular(60.0),
        ),
        child: new Text(
          "0$min:" + (sec < 10 ? "0" + sec.toString() : sec.toString()),
          style: new TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width / 22.5,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
