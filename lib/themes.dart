import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elare/BoyGirl.dart';
import 'package:flutter/material.dart';
import 'classes.dart' as cl;

class ThemesPage extends StatefulWidget {
  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<ThemesPage> {
  var firestore = Firestore.instance;

  List<cl.ThemeData> themes = new List();
  List<DocumentReference> docs = new List();

  Future<List<cl.ThemeData>> getThemes() async {
    themes = new List();
    await firestore.collection('Themes').getDocuments().then((doc) {
      doc.documents.forEach((d) {
        var th = new cl.ThemeData().fromMap(d.data);
        themes.add(th);
        docs.add(d.reference);
      });
    });
    return themes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (c, sp) {
          if (sp.hasData) {
            return ListView.builder(
              itemCount: themes.length,
              itemBuilder: (c, i) => ListTile(
                onTap: () {
                  firestore.runTransaction((tx) async {
                    await tx.update(
                        docs[i], {'No of times': themes[i].noOfTimes + 1});
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => BoyGirl(
                        th: themes[i],
                      ),
                    ),
                  );
                },
                title: Text(
                  themes[i].value,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.all(5),
                trailing: Icon(Icons.arrow_forward),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
        future: getThemes(),
      ),
    );
  }
}
