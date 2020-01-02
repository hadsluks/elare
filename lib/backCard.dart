import 'package:elare/OddEven.dart';
import 'package:flutter/material.dart';

Positioned backCard(
  //String url,
  DecorationImage img,
  String sum,
  double bottom,
  double right,
  double left,
  double cardWidth,
  double rotation,
  double skew,
  BuildContext context,
) {
  Size screenSize = MediaQuery.of(context).size;
  // Size screenSize=(500.0,200.0);
  // print("dummyCard");
  return new Positioned(
    bottom: 100.0 + bottom,
    // right: flag == 0 ? right != 0.0 ? right : null : null,
    //left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Card(
      color: Colors.transparent,
      elevation: 4.0,
      child: new Container(
        alignment: Alignment.center,
        width: screenSize.width / 1.2 + cardWidth,
        height: screenSize.height / 2,
        decoration: new BoxDecoration(
          color: new Color.fromRGBO(121, 114, 173, 1.0),
          borderRadius: new BorderRadius.circular(8.0),
          //border: Border.all(width: 0.2),
        ),
        child: new Column(
          children: <Widget>[
            new Container(
              width: screenSize.width / 1.2 + cardWidth,
              height: screenSize.height / 2,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(8.0),
                    topRight: new Radius.circular(8.0)),
                image: sum != null ? null : img,
                /*  new DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ), */
              ),
              child: sum != null
                  ? Center(
                      child: Text(
                        sum,
                        style: new TextStyle(
                          fontSize: 24.0,
                          letterSpacing: 3.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}
