import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Interests extends StatefulWidget {
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List<String> interests = new List(), id = new List();
  List<bool> selected = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interests = [
      "Fashion",
      "Entertainment",
      "DayNight",
      "Live Things",
      "Nature",
    ];
    id = ["0", "1", "2", "3", "4"];
    selected = [false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Expanded(
              child: Text(
                "Select Interests",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemBuilder: (c, i) {
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        interests[i],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selected[i] ? Colors.grey : Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selected[i] = !selected[i];
                      });
                    },
                  );
                },
                itemCount: interests.length,
              ),
            ),
            RaisedButton(
              onPressed: () async {
                List<String> intr = [];
                for (int i = 0; i < 5; i++) {
                  if (selected[i]) intr.add(id[i]);
                }
                print(intr);
                Firestore.instance
                    .collection('user')
                    .where("userName", isEqualTo: "harsh")
                    .getDocuments()
                    .then((d) {
                  var r = d.documents.first.reference;
                  Firestore.instance.runTransaction((tx) async {
                    tx.update(r, {'interest': intr});
                  }).then((_) {
                    Navigator.of(context).pushNamed('boygirl');
                  });
                });
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
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
