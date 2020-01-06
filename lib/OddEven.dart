import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elare/frontCard.dart';
import 'package:elare/timer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'backCard.dart';

class SumModel {
  int type, number;
  List<int> operands;
  SumModel(this.type, this.number, this.operands);
  void disp() {
    print(this.type.toString() + "  " + this.operands.toString());
  }
}

class OddEven extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OddEvenState();
  }
}

class _OddEvenState extends State<OddEven> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0, firstImage = 0, cf;
  List<String> names = new List();
  List<SumModel> allsums = new List();
  List<String> allsumText = new List();
  List<String> sumText = new List();
  List selectedData = [];
  GameTimer t = new GameTimer();
  Stopwatch s = new Stopwatch();
  int score = 0;
  bool clicked = false, firstlick = false, isBoy = false;
  void addSums() {
    if (allsumText.length > firstImage + 3)
      sumText =
          allsumText.sublist(firstImage, firstImage + 4).reversed.toList();

    if (sumText.isNotEmpty) cf = allsumText.indexOf(sumText.last);
    setState(() {});
  }

  void getSums() async {
    for (int i = 0; i < 15; i++) {
      int t = new Random().nextInt(4);
      int n = t == 3 ? 2 : (new Random().nextInt(5) + 2);
      List<int> op = new List.generate(n, (i) {
        return new Random().nextInt(100) + 1;
      });
      allsums.add(SumModel(t, n, op));
      String s;
      if (t == 3) {
        if (op[0] > op[1])
          s = op[0].toString() + " / " + op[1].toString();
        else
          s = op[1].toString() + " / " + op[0].toString();
      } else {
        s = op[0].toString();
        for (int i = 1; i < n; i++) {
          if (t == 0)
            s += " + ";
          else if (t == 1)
            s += " - ";
          else
            s += " * ";
          s += op[i].toString();
        }
      }
      s += " = ?";
      allsumText.add(s);
    }
    addSums();
  }

  int checkSum(SumModel s) {
    if (s.type == 3) {
      if (s.operands[0] > s.operands[1])
        return (s.operands[0] / s.operands[1]).floor();
      else
        return (s.operands[1] / s.operands[0]).floor();
    } else {
      int x = s.operands[0];
      for (int i = 1; i < s.operands.length; i++) {
        if (s.type == 0)
          x += s.operands[i];
        else if (s.type == 1)
          x -= s.operands[i];
        else if (s.type == 2) x *= s.operands[i];
      }
      return x;
    }
  }

  void initState() {
    super.initState();
    getSums();
    _buttonController = new AnimationController(
      duration: new Duration(milliseconds: 1000),
      vsync: this,
    );

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = sumText.removeLast();
          sumText.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(String url) {
    setState(() {
      sumText.remove(url);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      //data.remove(img);
      //selectedData.add(img);
    });
  }

  swipeRight() {
    if (checkSum(allsums[cf]).isEven)
      score++;
    else
      score--;
    sumText.removeLast();
    firstImage++;
    addSums();
  }

  swipeLeft() {
    if (checkSum(allsums[cf]).isEven)
      score--;
    else
      score++;
    sumText.removeLast();
    firstImage++;
    addSums();
  }

  onClicked() {
    setState(() {
      clicked = true;
      print(111);
    });
  }

  @override
  Widget build(BuildContext context) {
    double initialBottom = 15.0;
    var dataLength = sumText.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -10.0;
    List<Widget> stackItems = [
      GestureDetector(
        onTap: () {
          print(1111);
          setState(() {
            clicked = true;
          });
        },
        child: new Container(
          color: new Color.fromRGBO(106, 94, 175, 1.0),
          alignment: Alignment.center,
          child: dataLength > 0
              ? Opacity(
                  opacity: clicked ? 1 : 1,
                  child: new Stack(
                    alignment: AlignmentDirectional.center,
                    children: sumText.map((i) {
                      if (sumText.indexOf(i) == dataLength - 1) {
                        return frontCard(
                          allsumText.indexOf(i).toString(),
                          null,
                          i,
                          bottom.value,
                          right.value,
                          0.0,
                          backCardWidth + 10,
                          rotate.value,
                          rotate.value < -10 ? 0.1 : 0.0,
                          context,
                          dismissImg,
                          flag,
                          addImg,
                          swipeRight,
                          swipeLeft,
                          onClicked,
                          null,
                        );
                      } else {
                        backCardPosition = backCardPosition - 10;
                        backCardWidth = backCardWidth + 10;
                        return backCard(
                          null,
                          i,
                          backCardPosition,
                          0.0,
                          0.0,
                          backCardWidth,
                          0.0,
                          0.0,
                          context,
                        );
                      }
                    }).toList(),
                  ),
                )
              : Center(
                  child: Text(
                    "Game Over",
                    style: new TextStyle(
                      fontSize: 28.0,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),

      /* 
          Container(
            child: Text(
              "Tap to Play..",
              style: TextStyle(fontSize: 24),
            ),
            decoration: new BoxDecoration(
              color: new Color.fromRGBO(120, 120, 162, 1.0),
              borderRadius: new BorderRadius.circular(8.0),
            ),
          ), */
    ];
    /*if (!clicked)
      screenItems.add(
        Container(
          color: new Color.fromRGBO(106, 94, 175, 1.0),
          child: Center(
            child: firstlick
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          isBoy
                              ? "Heyyy, You know Girls are always \"RIGHT\"\n so you must follow \"LEFT\"."
                              : "Heyyy, You know Girls are always \"RIGHT\"\n so Don\'t be  \"LEFT\" Out.",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          //addUrls();
                          setState(() {
                            clicked = true;
                          });
                        },
                        child: Text(
                          isBoy ? "Ohhh!! Sureee :))" : "Ohhh!! Thanks!!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.cyan,
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Your Gender?",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              addUrls();
                              setState(() {
                                firstlick = true;
                                isBoy = true;
                              });
                            },
                            child: Text(
                              "Boy",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Colors.cyan,
                          ),
                          RaisedButton(
                            onPressed: () {
                              addUrls();
                              setState(() {
                                firstlick = true;
                                isBoy = false;
                              });
                            },
                            child: Text(
                              "Girl",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Colors.cyan,
                          )
                        ],
                      )
                    ],
                  ),
          ),
        ),
      );*/
    return new Scaffold(
      /* appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: new Color.fromRGBO(106, 94, 175, 1.0),
        centerTitle: true,
        leading: new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Icon(
            Icons.equalizer,
            color: Colors.cyan,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (context) => new PageMain()));
            },
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              child: new Icon(
                Icons.search,
                color: Colors.cyan,
                size: 30.0,
              ),
            ),
          ),
        ],
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "EVENTS",
              style: new TextStyle(
                fontSize: 12.0,
                letterSpacing: 3.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Container(
              width: 15.0,
              height: 15.0,
              margin: new EdgeInsets.only(bottom: 20.0),
              alignment: Alignment.center,
              child: new Text(
                dataLength.toString(),
                style: new TextStyle(fontSize: 10.0),
              ),
              decoration:
                  new BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            )
          ],
        ),
      ), */
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: stackItems,
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: Color.fromRGBO(106, 94, 174, 1.0),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  t,
                  new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      t.start();
                    },
                    child: new Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.width / 4,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: new BorderRadius.circular(60.0),
                      ),
                      child: new Text(
                        "START",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 22.5,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: Color.fromRGBO(106, 94, 173, 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('boygirl');
                    },
                    child: new Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.width / 4,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: new BorderRadius.circular(60.0),
                      ),
                      child: new Text(
                        "THEME",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 22.5,
                        ),
                      ),
                    ),
                  ),
                  new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {},
                    child: new Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.width / 4,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: new BorderRadius.circular(60.0),
                      ),
                      child: new Text(
                        "MODE",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 22.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: new Color.fromRGBO(106, 94, 175, 1.0),
              alignment: Alignment.center,
              child: Text(
                "SCORE: $score",
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  letterSpacing: 3.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
