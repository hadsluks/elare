import 'dart:math';
import 'package:elare/OddEven.dart';
import 'package:flutter/material.dart';

Positioned frontCard(
    //String url,
    String index,
    DecorationImage img,
    String sum,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft,
    Function onClicked) {
  Size screenSize = MediaQuery.of(context).size;
  return new Positioned(
    bottom: 100.0 + bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: new Key(index.toString()),
      crossAxisEndOffset: -0.3,
      onResize: () {
        //print("here");
        // setState(() {
        //   var i = data.removeLast();

        //   data.insert(0, i);
        // });
      },
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
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        //transform: null,
        transform: new Matrix4.skewX(skew),
        //..rotateX(-math.pi / rotation),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: new Hero(
            tag: "img",
            child: new GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => new DetailPage(type: img)));
                /* Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new DetailPage(type: img),
                    )); */
              },
              child: new Card(
                color: Colors.transparent,
                elevation: 10.0,
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.2 + cardWidth,
                  height: screenSize.height / 2,
                  decoration: new BoxDecoration(
                    color: Color.fromRGBO(121, 114, 173, 1.0),
                    borderRadius: new BorderRadius.circular(8.0),
                    border: Border.all(width: 0.2),
                    image: sum == null ? img : null,
                  ),
                  child: GestureDetector(
                    onTap: onClicked,
                    child: sum == null
                        ? null
                        : Text(
                            sum,
                            style: new TextStyle(
                              fontSize: 24.0,
                              letterSpacing: 3.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
