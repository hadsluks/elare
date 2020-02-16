/* import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elare/frontCard.dart';
import 'package:elare/tapToStartButton.dart';
import 'package:elare/timer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:elare/classes.dart' as cl;
import 'backCard.dart';

class BoyGirl extends StatefulWidget {
  final cl.ThemeData th;
  BoyGirl({this.th});
  @override
  State<StatefulWidget> createState() {
    return _BoyGirlState();
  }
}

class _BoyGirlState extends State<BoyGirl> with TickerProviderStateMixin {
  String userName = "harsh";
  var firestore = Firestore.instance;
  GameTimer t;
  int score = 0, score1 = 0;
  List<bool> swipes = new List(), ifAddPred = new List();
  List<DocumentReference> refs = new List();
  List<int> imageIds = new List();
  List<cl.ImageData> image = new List();
  bool gameOver = false, start = false;
  int mode = 1, ci, fetchedImages = 0;
  List<String> imageNames = new List(), left = new List(), right = new List();
  List<cl.DataImage> images = new List();
  List<NetworkImage> netImages = new List();
  List<cl.DataTheme> themes = new List();
  int dismissedImage = 0;

  void getImages() async {
    image = new List();
    swipes = new List();
    ifAddPred = new List();
    refs = new List();
    imageIds = new List();
    firestore.collection('Theme${widget.th.key}').getDocuments().then((doc) {
      doc.documents.forEach((d) {
        var img = new cl.ImageData().fromMap(d.data);
        image.add(img);
        swipes.add(false);
        ifAddPred.add(false);
        refs.add(d.reference);
        imageIds.add(img.imageId);
        ci = swipes.length;
        setState(() {});
      });
    });
  }

  void getImages1() async {
    imageNames = new List();
    firestore
        .collection('user')
        .where("userName", isEqualTo: 'harsh')
        .getDocuments()
        .then((d) async {
      var data = d.documents.first.data;
      List<dynamic> interests = data['interest'];
      List<dynamic> th = new List();
      for (int i = 0; i < interests.length; i++) {
        await firestore
            .collection('interest')
            .where("interestID", isEqualTo: interests[i])
            .getDocuments()
            .then((d) {
          var data = d.documents.first.data;
          th += data['theme'];
        });
      }
      List<dynamic> img = new List();
      List<String> l1 = new List(), r1 = new List();
      for (int i = 0; i < th.length; i++) {
        await firestore
            .collection('theme')
            .where("themeID", isEqualTo: th[i])
            .getDocuments()
            .then((d) {
          var data = d.documents.first.data;
          var theme = new cl.DataTheme().fromMap(data);
          themes.add(theme);
          img += theme.images;
          theme.images.forEach((i) {
            l1.add(data['left']);
            r1.add(data['right']);
          });
        });
      }
      var rnd = new Random();
      for (int i = 0; i < img.length; i++) {
        int k = rnd.nextInt(img.length);
        while (img[k] == null) {
          k = rnd.nextInt(img.length);
        }
        imageNames.add(img[k]);
        left.add(l1[k]);
        right.add(r1[k]);
        img[k] = null;
      }
      fetchImgeUrls(5);
    });
  }

  void fetchImgeUrls(int number) async {
    for (int i = fetchedImages;
        i < fetchedImages + number && i < imageNames.length;
        i++) {
      await firestore
          .collection('images')
          .where('imageID', isEqualTo: imageNames[i])
          .getDocuments()
          .then((d) {
        var data = d.documents.first.data;
        var im = new cl.DataImage().fromMap(data);
        im.l = left[i];
        im.r = right[i];
        images.insert(0, im);
        netImages.insert(0, NetworkImage(im.link));
      });
    }
    ci = netImages.length;
    fetchedImages += number;
    setState(() {});
  }

  void initState() {
    super.initState();
    t = GameTimer(
      gameOver: onGameOver,
      gameMode: mode,
    );
    getImages1();
  }

  @override
  void dispose() {
    super.dispose();
  }

  swipeRight(int i) {
    dismissedImage += 1;
    fetchImgeUrls(1);
    if (images[i].cc == "R")
      score += 1;
    else
      score -= 1;
    if (score < 0) onGameOver();
    setState(() {});
    /* firestore.collection('swipes').document().setData({
      'imageID': images[i].imageID,
      'userName': 'harsh',
      'swipe': "R",
    }).then((_) {}); */
  }

  swipeLeft(int i) {
    dismissedImage += 1;
    fetchImgeUrls(1);
    if (images[i].cc == "L")
      score += 1;
    else
      score -= 1;
    if (score < 0) onGameOver();
    setState(() {});
    /* firestore.collection('swipes').document().setData({
      'imageID': images[i].imageID,
      'userName': 'harsh',
      'swipe': "L",
    }).then((_) {
      images.removeAt(i);
    }); */
  }

  onClicked() {
    setState(() {
      start = true;
      t.start();
    });
  }

  onGameOver() {
    t.stop();
    gameOver = true;
  }

  void newGame() {
    score = 0;
    score1 = 0;
    gameOver = false;
    t.reset();
    start = false;
    getImages();
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

  void giveleft() {}

  @override
  Widget build(BuildContext context) {
    if (netImages.length >= 5) {
      print(netImages[4]);
      print(imageNames[4]);
    }
    double initialBottom = 15.0;
    var dataLength = netImages.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = 10.0;
    if (dataLength == 0 && start) {
      onGameOver();
    }
    List<Widget> screenItems = [
      GestureDetector(
        onTap: () {
          onClicked();
        },
        child: new Container(
          alignment: Alignment.center,
          child: !gameOver
              ? dataLength == 0
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Loading Game"),
                            CircularProgressIndicator(),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Opacity(
                      opacity: start ? 1 : 0.2,
                      child: new Stack(
                        alignment: AlignmentDirectional.center,
                        children: netImages.sublist(0, 5).toList().map((i) {
                          if (netImages.indexOf(i) == 4)
                            return new Positioned(
                              bottom: 100.0,
                              child: Dismissible(
                                onDismissed: (DismissDirection direction) {
                                  ci -= 1;
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    swipeLeft(netImages.indexOf(i));
                                  } else {
                                    swipeRight(netImages.indexOf(i));
                                  }
                                },
                                key: Key(i.url),
                                child: Card(
                                  color: Colors
                                      .transparent, //Color.fromRGBO(121, 114, 173, 1.0),
                                  elevation: 10.0,
                                  child: new Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width /
                                            1.2 +
                                        backCardWidth,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      border: Border.all(width: 0.2),
                                      image: DecorationImage(
                                        image: i,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          else
                            return Positioned(
                              bottom: 100,
                              child: Dismissible(
                                onDismissed: (DismissDirection direction) {
                                  ci -= 1;
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    swipeLeft(netImages.indexOf(i));
                                  } else {
                                    swipeRight(netImages.indexOf(i));
                                  }
                                },
                                key: Key(i.url),
                                child: Card(
                                  color: Colors
                                      .transparent, //Color.fromRGBO(121, 114, 173, 1.0),
                                  elevation: 10.0,
                                  child: new Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width /
                                            1.2 +
                                        backCardWidth,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      border: Border.all(width: 0.2),
                                      image: DecorationImage(
                                        image: i,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
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
                      new FlatButton(
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
                                  MediaQuery.of(context).size.width / 22.5,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    ];

    if (!start && dataLength > 0) {
      screenItems.add(
        TapToStartButton(
          onClicked: onClicked,
        ),
      );
    }
    return new Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: t,
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.loose,
                  children: screenItems,
                ),
              ),
              dataLength > 0 && start
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 80,
                            child: Center(
                              child: Text(
                                left[ci - dismissedImage],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red[300],
                                  Colors.red[100],
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.center,
                              ),
                              border: Border(
                                right: BorderSide(
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 80,
                            child: Center(
                              child: Text(
                                right[ci - dismissedImage],
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green[100],
                                  Colors.green[300],
                                ],
                                begin: Alignment.center,
                                end: Alignment.centerRight,
                              ),
                              border: Border(
                                right: BorderSide(
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
              dataLength > 0 && !gameOver
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        "SCORE: $score",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          letterSpacing: 3.5,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              /* !start
                  ? Container(
                      alignment: Alignment.center,
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
                  : SizedBox(), */
            ],
          ),
        ));
  }
}
 */