import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elare/frontCard.dart';
import 'package:elare/tapToStartButton.dart';
import 'package:elare/timer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'backCard.dart';

class BoyGirl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BoyGirlState();
  }
}

class _BoyGirlState extends State<BoyGirl> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0, firstImage = 0, cf;
  List<String> names = new List();
  List<DecorationImage> allImages = new List();
  List<DecorationImage> images = new List();
  List selectedData = [];
  GameTimer t;
  int score = 0;
  bool start = false, genderAsked = false, isBoy = false, finalStart = false;
  bool gameOver = false;
  int mode = 1;
  void addUrls() {
    if (allImages.length > firstImage + 3)
      images = allImages.sublist(firstImage, firstImage + 4).reversed.toList();
    //urls = allUrls.sublist(firstImage, firstImage + 4).reversed.toList();
    if (images.isNotEmpty) cf = allImages.indexOf(images.last);
    setState(() {});
  }

  void getUrls() async {
    List n = [
      "g1.jpg",
      "g2.jpg",
      "g3.jpg",
      "g4.jpg",
      "g5.jpg",
      "g6.jpg",
      "g7.jpg",
      "g8.jpg",
      "g9.jpg",
      "g10.jpg",
    ];
    allImages = new List<DecorationImage>.generate(10, (i) {
      names.add(n[i]);
      return DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage("assets/" + n[i]),
      );
    });
    addUrls();
    Firestore.instance.collection('images').snapshots().listen((d) {
      d.documents.forEach((doc) async {
        final url = await FirebaseStorage.instance
            .ref()
            .child(doc['name'] + '.jpg')
            .getDownloadURL();
        allImages.add(
          new DecorationImage(
            image: new NetworkImage(url),
            fit: BoxFit.cover,
          ),
        );
        names.add(doc['name']);
      });
    });
  }

  void initState() {
    super.initState();
    t = GameTimer(
      gameOver: onGameOver,
      gameMode: mode,
    );
    getUrls();
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
          var i = images.removeLast();
          images.insert(0, i);

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
      images.remove(url);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      //data.remove(img);
      //selectedData.add(img);
    });
  }

  swipeRight() {
    if (names[cf].contains("b"))
      score--;
    else
      score++;
    images.removeLast();
    firstImage++;
    if (score < 0) {
      t.stop();
      gameOver = true;
      setState(() {});
    } else
      addUrls();
  }

  swipeLeft() {
    if (names[cf].contains("b"))
      score++;
    else
      score--;
    images.removeLast();
    firstImage++;
    if (score < 0) {
      t.stop();
      gameOver = true;
      setState(() {});
    } else
      addUrls();
  }

  onClicked() {
    setState(() {
      start = true;
    });
  }

  onGameOver() {
    setState(() {
      gameOver = true;
    });
  }

  void newGame() {
    firstImage = 0;
    addUrls();
    score = 0;
    gameOver = false;
    start = false;
    genderAsked = false;
    isBoy = false;
    finalStart = false;
    t.reset();
    setState(() {});
  }

  void themeDialog(BuildContext c) {
    AlertDialog ad = new AlertDialog(
      title: Text("Select Theme"),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed("boygirl");
          },
          child: Text(
            "Boy-Girl",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('oddeven');
          },
          child: Text(
            "Odd-Even",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        )
      ],
    );
    showDialog(
      context: c,
      builder: (c) => ad,
    );
  }

  void modeDialog(BuildContext c) {
    AlertDialog ad = new AlertDialog(
      title: Text("Select Theme"),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            mode = 1;
            t.stop();
            t.modeChange(mode);
            Navigator.of(context).pop();
            newGame();
            //setState(() {});
          },
          child: Text(
            "EndLess",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            mode = 2;
            t.stop();
            t.modeChange(mode);
            Navigator.of(context).pop();
            newGame();
            //setState(() {});
          },
          child: Text(
            "Timed",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        )
      ],
    );
    showDialog(
      context: c,
      builder: (c) => ad,
    );
  }

  @override
  Widget build(BuildContext context) {
    double initialBottom = 15.0;
    var dataLength = images.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -10.0;
    if (dataLength == 0) {
      t.stop();
      gameOver = true;
    }
    List<Widget> screenItems = [
      GestureDetector(
        onTap: () {
          print(1111);
          setState(() {
            //start = true;
          });
        },
        child: new Container(
          color: new Color.fromRGBO(106, 94, 175, 1.0),
          alignment: Alignment.center,
          child: dataLength > 0 && !gameOver
              ? Opacity(
                  opacity: start ? 1 : 0.2,
                  child: new Stack(
                    alignment: AlignmentDirectional.center,
                    children: images.map((i) {
                      if (images.indexOf(i) == dataLength - 1) {
                        return frontCard(
                          names[allImages.indexOf(i)],
                          i,
                          null,
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
                          !start,
                        );
                      } else {
                        backCardPosition = backCardPosition - 10;
                        backCardWidth = backCardWidth + 10;
                        return backCard(
                          i,
                          null,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Game Over\nYour Score: $score",
                        style: new TextStyle(
                          fontSize: 28.0,
                          letterSpacing: 3.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      gameOver
                          ? new FlatButton(
                              padding: new EdgeInsets.all(0.0),
                              onPressed: newGame,
                              child: new Container(
                                height: MediaQuery.of(context).size.height / 18,
                                width: MediaQuery.of(context).size.width / 4,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: new BorderRadius.circular(60.0),
                                ),
                                child: new Text(
                                  "New Game",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            22.5,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
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
    if (start && !finalStart)
      screenItems.add(
        Container(
          color: new Color.fromRGBO(106, 94, 175, 1.0),
          child: Center(
            child: genderAsked
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
                            finalStart = true;
                            t.start();
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
                                genderAsked = true;
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
                                genderAsked = true;
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
      );

    if (!start) {
      screenItems.add(
        TapToStartButton(
          onClicked: onClicked,
        ),
      );
    }
    return new Scaffold(
        /*appBar: new AppBar(
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
                decoration: new BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
              )
            ],
          ),
        ),*/
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.loose,
              children: screenItems,
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Color.fromRGBO(106, 94, 174, 1.0),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: t,
          ),
          !start
              ? Container(
                  alignment: Alignment.center,
                  color: Color.fromRGBO(106, 94, 173, 1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
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
                            "Theme : BoyGirl",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.5,
                            ),
                          ),
                        ),
                      ),
                      new FlatButton(
                        padding: new EdgeInsets.all(0.0),
                        onPressed: () {
                          modeDialog(context);
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
                            "Mode : " + (mode == 1 ? "EndLess" : "Timed"),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          dataLength > 0 && !gameOver
              ? Container(
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
                )
              : SizedBox()
        ],
      ),
    ));
  }
}
