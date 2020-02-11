import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String gender = "Male", name, country;
  int age;
  var firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Full Name",
                  ),
                  onChanged: (s) {
                    name = s;
                  },
                ),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.0,
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Age",
                        ),
                        onChanged: (s) {
                          age = int.parse(s);
                        },
                        keyboardType: TextInputType.number,
                      ),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.0,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Country",
                        ),
                        onChanged: (s) {
                          country = s;
                        },
                      ),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.0,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: DropdownButton<String>(
                    items: ["Male", "Female"]
                        .map<DropdownMenuItem<String>>(
                          (s) => DropdownMenuItem<String>(
                            child: Text(s),
                            value: s,
                          ),
                        )
                        .toList(),
                    onChanged: (s) {
                      setState(() {
                        gender = s;
                      });
                    },
                    value: gender,
                  ),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.0,
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('interests');
                },
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 24, shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      offset: Offset(0, 2),
                    ),
                  ]),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(5),
                elevation: 10.0,
                hoverColor: Colors.grey,
                hoverElevation: 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
