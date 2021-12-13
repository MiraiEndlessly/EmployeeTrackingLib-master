import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

final databaseReference = FirebaseDatabase.instance.reference().child("user");
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class Signup_Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Signup_Page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController telController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  int _radioValue = 0;
  var radioValue = "";

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 1:
          //print("Male");
          radioValue = "ชาย";
          break;
        case 2:
          //print("Female");
          radioValue = "หญิง";
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าสมัครสมาชิก"),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                /* Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                  ),
                ), */
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    "กรุณากรอกข้อมูลให้ครบถ้วน",
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "อีเมลล์",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: emailController,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่อีเมลล์',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "รหัสผ่าน",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    controller: passwordController,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่รหัสผ่าน',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "ชื่อ",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: nameController,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่ชื่อ',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "นามสกุล",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: surnameController,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่นามสกุล',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "ตำแหน่งงาน",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: positionController,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ตำแหน่งงาน'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "เบอร์โทร",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: telController,
                    keyboardType: TextInputType.number,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่เบอร์โทร'),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'เพศชาย',
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'เพศหญิง',
                      style: new TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        'สมัครสมาชิก',
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        RegisterMethod(context);
                      },
                    )),
              ],
            )));
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<void> RegisterMethod(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String surname = surnameController.text.trim();
    String position = positionController.text.trim();
    String tel = telController.text.trim();
    String gender = radioValue;

    if (gender == "") {
      Toast.show("กรุณาเลือกเพศก่อน  ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (email.isEmpty) {
      Toast.show("กรุณาใส่อีเมลล์ก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (validateEmail(email) == false) {
      Toast.show('กรุณาตรวจสอบอีเมลล์ให้ถูกต้อง', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (password.isEmpty) {
      Toast.show("กรุณาใส่รหัสผ่านก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (password.length < 5) {
      Toast.show("รหัสผ่านต้องมากกว่า 6 ตัว", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (name.isEmpty) {
      Toast.show("กรุณาใส่ชื่อก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (surname.isEmpty) {
      Toast.show("กรุณาใส่นามสกุลก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (position.isEmpty) {
      Toast.show("กรุณาใส่ตำแหน่งก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (tel.isEmpty) {
      Toast.show("กรุณาใส่เบอร์โทรก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(message: 'กรุณารอสักครู่...');
    pDialog.show();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((data) {
      var uid = data.user.uid;

      databaseReference.child(uid).set({
        'user_id': uid,
        'email': email,
        'password': password,
        'photo': "",
        'name': name,
        'surname': surname,
        'position': position,
        'gender': gender,
        'tel': tel
      });

      Navigator.pop(context);
      pDialog.hide();
    }).catchError((e) {
      pDialog.hide();
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        Toast.show("อีเมลล์นี้มีผู้ใช้แล้ว กรุณาเปลี่ยนอีเมลล์", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        print(e);
        Toast.show("เกิดข้อผิดพลาดกรุณาลองใหม่", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    });
  }
}
