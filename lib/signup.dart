import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> swipe, swipeUp;
  Animation<double> opac;
  int cI = 0;
  String name, country, gender, age;
  List<String> type = ["Name", "Age", "Country", "Gender"];
  String desc(i) {
    switch (i) {
      case 0:
        return "Enter Your Name";
        break;
      case 1:
        return "Enter Age";
        break;
      case 2:
        return "Enter your Country";
        break;
      case 3:
        return "Select your Gender";
        break;
      default:
        return "";
    }
  }

  void save(dynamic s) {
    switch (cI) {
      case 0:
        name = s;
        break;
      case 1:
        age = s;
        break;
      case 2:
        country = s;
        break;
      case 3:
        gender = s;
        break;
      default:
        break;
    }
  }

  Widget typeOfInput(int i) {
    if (i == 3)
      return DropdownButton<String>(
        items: ["Male", "Female"].map<DropdownMenuItem<String>>((i) {
          return DropdownMenuItem<String>(
            child: Text(i),
            value: i,
          );
        }).toList(),
        onChanged: (i) => save,
        value: gender,
      );
    else
      return TextFormField(
        decoration: InputDecoration(
          hintText: "Your " + type[cI] + " Here...",
        ),
        onChanged: (s) => save,
      );
  }

  var firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();
    gender = "Male";
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 1000),
    );
    swipe = new Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
    );
    swipe.addListener(() {
      setState(() {
        if (swipe.isCompleted) {
          controller.reset();
          cI += 1;
          cI = cI % 4;
        }
      });
    });
    swipeUp = new Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, 1.5),
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
    );
    opac = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new SlideTransition(
            position: swipeUp,
            child: new FadeTransition(
              opacity: opac,
              child: Card(
                color: Color(0xffffdab9),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    width: 0.5,
                  ),
                ),
                elevation: 5.0,
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width - 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        desc((cI + 1) % 4),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        child: typeOfInput((cI + 1) % 4),
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          new SlideTransition(
            position: swipe,
            child: Card(
              color: Color(0xffffdab9),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  width: 0.5,
                ),
              ),
              elevation: 5.0,
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      desc(cI),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      child: typeOfInput(cI),
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              cI > 0
                  ? Expanded(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          controller.reverse();
                        },
                      ),
                    )
                  : Spacer(),
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    setState(() {});
                    if (cI == 3) {
                    } else
                      controller.forward();
                  },
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 15,
          ),
        ],
      ),
    );
  }
}
/* */
/* class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  Animation<double> swipe;
  AnimationController cont;
  var firestore = Firestore.instance;
  var storage = FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () async {
                /*firestore.collection('interest').document().setData({
                  'interestID': "4",
                  'name': "Nature",
                  'theme': ["40"],
                });
                 var im1 = [];
                for (int i = 0; i < im1.length; i++) {
                  storage
                      .ref()
                      .child("40/koala/" + im1[i])
                      .getDownloadURL()
                      .then((url) {
                    print(url);
                    firestore.collection('images').document().setData({
                      'cc': "L",
                      'imageID': im1[i],
                      'left': 0,
                      'right': 0,
                      'link': url,
                    });
                  }).catchError((e) {
                    print(im1[i]);
                  });
                }
                var im2 = [];
                for (int i = 0; i < im2.length; i++) {
                  storage
                      .ref()
                      .child("40/quokka/" + im2[i])
                      .getDownloadURL()
                      .then((url) {
                    print(url);
                    firestore.collection('images').document().setData({
                      'cc': "R",
                      'imageID': im2[i],
                      'left': 0,
                      'right': 0,
                      'link': url,
                    });
                  }).catchError((e) {
                    print(im2[i]);
                  });
                }
                var i = im1 + im2;
                firestore.collection('theme').document().setData({
                  'themeID': "40",
                  'left': 'Koala',
                  'right': 'Quakka',
                  'images': i
                }); */
              },
            ),
            RaisedButton(onPressed: () async {
              var d1 = DateTime.now();
              firestore
                  .collection('user')
                  .where("userName", isEqualTo: 'harsh')
                  .getDocuments()
                  .then((d) async {
                var data = d.documents.first.data;
                List<dynamic> interests = data['interest'];
                List<dynamic> themes = new List();
                for (int i = 0; i < interests.length; i++) {
                  await firestore
                      .collection('interest')
                      .where("interestID", isEqualTo: interests[i])
                      .getDocuments()
                      .then((d) {
                    var data = d.documents.first.data;
                    themes += data['theme'];
                  });
                }
                List<dynamic> images = new List();
                for (int i = 0; i < themes.length; i++) {
                  await firestore
                      .collection('theme')
                      .where("themeID", isEqualTo: themes[i])
                      .getDocuments()
                      .then((d) {
                    var data = d.documents.first.data;
                    images += data['images'] != null ? data['images'] : [];
                  });
                }
                List<dynamic> imageUrls = new List();
                for (int i = 0; i < images.length; i++) {
                  await firestore
                      .collection('images')
                      .where('imageID', isEqualTo: images[i])
                      .getDocuments()
                      .then((d) {
                    var data = d.documents.first.data;
                    imageUrls.add(data['link']);
                  });
                }
                var d2 = DateTime.now();
                print(d2.difference(d1).toString());
                print(imageUrls.length);
              });
            })
          ],
        ),
      ),
    );
  }
}
 */
