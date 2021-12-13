import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:tracking/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'Map/maps.dart';
import 'check-in.dart';
import 'leave.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mDatabase = FirebaseDatabase.instance.reference().child("user");
  final mDatabaseLocation =
      FirebaseDatabase.instance.reference().child("location");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String Date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String Time = DateFormat('kk:mm').format(DateTime.now()) + " น.";

  File _image;
  var user_id, email, password, photo, name, surname, position, gender, tel;

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
    email = await prefs.getString('email');
    password = await prefs.getString('password');
    photo = await prefs.getString('photo');
    name = await prefs.getString('name');
    surname = await prefs.getString('surname');
    position = await prefs.getString('position');
    gender = await prefs.getString('gender');
    tel = await prefs.getString('tel');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(title: new Text('หน้าหลัก')),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(name + " " + surname),
              accountEmail: new Text(email),
              currentAccountPicture: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xff476cfb),
                child: ClipOval(
                  child: new SizedBox(
                      width: 110.0,
                      height: 110.0,
                      child: Image.network(
                        SetImage(),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.green, Colors.deepOrangeAccent]),
              ),
            ),
            new ListTile(
                leading: Icon(Icons.home),
                title: new Text("หน้าหลัก"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.subdirectory_arrow_left),
                title: new Text("ลางาน"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DropDown()));
                }),
            new ListTile(
                leading: Icon(Icons.date_range),
                title: new Text("ประวัติการเช็คอิน"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckIn()));
                }),
            new Divider(),
            new ListTile(
                leading: Icon(Icons.power_settings_new),
                title: new Text("ออกจากระบบ"),
                onTap: () {
                  LogoutMethod(context);
                }),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'วันที่ : ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      Date,
                      style: TextStyle(fontSize: 15),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'เวลา : ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      Time,
                      style: TextStyle(fontSize: 15),
                    ),
                  ]),
            ),
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.deepOrangeAccent,
                        padding: EdgeInsets.all(5),
                        child: Image.network(
                          SetImage(),
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                      )),

                  /*Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImageDevice();
                      },
                    ),
                  ), */
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('อีเมลล์ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                    child: Text(email,
                        style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  ),
                ],
              ),
            ),
            /* SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('รหัสผ่าน :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(password,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ), */
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('ชื่อ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 48.0),
                  child: Text(name,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('นามสกุล :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(surname,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('ตำแหน่ง :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(position,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('เพศ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 42.0),
                  child: Text(gender,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text('เบอร์โทร :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(tel,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: RaisedButton.icon(
                      onPressed: () {
                        _goToMap_CheckIn(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      label: Text(
                        'Check In',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      textColor: Colors.white,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: RaisedButton.icon(
                      onPressed: () {
                        _goToMap_CheckOut(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      label: Text(
                        'Check Out',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      textColor: Colors.white,
                      color: Colors.red,
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  SetImage() {
    if (photo == "") {
      return "https://i.pinimg.com/originals/ff/a0/9a/ffa09aec412db3f54deadf1b3781de2a.png";
    } else {
      return photo;
    }
  }

  Future getImageDevice() async {
    var image;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Row(children: [
              Image.asset(
                'assets/wsffsd.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text('  กรุณาเลือกคำสั่ง')
            ]),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  _image = image;
                  uploadPic();
                },
                child: const Text('ถ่ายรูป'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  _image = image;
                  uploadPic();
                },
                child: const Text('เลือกรูป'),
              )
            ],
          );
        });

    //print('Image Path $_image');
  }

  Future uploadPic() async {
    if (_image == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเลือกรูปก่อน')));
      return;
    } else {
      final ProgressDialog pDialog = ProgressDialog(context);
      pDialog.style(message: 'กรุณารอสักครู่...');
      pDialog.show();
      String fileName =
          DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now()) + ".jpg";
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("User/" + fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      final String photo_url = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        photo = photo_url;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var User_id = prefs.getString("user_id");
      var photo_before = prefs.getString("photo");

      if (photo_before != null) {
        FirebaseStorage.instance
            .getReferenceFromUrl(photo_before)
            .then((reference) => reference.delete());
      }

      prefs.setString('photo', photo_url);
      mDatabase.child(User_id).update({'photo': photo_url});

      pDialog.hide();
      Toast.show("อัพโหลดรูปสำเร็จ", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  LogoutMethod(BuildContext context) {
    showDialog(
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
          content: Text("คุณต้องการออกจากระบบ ใช่หรือไม่?"),
          actions: <Widget>[
            FlatButton(
              child: Text("ใช่"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            FlatButton(
              child: Text("ไม่ใช่"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }

  void _goToMap_CheckIn(BuildContext context) async {
    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await mDatabaseLocation.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      print('Data == ${dataSnapshot.value}');
      var data = '${dataSnapshot.value}';

      if (data == "null") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapView(status: "check-in")),
        );
      } else {
        int check = 0;
        values.forEach((key, values) {
          if (values['user_id'] == user_id &&
              values['date'] == date &&
              values['status'] == 'check-in') {
            Toast.show("เพิ่มข้อมูล check in ได้วันละ 1 ครั้ง", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            check++;
            return;
          }
        });

        if (check == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapView(status: "check-in")),
          );
        }
      }
    });
  }

  void _goToMap_CheckOut(BuildContext context) async {
    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await mDatabaseLocation.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      //print('Data == ${dataSnapshot.value}');
      var data = '${dataSnapshot.value}';

      if (data == "null") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapView(status: "check-in")),
        );
      } else {
        int check = 0;
        values.forEach((key, values) {
          if (values['user_id'] == user_id &&
              values['date'] == date &&
              values['status'] == 'check-out') {
            Toast.show("เพิ่มข้อมูล check out ได้วันละ 1 ครั้ง", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            check++;
            return;
          }
        });

        if (check == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapView(status: "check-out")),
          );
        }
      }
    });
  }
}
