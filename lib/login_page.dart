import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'Model/user.dart';
import 'home_page.dart';
import 'signup_page.dart';

final databaseReference = FirebaseDatabase.instance.reference().child("user");

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    /* emailController.text = "tanat29.mongkon@gmail.com";
    passwordController.text = "000000"; */
    super.initState();
  }

  // Perform login or signup
  void validateAndSubmit() async {
    var email = emailController.text.toString().trim();
    var password = passwordController.text.toString().trim();

    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(message: 'กรุณารอสักครู่...');
    pDialog.show();

    if (email.isEmpty) {
      Toast.show("กรุณาใส่อีเมลล์ก่อน", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }

    if (password.isEmpty) {
      Toast.show("กรุณาใส่รหัสผ่านก่อน", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      //pDialog.hide();

      var Uid = result.user.uid;

      databaseReference.child(Uid).once().then((DataSnapshot snapshot) async {
        var photo = '${snapshot.value["photo"]}';
        var name = '${snapshot.value["name"]}';
        var surname = '${snapshot.value["surname"]}';
        var position = '${snapshot.value["position"]}';
        var gender = '${snapshot.value["gender"]}';
        var tel = '${snapshot.value["tel"]}';

        pDialog.hide();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("check", true);
        await prefs.setString('user_id', Uid);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('photo', photo);
        await prefs.setString('name', name);
        await prefs.setString('surname', surname);
        await prefs.setString('position', position);
        await prefs.setString('gender', gender);
        await prefs.setString('tel', tel);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
            /* settings: RouteSettings(
              arguments: User(
                Uid,
                email,
                password,
                photo,
                name,
                surname,
                position,
                tel
              ),
            ), */
          ),
        );
      });
      return true;
    }).catchError((e) {
      print(e);
      pDialog.hide();
      switch (e.code) {
        case "ERROR_WRONG_PASSWORD":
          Toast.show("รหัสผ่านผิดพลาด กรุณาลองใหม่อีกครั้ง", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          break;
        case "ERROR_INVALID_EMAIL":
          Toast.show("อีเมลล์ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          break;
        case "ERROR_USER_NOT_FOUND":
          Toast.show("ไม่พบผู้ใช้นี้ กรุณาสมัครสมาชิกก่อน", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Signup_Page()),
          );
          break;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        /* appBar: new AppBar(
          title: new Text('Flutter login demo'),
        ), */
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Center(
          child: new ListView(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
            children: <Widget>[
              Row(
                //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/wsffsd.png',
                    height: 30,
                    width: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Tracking"),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 10),
                child: Image.asset(
                  'assets/wsffsd.png',
                  height: 170,
                  width: 170,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  controller: emailController,
                  decoration: new InputDecoration(
                      hintText: 'อีเมลล์ผู้ใช้',
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) => emailController.text = value.trim(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: new TextFormField(
                  maxLines: 1,
                  obscureText: true,
                  autofocus: false,
                  controller: passwordController,
                  decoration: new InputDecoration(
                      hintText: 'รหัสผ่าน',
                      icon: new Icon(
                        Icons.lock,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => passwordController.text = value.trim(),
                ),
              ),
              new Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                  child: SizedBox(
                    height: 50.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      color: Colors.blue,
                      child: new Text('เข้าสู่ระบบ',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: validateAndSubmit,
                    ),
                  )),
              Row(
               /* mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ยังไม่มีบัญชีใช่หรือไม่',
                      style: new TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w300)),
                  new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Signup_Page()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: Text("สมัครเลย",
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue)),
                      )),
                ], */
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
