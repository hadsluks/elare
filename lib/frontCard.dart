import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

Positioned frontCard(
    //String url,
    String url,
    double cardWidth,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft,
    Function onClicked,
    bool toBlur) {
  Size screenSize = MediaQuery.of(context).size;
  return new Positioned(
    bottom: 100.0,
    child: new Dismissible(
      key: new Key(url),
      crossAxisEndOffset: -0.3,
      onDismissed: (DismissDirection direction) {
//          _swipeAnimation();
        if (direction == DismissDirection.endToStart) {
          //dismissImg(url);
          swipeLeft();
        } else {
          //dismissImg(url);
          swipeRight();
        }
      },
      child: new Transform(
        transform: new Matrix4.skewX(0.0),
        child: new Hero(
          tag: "img",
          child: new GestureDetector(
            child: new Card(
              color: Colors.transparent,
              elevation: 10.0,
              child: new Container(
                alignment: Alignment.center,
                width: screenSize.width / 1.2 + cardWidth,
                height: screenSize.height / 2,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  border: Border.all(width: 0.2),
                  image: DecorationImage(
                    image: NetworkImage(url),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
