import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'Model/location.dart';

class CheckIn extends StatefulWidget {
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<CheckIn> {
  final dbRef = FirebaseDatabase.instance.reference().child("location");
  final dbRefUser = FirebaseDatabase.instance.reference().child("user");
  List<Map<dynamic, dynamic>> lists = [];
  var user_id, email;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.getString('user_id');
    print(user_id);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ประวัติการเช็คอิน"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            /* Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Text('ข้อมูลการ Check in, Check out ทั้งหมด',
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ), */
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: dbRef.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();

                    int check = 0;
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    values.forEach((key, values) {
                      if (values['user_id'] == user_id) {
                        lists.add(values);
                        check++;
                      }
                    });

                    if (check == 0) {
                      return Center(
                        child: Text('ไม่มีข้อมูล',
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                                  child: _detectOS(lists[index]["status"]),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 10),
                                        child: Text(
                                            "วันที่ " + lists[index]["date"],
                                            style:
                                                new TextStyle(fontSize: 18.0)),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 10, 10),
                                        child:
                                            Text("เวลา " + lists[index]["time"],
                                                textAlign: TextAlign.right,
                                                style: new TextStyle(
                                                  fontSize: 18.0,
                                                )),
                                      ),
                                    ]),
                              ],
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }

  Widget _detectOS(data) {
    if (data == 'check-in') {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          color: Colors.transparent,
          child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                  padding: EdgeInsets.all(7),
                  child: new Text("Check in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)))));
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          color: Colors.transparent,
          child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: new BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                  padding: EdgeInsets.all(7),
                  child: new Text("Check Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)))));
    }
  }
}
