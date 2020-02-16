import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Interests> interests;
int nOfInterests = 0;
Firestore firestore;

void initialiseThings() async {
  firestore = Firestore.instance;
  interests = new List();
}

void getInterests() async {
  var userDoc = await firestore
      .collection('user')
      .where("userName", isEqualTo: "harsh")
      .getDocuments();
  if (userDoc.documents.length > 0) {
    var d = userDoc.documents.first.data;
    var intrIds = d['interest'];
    nOfInterests = intrIds.length;
    intrIds.forEach((id) async {
      var intrDoc = await firestore
          .collection('interest')
          .where("interestID")
          .getDocuments();
      if (intrDoc.documents.length > 0) {
        interests.add(new Interests.fromMap(intrDoc.documents.first.data));
      }
    });
  }
}

void getThemes() async {
  var userDoc = await firestore
      .collection('user')
      .where("userName", isEqualTo: "harsh")
      .getDocuments();
  if (userDoc.documents.length > 0) {
    var d = userDoc.documents.first.data;
    var intrIds = d['interest'];
    nOfInterests = intrIds.length;
    intrIds.forEach((id) async {
      var intrDoc = await firestore
          .collection('interest')
          .where("interestID")
          .getDocuments();
      if (intrDoc.documents.length > 0) {
        interests.add(new Interests.fromMap(intrDoc.documents.first.data));
      }
    });
  }
}
