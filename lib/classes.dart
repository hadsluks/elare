import 'package:flutter/cupertino.dart';

class User {
  String userID, country;
}

class ThemeData {
  int noOfImages, noOfTimes, key;
  String value;
  ThemeData fromMap(Map<String, dynamic> data) {
    ThemeData th = new ThemeData();
    th.noOfImages = data['No of Images'];
    th.noOfTimes = data['No of times'];
    th.key = data['key'];
    th.value = data['value'];
    return th;
  }
}

class ImageData {
  String cc, link;
  int prediction, imageId;
  NetworkImage im;
  ImageData fromMap(Map<String, dynamic> data) {
    ImageData th = new ImageData();
    th.cc = data['CC'];
    th.prediction = data['Prediction'];
    th.imageId = data['ImageId'];
    th.link = data['link'];
    th.im = NetworkImage(th.link);
    return th;
  }
}

class Interest {}

class DataTheme {
  List<dynamic> images = new List();
  String themeID, left, right;
  DataTheme fromMap(Map<String, dynamic> data) {
    DataTheme dt = new DataTheme();
    dt.images = data['images'];
    dt.left = data['left'];
    dt.right = data['right'];
    dt.themeID = data['themeID'];
    return dt;
  }
}

class DataImage {
  String cc, imageID, link;
  int left, right;
  String l, r;
  DataImage fromMap(Map<String, dynamic> data) {
    DataImage it = new DataImage();
    it.cc = data['cc'];
    it.left = data['left'];
    it.right = data['right'];
    it.imageID = data['imageID'];
    it.link = data['link'];
    return it;
  }
}
