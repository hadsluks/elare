import 'dart:ui';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 12,
          ),
          Text(
            "Select Interest:",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: interests
                  .map<Widget>(
                    (intr) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selected[interests.indexOf(intr)] =
                              !selected[interests.indexOf(intr)];
                        });
                      },
                      child: BackdropFilter(
                        filter: selected[interests.indexOf(intr)]
                            ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: selected[interests.indexOf(intr)]
                                  ? Colors.green
                                  : Colors.black,
                              width:
                                  selected[interests.indexOf(intr)] ? 1.5 : 0.2,
                            ),
                          ),
                          foregroundDecoration:
                              selected[interests.indexOf(intr)]
                                  ? BoxDecoration(
                                      color: Colors.grey.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: selected[interests.indexOf(intr)]
                                            ? Colors.green
                                            : Colors.black,
                                        width: selected[interests.indexOf(intr)]
                                            ? 1.5
                                            : 0.2,
                                      ),
                                    )
                                  : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Image.asset(
                                "assets/g1.jpg",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                intr,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
