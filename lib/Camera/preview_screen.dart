import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking/success_page.dart';

final databaseReference =
    FirebaseDatabase.instance.reference().child("location");

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  double latitude, longitude;
  var status;
  PreviewScreen({this.imgPath, this.latitude, this.longitude, this.status});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  File _image;

  File getImage(File file) {
    _image = file;
    return _image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(
                getImage(File(widget.imgPath)),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: Colors.black,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      camerapopout(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }

  camerapopout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'assets/wsffsd.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            Text('  แจ้งเตือน')
          ]),
          content: Text("คุณต้องการใช้รูปถ่ายนี้ ใช่หรือไม่?"),
          actions: <Widget>[
            FlatButton(
              child: Text("ใช่"),
              onPressed: () async {
                final ProgressDialog pDialog = ProgressDialog(context);
                pDialog.style(message: 'กรุณารอสักครู่...');
                pDialog.show();

                String fileName =
                    DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now()) +
                        ".jpg";
                StorageReference firebaseStorageRef = FirebaseStorage.instance
                    .ref()
                    .child("Location/" + fileName);
                StorageUploadTask uploadTask =
                    firebaseStorageRef.putFile(File(widget.imgPath));
                StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
                final String photo_url =
                    await taskSnapshot.ref.getDownloadURL();

                var location_id = FirebaseDatabase.instance
                    .reference()
                    .child("location")
                    .push()
                    .key;

                SharedPreferences prefs = await SharedPreferences.getInstance();
                String user_id = prefs.getString("user_id");

                var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                var time = DateFormat('kk:mm').format(DateTime.now()) + " น.";

                databaseReference.child(location_id).set({
                  'location_id': location_id,
                  'latitude': widget.latitude,
                  'longitude': widget.longitude,
                  'date': date,
                  'time': time,
                  'photo': photo_url,
                  'status': widget.status,
                  'user_id': user_id,
                });

                pDialog.hide();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SuccessPage()));
              },
            ),
            FlatButton(
              child: Text("ไม่ใช่"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
