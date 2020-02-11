import 'dart:async';

import 'package:flutter/material.dart';

class TapToStartButton extends StatefulWidget {
  final Function onClicked;
  TapToStartButton({this.onClicked});
  @override
  _TapToStartButtonState createState() => _TapToStartButtonState();
}

class _TapToStartButtonState extends State<TapToStartButton> {
  Timer tim;
  bool op = false;
  @override
  void initState() {
    super.initState();
    tim = Timer.periodic(Duration(milliseconds: 500), (t) {
      if (tim.isActive) {
        op = !op;
        if (this.mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tim.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: op ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: 1.0),
            color: Colors.white,
          ),
          child: FlatButton(
            child: Text(
              "Tap to Start....",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: widget.onClicked,
          ),
        ),
      ),
    );
  }
}
