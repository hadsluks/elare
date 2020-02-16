class User {
  String userID, country;
}

class Interests {
  String id, name;
  List<ThemeData> themes;
  Interests.fromMap(Map<String, dynamic> d) {
    this.id = d['interestID'];
    this.name = d['name'];
  }
}

class ThemeData {
  String id, interestID;
  List<ImageData> images;
  ThemeData.fromMap(Map<String, dynamic> d) {
    this.id = d['themeID'];
    this.interestID = d['interestID'];
  }
}

class ImageData {
  String id, themeID, left, right, link;
}
